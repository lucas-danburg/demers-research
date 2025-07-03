function value = f(x)
    value = histogram(x)
end


function xs = x(ts, table)
    %disp('x() called')
    % function to get an x value (or values) from a t value (or values)
    [n, m] = size(ts);
    xs = zeros(n, m);
    for ii = 1:n
        for jj = 1:m
            t = ts(ii, jj);
            xf = table{piece(t), 1};
            xs(ii, jj) = xf(t);
        end
    end
end

function ys = y(ts, table)
    %disp('y() called')
    % function to get a y value (or values) from a t value (or values)
    [n, m] = size(ts);
    ys = zeros(n, m);
    for ii = 1:n
        for jj = 1:m
            t = ts(ii, jj);
            yf = table{piece(t), 2};
            ys(ii, jj) = yf(t);
        end
    end
end

f(x) = sqrt((x(ts_f, table) - x(ts_i, table)).^2 + (y(ts_f, table) - y(ts_i, table)).^2) - tau_bar; % construct normalized f
