function density = D(T, table)
    % function to get a density matrix corresponding to a matrix of t-values
    % this is in case of tables where t is not an arc length parameter
    [n, m] = size(T);
    density = zeros(n, m);
    x = cell(size(table, 1), 1);
    y = cell(size(table, 1), 1);
    for p = 1:size(table, 1)
        syms t;
        x{p} = inline(char(diff(eval(char(table{p, 1})), t)));   %x'(t) for piece
        y{p} = inline(char(diff(eval(char(table{p, 2})), t)));   %y'(t) for piece
    end

    for i = 1:n
        for j = 1:m
            tval = T(i, j);
            p = piece(tval, table);
            density(i, j) = sqrt(x{p}(tval)^2 + y{p}(tval)^2);
        end
    end
    %disp('did density')
end
