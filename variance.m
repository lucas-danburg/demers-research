function sigma2 = variance(initcond, data, table)
    % data is the handles.data object
    % initcond is the handles.initcond object
    % table is handles.table, needed to find the length of the boundary

    datamat = cat(3, data{:}); % convert the cell array to a 3d normal array
    % this array now has shape (# of iterations, 4, # of initial conditions)
    % the 4 is there because we record [t, horizontal angle, incident angle, piece]
    % and we record n t values, n horiz angle values, etc for n iterations.

    datamat = datamat(:, [1, 3], :); % trim to only t and incident angle
    % new size: [# of iterations, 2, # of initial conditions]

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

    ts_0 = datamat(1, 1, :); % first iteration, get t only, all initial condtions
    ts_0 = ts_0(:); % flatten to 1d array
    iangles_0 = datamat(1, 2, :);
    iangles_0 = iangles_0(:);

    ts_1 = datamat(2, 1, :); % second iteration, get t only, all initial condtions
    ts_1 = ts_1(:); % flatten to 1d array
    iangles_1 = datamat(2, 2, :);
    iangles_1 = iangles_1(:);

    % now ts_0 and iangles_0 are equivalent to
    % `[Ts_0, Iangles_0] = meshgrid(ts, iangles)
    %  ts_0 = Ts_0(:)
    %  iangles_0 = Iangles_0(:)`
    % as in lines ~930 - 940 of billiards.m

    % NOW we can finally calculate some things
    % perhaps a good first step is picking an f function. it must be 1) integrable over the 
    % phase space X, so the integral has to be finite. it will also be helpful if it has an
    % expectation value of 0, so we may need to "normalize" it, or shift it such that its
    % integral over X dm is 0.
    % try to pick f(t, phi) = sqrt((t1 - t)^2 + (phi1 - phi)^2)
    syms a; % define a shifting constant symbolically
    f = sqrt((ts_1 - ts_0).^2 + (iangles_1 - iangles_0).^2) + a;
    eqn = 0 == E(ts_0, iangles_0, f, table); % set the integral over X of*dm equal to zero
    a_sol = double(solve(eqn, a)); % solve for the constant a
    f = @(ts, iangles) sqrt((ts_1 - ts).^2 + (iangles_1 - iangles).^2) + a_sol % construct normalized f

    % now try to find sigma^2
    sigma2 = E(ts_0, iangles_0, f(ts_0, iangles_0).^2, table) % plus the other sum-integral
end

function int_Xdm = E(ts, iangles, f_vals, table)
    % function to take the integral over phase space X (t, phi) of some function values
    % f_vals times delta-m (with respect to the measure m)
    t_lower = table{1, 3};
    t_upper = table{size(table, 1), 4};
    t_len = t_upper - t_lower; % and iangle-len = pi

    n_init = size(ts, 1); % number of initial conditions
    % we cannot find delta-phi or delta-t on their own but we can find their product
    % dphi = pi / n_phi             dt = t_len / n_t
    % dphi*dt = pi * t_len / (n_phi * n_t) = pi * t_len / n_init
    dpdt = pi * t_len / n_init;
    dm = 1 / (2 * t_len) .* cos(iangles) .* dpdt; % t_len is the boundary length dQ as well

    int_Xdm = sum(f_vals .* dm); % sum (integral) of f^2(t, phi) dm
end