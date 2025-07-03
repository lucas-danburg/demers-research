function F = simpsons(M, dxdy)
    % function to approximate the 2d integral of a function using Simpson's rule.
    % M is an n x m matrix (or a vector) of function values, where n and m must be odd.
    % dxdy is the product of the widths of the variables of integration,
    % so if the outer integral is from a to b, dy = (b - a) / number of y values.
    [n, m] = size(M);

    if mod(n, 2) == 0 | mod(m, 2) == 0 % if n and m are not odd, complain
        error(sprintf('Error in function `simpsons` in file `simpsons.m`: an input with size [%d, %d] was passed, but both dimensions must be odd.', n, m))
    end

    wn = [repmat([2, 4], 1, (n - 1) / 2), 1]; % row vector of weights for the row values
    wn(1, 1) = 1;
    wm = [repmat([2; 4], (m - 1) / 2, 1); 1]; % column vector of weight for column values
    wm(1, 1) = 1;
    W = wm * wn; % matrix of weights
    F = dxdy / 9 * sum(sum(W .* M));
end