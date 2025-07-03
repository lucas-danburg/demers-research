function ys = y(ts, table)
    %disp('y() called')
    % function to get a y value (or values) from a t value (or values)
    [n, m] = size(ts);
    ys = zeros(n, m);
    for ii = 1:n
        for jj = 1:m
            t = ts(ii, jj);
            yf = table{piece(t, table), 2};
            ys(ii, jj) = yf(t);
        end
    end
end