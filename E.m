function int_Xdm = E(Iangles_0, f_vals, table_params, generation, table)
    % function to take the integral over phase space X (t, phi) of some function values
    % f_vals times delta-m (with respect to the measure m)

    w = table_params(1);
    r = table_params(2);
    rho = table_params(3);
    delta = table_params(4);

    t_len = table{end, 4} - table{1, 3};
    % we can find dpdt without knowing dp or dt themselves
    % dt = t_len / n_ts
    % dp = pi / n_iangles
    % dpdt = t_len * pi / n_trajectories
    dpdt = t_len * pi / generation(3);

    int_Xdm = sum(sum(f_vals .* (1 / (2 * dQ(w, delta, r, rho)) .* cos(Iangles_0)) .* dpdt)); % sum (integral) of f(t, phi)*dm
end