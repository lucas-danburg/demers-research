function [name, f] = tau(table_params, table)
    % function that returns a FUNCTION (not a value)
    % this function is the normalized tau function
    w = table_params(1);
    r = table_params(2);
    rho = table_params(3);
    delta = table_params(4);
    tau_bar = pi * Q(w, delta, r, rho) / dQ(w, delta, r, rho);
    name = 'tau';
    f = @(iangles_i, ts_i, iangles_f, ts_f) sqrt((x_val(ts_f, table) - x_val(ts_i, table)).^2 + (y_val(ts_f, table) - y_val(ts_i, table)).^2) - tau_bar; % construct normalized f
end