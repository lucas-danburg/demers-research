function [sigma2s, second_terms] = variance(initcond, generation, data, table, table_params, f_generator)
    % data is the handles.data object
    % initcond is the handles.initcond object
    % generation is the handles.generation object
    % table is handles.table, needed to find the length of the boundary
    % table_params is the handles.table_params object
    % f_generator is a function that takes in table_params and table and outputs
    % another function that will be the observable. the outputted function is a function of
    % (current phi vals, current t vals, next phi vals, next t vals). the two currently implimented
    % f_generator options are `tau` and `phi_ones`

    datamat = cat(3, data{:}); % convert the cell array to a 3d normal array
    % this array now has shape (# of iterations, 4, # of initial conditions)
    % the 4 is there because we record [t, horizontal angle, incident angle, piece]
    % and we record n t values, n horiz angle values, etc for n iterations.

    clear data; % release objects from memory manually

    datamat = datamat(:, [1, 3], :); % trim to only t and incident angle
    % new size: [# of iterations, 2, # of initial conditions]
    [n_iter, tp, n_condit] = size(datamat);

    % data does not include initcond, so we need to prepend them to data
    initcondmat = cell2mat(initcond'); % first convert to a 2d array
    % (size = [# of initial conditions, 5 (xo, yo, ao, to, iangleo)])

    clear initcond;

    initcondmat = initcondmat(:, [4, 5]); % keep only to and iangle (size = [# init cond, 2])

    % now make initcond mat into a 3d array with only one entry for the first dimension
    % because it contain only one iteration (the zeroeth iteration)
    initcondmat_3d(1, :, :) = initcondmat'; % 1st (0th) iteration, both t and iangle, all initial conditions
    % size = [1 (for one iteration), 2 (both t and iangle), # of initial conditions]
    % not sure why the constant transposes are necessary

    clear initcondmat;

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

    % pre allocate the loop objects
    ts_i = zeros(n_iangles * n_ts);
    iangles_i = zeros(n_iangles * n_ts);
    Ts_i = zeros(n_iangles, n_ts);
    Iangles_i = zeros(n_iangles, n_ts);

    matdat_t = cell(n_iter + 1); % make another one holding actual matrices of t values only
    matdat_phi = cell(n_iter + 1); % make another one holding actual matrices of phi values only
    % also get a matrix of phi values of all the initial conditions, this is needed for the integrals
    Iangles_0 = [];
    for i = 1:(n_iter + 1) % for each iteration + 1
        ts_i = datamat(i, 1, :); % ith iteration, t only, all initial conditions

        iangles_i = datamat(i, 2, :); % same for phi/incident angle

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

        matdat_t{i} = Ts_i;
        matdat_phi{i} = Iangles_i;
    end

    clear ts_i iangles_i Ts_i Iangles_i;

    % this good because now we can use this to construct a new cell array with
    % length = # of iterations where each cell is a n_ts x n_iangles matrix
    % and each element of the matrix is the value of an observable f(t, phi).
    % this can then be handled nicely with 2d integrals of f

    % create f
    [f_name, f] = f_generator(table_params, table);

    sigma2s = zeros(1, n_iter); % calculate sigma2 for each iteration
    second_terms= zeros(1, n_iter); % also keep track of each term in the sum

    T1 = matdat_t{1};
    Dens = Density(T1, table);

    f0_vals = f(matdat_phi{1}, matdat_t{1}, matdat_phi{2}, matdat_t{2});
    f0_vals(isnan(f0_vals)) = 0; % set NaN tau values to zero to resolve missing data

    % for each iteration
    for i = 1:n_iter
        % get the current matrices
        Ti = matdat_t{i};
        Pi = matdat_phi{i};

        % get the next t's, since these are T^i(t, phi) values
        % with those values, we can compute tau = f(ts, ts1)
        Ti1 = matdat_t{i + 1};
        Pi1 = matdat_phi{i + 1};

        fi_vals = f(Pi, Ti, Pi1, Ti1);
        fi_vals(isnan(fi_vals)) = 0; % set NaN tau values to zero to resolve missing data
        
        second_terms(i) = (1 - i/n_iter) * E(Iangles_0, f0_vals .* fi_vals .* Dens, table_params, generation, table);
        sigma2s(i) = sum(second_terms(1:i));
    end

    % finally, add the first integral to each element
    sigma2s = 2 .* sigma2s + E(Iangles_0, f0_vals.^2 .* Dens, table_params, generation, table);

    n_ts = generation(1);
    n_iangles = generation(2);
    n_traj = generation(3);
    w = table_params(1);
    r = table_params(2);
    rho = table_params(3);
    delta = table_params(4);

    ttau = w/2 - (delta*rho + (1 - delta) * pi * rho/4); % the distance between the side of the table and the squircle
    l1 = 2 * ttau * delta / rho + 1 + sqrt(4 * ttau^2 * delta^2 / rho^2 + 4 * ttau * delta / rho); % lambda_1, first eigenvalue

    var = sigma2s;
    terms = second_terms;
    nmax = n_iter;

    % graph variance first
    figure
    plot([0:(nmax - 1)], var)
    ylim([-2, 8])
    title(sprintf('Variance with f=%s for %d x %d grid (%d attempted, %d successful), w = %d, R = %d, rho = %d, delta = %0.2f', f_name, n_ts, n_iangles, n_ts * n_iangles, n_traj, w, r, rho, delta))

    figure
    plot([0:(nmax - 1)], terms)
    ylim([-0.2, 1.2])
    title(sprintf('Variance terms with f=%s for %d x %d grid (%d attempted, %d successful), w = %d, R = %d, rho = %d, delta = %0.2f', f_name, n_ts, n_iangles, n_ts * n_iangles, n_traj, w, r, rho, delta))

    figure
    plot(log(l1) * [0:(nmax - 1)], -log(abs(terms)))
    ylim([-2, 15])
    title(sprintf('-ln(Variance terms) vs. ln(l1)*k with f=%s for %d x %d grid (%d attempted, %d successful), w = %d, R = %d, rho = %d, delta = %0.2f', f_name, n_ts, n_iangles, n_ts * n_iangles, n_traj, w, r, rho, delta))
end
% TODO: re-run graphs