function [name, f] = phi_ones(table_params, table)
    % a function that RETURNS A FUNCTION takes in phi as an input,
    % and returns -1 if abs(phi) > pi/6, or returns 1 otherwise
    name = 'phi-ones';
    f = @(iangles_i, ts_i, iangles_f, ts_f) (abs(iangles_i) > pi/6) .* -1 + (abs(iangles_i) <= pi/6) .* 1;
end