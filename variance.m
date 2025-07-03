function [sigma2s, second_terms] = variance(initcond, generation, data, table, table_params)
    % data is the handles.data object
    % initcond is the handles.initcond object
    % generation is the handles.generation object
    % table is handles.table, needed to find the length of the boundary
    % table_params is the handles.table_params object

    datamat = cat(3, data{:}); % convert the cell array to a 3d normal array
    % this array now has shape (# of iterations, 4, # of initial conditions)
    % the 4 is there because we record [t, horizontal angle, incident angle, piece]
    % and we record n t values, n horiz angle values, etc for n iterations.

    datamat = datamat(:, [1, 3], :); % trim to only t and incident angle
    % new size: [# of iterations, 2, # of initial conditions]
    [n_iter, tp, n_condit] = size(datamat);

    % data does not include initcond, so we need to prepend them to data
    initcondmat = cell2mat(initcond'); % first convert to a 2d array
    % (size = [# of initial conditions, 5 (xo, yo, ao, to, iangleo)])

    initcondmat = initcondmat(:, [4, 5]); % keep only to and iangle (size = [# init cond, 2])

    % now make initcond mat into a 3d array with only one entry for the first dimension
    % because it contain only one iteration (the zeroeth iteration)
    initcondmat_3d(1, :, :) = initcondmat'; % 1st (0th) iteration, both t and iangle, all initial conditions
    % size = [1 (for one iteration), 2 (both t and iangle), # of initial conditions]
    % not sure why the constant transposes are necessary

    datamat = cat(1, initcondmat_3d, datamat); % now prepend the initial conditions
    % to the iteration data along the first dimension (the iteration dimension)
    %disp('original operations')
    % now reshape the data
    % the current shape is [# of iterations + 1, 2, # of initial conditions]
    % but in order to perform a proper 2d integral over t and phi for each iteration,
    % the t and phi values need to be placed into a proper grid.
    % the new shape should be:
    %   [# of iterations, number of initial t values, number of initial phi values, 2]
    % so that on the outside there is an array of length (# of iterations), and each element
    % of the array is a n_ts x n_iangles matrix, and each element of the matrix is a tuple of
    % length 2 containing (t, phi).
    n_ts = generation(1);
    n_iangles = generation(2);


    matdat = cell(n_iter + 1, n_ts, n_iangles); % initialize a cell array of appropriate shape
    matdat_t = cell(n_iter + 1); % make another one holding actual matrices of t values only
    % also get a matrix of phi values of all the initial conditions, this is needed for the integrals
    Iangles_0 = [];
    for i = 1:(n_iter + 1) % for each iteration + 1
        ts_i = datamat(i, 1, :); % ith iteration, t only, all initial conditions
        ts_i = ts_i(:); % flatten to a 1d array just in case

        iangles_i = datamat(i, 2, :); % same for phi/incident angle
        iangles_i = iangles_i(:);

        % now ts_i and iangles_i are equivalent to
        % `[Ts_i, Iangles_i] = meshgrid(ts, iangles)
        %  ts_i = Ts_i(:)
        %  iangles_i = Iangles_i(:)`
        % as in lines ~930 - 940 of billiards.m
        % now we want to recover them into the same form as Ts_i and Iangles_i
        % that is, size(ts_i) = [n_ts * n_iangles, 1] currently, and we want to transform
        % it into Ts_i with size = [n_ts, n_iangles]

        Ts_i = reshape(ts_i, n_iangles, n_ts);
        Iangles_i = reshape(iangles_i, n_iangles, n_ts);

        if i == 1
            Iangles_0 = Iangles_i;
        end

        % and now array the Ts_i and Iangles_i values into a ts_i x iangles_i meshgrid
        % where each element is [t, phi]
        % disclaimer: github copilot generated the following line and i dont know
        % what UniformOutput or false do
        M = arrayfun(@(t, phi) [t, phi], Ts_i, Iangles_i, 'UniformOutput', false);
        Mt = cell2mat(arrayfun(@(t, phi) t, Ts_i, Iangles_i, 'UniformOutput', false));
        matdat{i} = M;
        matdat_t{i} = Mt;
    end
    % this good because now we can use this to construct a new cell array with
    % length = # of iterations where each cell is a n_ts x n_iangles matrix
    % and each element of the matrix is the value of an observable f(t, phi).
    % this can then be handled nicely with 2d integrals of f

    % create f = the euclidian distance between collisions
    f = tau(table_params, table);

    sigma2s = zeros(1, n_iter); % calculate sigma2 for each iteration
    second_terms= zeros(1, n_iter); % also keep track of each term in the sum
    T1 = matdat_t{1};
    Dens = Density(T1, table);
    f0_vals = f(matdat_t{1}, matdat_t{2});
    f0_vals(isnan(f0_vals)) = 0; % set NaN tau values to zero to resolve missing data
    % for each iteration
    for i = 1:n_iter
        % get the current t matrix
        Ti = matdat_t{i};

        % get the next t's, since these are T^i(t, phi) values
        % with those values, we can compute tau = f(ts, ts1)
        Ti1 = matdat_t{i + 1};

        fi_vals = f(Ti, Ti1);
        fi_vals(isnan(fi_vals)) = 0; % set NaN tau values to zero to resolve missing data
        second_terms(i) = E(Iangles_0, f0_vals .* fi_vals .* Dens, table_params, generation, table);
        sigma2s(i) = sum(second_terms(1:i));
    end

    % finally, add the first integral to each element
    sigma2s = 2 .* sigma2s + E(Iangles_0, f0_vals.^2 .* Dens, table_params, generation, table);
end
% TODO: re-run graphs