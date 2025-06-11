function table=sinai(w,r,rho,to)
global table
table=cell(8,5);

% Parameters
L = w - 2*r;      % length of straight segment
A = pi/2*r;       % length of arc (quarter circle)
to = 0;           % starting parameter for first arc

% 1. Bottom-right arc: center at (w/2 - r, -w/2 + r), angle = 3*pi/2 + (t-to)/r, t in [to, to+A]
table{1,1} = inline([num2str(w/2 - r), '+', num2str(r), '*cos(pi/2 + (t-', num2str(to), ')/', num2str(r), ')'], 't');
table{1,2} = inline([num2str(-w/2 + r), '+', num2str(r), '*sin(pi/2 + (t-', num2str(to), ')/', num2str(r), ')'], 't');
table{1,3} = to;
table{1,4} = to + A;
table{1,5} = 2;

% 2. Bottom edge: from (w/2-r, -w/2+r) to (-w/2+r, -w/2+r)
table{2,1} = inline(['-t+',num2str(w/2-r+table{1,4})],'t');
table{2,2} = inline(num2str(-w/2+r),'t');
table{2,3} = table{1,4} + r;
table{2,4} = table{2,3} + w - 4*r;
table{2,5} = 1;

% 3. Bottom-left arc: angle = pi + (t-t2)/r, t in [t2, t2+A]
table{3,1} = inline([num2str(-w/2 + r), '+', num2str(r), '*cos(0 + (t-', num2str(table{2,4}), ')/', num2str(r), ')'], 't');
table{3,2} = inline([num2str(-w/2 + r), '+', num2str(r), '*sin(0 + (t-', num2str(table{2,4}), ')/', num2str(r), ')'], 't');
table{3,3} = table{2,4};
table{3,4} = table{3,3} + A;
table{3,5} = 2;

% 4. Left edge: from (-L/2, L/2) to (-L/2, -L/2)
table{4,1}=inline(num2str(-L/2),'t');
table{4,2}=inline(['-t+',num2str(L/2 + table{3,4})],'t');
table{4,3}=table{3,4} + r;
table{4,4}=table{4,3} + w - 4*r;
table{4,5}=1;

% 5. Top-left arc: from (-L/2, L/2) to (-L/2, L/2)
% Parameterize by arc length s, angle = pi/2 + s/r, s in [0, A]
table{5,1} = inline([num2str(-w/2 + r), '+', num2str(r), '*cos(3*pi/2 + (t-', num2str(table{4,4}), ')/', num2str(r), ')'], 't');
table{5,2} = inline([num2str(w/2 - r), '+', num2str(r), '*sin(3*pi/2 + (t-', num2str(table{4,4}), ')/', num2str(r), ')'], 't');
table{5,3}=table{4,4};
table{5,4}=table{5,3} + A;
table{5,5}=2;

% 6. Top edge: from (L/2, L/2) to (-L/2, L/2)
table{6,1}=inline(['-t+',num2str(L/2 + table{5,4})],'t');
table{6,2}=inline(num2str(L/2),'t');
table{6,3}=table{5,4} + r;
table{6,4}=table{6,3} + w - 4*r;
table{6,5}=1;

% 7. Top-right arc: from (L/2, L/2) to (L/2, L/2)
% Parameterize by arc length s, angle = 0 + s/r, s in [0, A]
table{7,1} = inline([num2str(w/2 - r), '+', num2str(r), '*cos(pi + (t-', num2str(table{6,4}), ')/', num2str(r), ')'], 't');
table{7,2} = inline([num2str(w/2 - r), '+', num2str(r), '*sin(pi + (t-', num2str(table{6,4}), ')/', num2str(r), ')'], 't');
table{7,3}=table{6,4};
table{7,4}=table{7,3} + A;
table{7,5}=2;

% 8. Right edge: from (L/2, -L/2) to (L/2, L/2)
table{8,1}=inline(num2str(L/2),'t');
table{8,2}=inline(['t-',num2str(table{7,4}+L/2)],'t');
table{8,3}=table{7,4} + r;
table{8,4}=table{8,3} + w - 4*r;
table{8,5}=1;

hold on;
for n=1:8
ezplot(table{n,1}, table{n,2}, [table{n,3}, table{n,4}]);
end
axis equal
hold off
end
