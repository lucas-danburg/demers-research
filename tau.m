function f = tau(table_params, table)
    % function that returns a FUNCTION (not a value)
    % this function is the normalized tau function
    w = table_params(1);
    r = table_params(2);
    rho = table_params(3);
    delta = table_params(4);
    tau_bar = pi * Q(w, delta, r, rho) / dQ(w, delta, r, rho);
    f = @(ts_i, ts_f) sqrt((x(ts_f, table) - x(ts_i, table)).^2 + (y(ts_f, table) - y(ts_i, table)).^2) - tau_bar; % construct normalized f
end