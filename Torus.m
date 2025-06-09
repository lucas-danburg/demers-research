function table = torus(R, r, t0)
%R = Major radius
%r = minor radius
%t0 = initial time

global table
table = [];

%  1.
table{1, 1} = @(t) t;
table{1, 2} = @(t) 0;
table{1, 3} = t0;
table{1, 4} = t0 + 2*pi;
table{1, 5} = 1;

%  2.
table{2, 1} = @(t) 2*pi;
table{2, 2} = @(t) t - table{1, 4};
table{2, 3} = table{1, 4};
table{2, 4} = table{2, 3} + 2*pi;
table{2, 5} = 1;

%  3.
table{3, 1} = @(t) 6*pi - t;
table{3, 2} = @(t) 2*pi;
table{3, 3} = table{2, 4};
table{3, 4} = table{3, 3} + 2*pi;
table{3, 5} = 1;

%  4.
table{4, 1} = @(t) 0;
table{4, 2} = @(t) 8*pi - t;
table{4, 3} = table{3, 4};
table{4, 4} = table{4, 3} + 2*pi;
table{4, 5} = 1;
end


theta = table{i, 1}(t);
phi = table{i, 2}(t);
x = (r + r*co(phi)) * cos(theta);
y = (r + r*co(phi)) * sin(theta);
z = r * sin(phi);






