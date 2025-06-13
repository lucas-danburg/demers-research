function sigma2s = variance(initcond, data, table)
    % data is the handles.data object
    % initcond is the handles.initcond object
    % table is handles.table, needed to find the length of the boundary

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

    ts_0 = datamat(1, 1, :); % first iteration, get t only, all initial condtions
    ts_0 = ts_0(:); % flatten to 1d array
    iangles_0 = datamat(1, 2, :); % same for phi/incident angle
    iangles_0 = iangles_0(:);

    ts_1 = datamat(2, 1, :); % second iteration, get t only, all initial condtions
    ts_1 = ts_1(:); % flatten to 1d array
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
    % try to pick f(t, phi) = sqrt((x1 - x)^2 + (y1 - y)^2)
    f = sqrt((x(ts_1, table) - x(ts_0, table)).^2 + (y(ts_1, table) - y(ts_0, table)).^2);
    avf = E(ts_0, iangles_0, f, table); % average tau
    f = @(ts_i, ts_f) sqrt((x(ts_f, table) - x(ts_i, table)).^2 + (y(ts_f, table) - y(ts_i, table)).^2) - avf; % construct normalized f
    sigma2s = zeros(1, n_iter); % calculate sigma2 for each iteration
    f0_vals = f(ts_0, ts_1);
    % for each iteration
    for i = 1:n_iter
        % get the current t's
        ts_i = datamat(i, 1, :);
        ts_i = ts_i(:);

        % get the next t's, since these are T^i(t, phi) values
        % with those values, we can compute tau = f(ts, ts1)
        ts_i1 = datamat(i + 1, 1, :);
        ts_i1 = ts_i1(:);

        sigma2s(i) = 2 * (sum(sigma2s(1:i-1)) + E(ts_0, iangles_0, f0_vals .* f(ts_i, ts_i1), table));
    end

    % finally, add the first integral to each element
    sigma2s = sigma2s + E(ts_0, iangles_0, f0_vals.^2, table);
end

% HELPER FUNCTIONS:
function int_Xdm = E(ts_0, iangles_0, f_vals, table)
    % function to take the integral over phase space X (t, phi) of some function values
    % f_vals times delta-m (with respect to the measure m)

    t_lower = table{1, 3};
    t_upper = table{size(table, 1), 4};
    t_len = t_upper - t_lower; % and iangle-len = pi
    n_init = size(ts_0, 1); % number of initial conditions

    % we cannot find delta-phi or delta-t on their own but we can find their product
    % dphi = pi / n_phi             dt = t_len / n_t
    % dphi*dt = pi * t_len / (n_phi * n_t) = pi * t_len / n_init
    dpdt = pi * t_len / n_init;
    dm = 1 / (2 * t_len) .* cos(iangles_0) .* dpdt; % t_len is the boundary length dQ as well

    int_Xdm = sum(f_vals(:) .* dm(:)); % sum (integral) of f^2(t, phi) dm
end

function xs = x(ts, table)
    % function to get an x value (or values) from a t value
    xs = zeros(1, length(ts));
    for ii = 1:length(ts)
        t = ts(ii);
        xf = table{piece(table, t), 1};
        xs(ii) = xf(t);
    end
end

function ys = y(ts, table)
    % function to get a y value (or values) from a t value
    ys = zeros(1, length(ts));
    for ii = 1:length(ts)
        t = ts(ii);
        yf = table{piece(table, t), 2};
        ys(ii) = yf(t);
    end
end