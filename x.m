function xs = x(ts, table)
    %disp('x() called')
    % function to get an x value (or values) from a t value (or values)
    [n, m] = size(ts);
    xs = zeros(n, m);
    for ii = 1:n
        for jj = 1:m
            t = ts(ii, jj);
            xf = table{piece(t, table), 1};
            xs(ii, jj) = xf(t);
        end
    end
end