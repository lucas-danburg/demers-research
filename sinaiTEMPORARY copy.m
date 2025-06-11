function table=sinaiTEMPORARY(w, r, rho, to)
table = cell(8,5);

% 1. Bottom-right arc
table{1,1} = inline([num2str(w/2), '+', num2str(r), '*cos(t/', num2str(r), '+pi/2)']);
table{1,2} = inline([num2str(-w/2), '+', num2str(r), '*sin(t/', num2str(r), '+pi/2)']);
table{1,3} = 0;
table{1,4} = pi/2*r;
table{1,5} = 2;
disp(table{1,2})

% 2. Bottom edge
table{2,1} = inline(['-t+', num2str(w/2-r+table{1,4})]);
table{2,2} = inline([num2str(-w/2)]);
table{2,3} = table{1,4};
table{2,4} = table{2,3} + w - 2*r;
table{2,5} = 1;

% 3. Bottom-left arc
table{3,1} = inline([num2str(-w/2), '+', num2str(r), '*cos(t/', num2str(r), '-', num2str(table{2,4}./r), ')']);
table{3,2} = inline([num2str(-w/2), '+', num2str(r), '*sin(t/', num2str(r), '-', num2str(table{2,4}/r), ')']);
table{3,3} = table{2,4};
table{3,4} = table{3,3} + pi/2*r;
table{3,5} = 2;

hold on;
for n=1:3
    ezplot(table{n,1}, table{n,2}, [table{n,3}, table{n,4}]);
end
axis equal
hold off
end
