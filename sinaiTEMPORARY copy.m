function table=sinai(w,r,to)
global table
table=[];

L = w - 2*r;      % length of straight segment
A = pi/2*r;       % length of arc (quarter circle)

% 1. Bottom edge: from (w/2-r, -w/2+r) to (-w/2+r, -w/2+r)
table{1,1}=inline(['-t+',num2str(L/2 + to)],'t');
table{1,2}=inline(num2str(-w/2+r),'t');
table{1,3}=to;
table{1,4}=table{1,3} + L;
table{1,5}=1;

% 2. Bottom-right arc: from (-w/2+r, -w/2+r) to (w/2-r, -w/2+r)
% Parameterize by arc length s, angle = 3*pi/2 + s/r, s in [0, A]
table{2,1}=inline([num2str(L/2), '+', num2str(r), '*cos(3*pi/2 + (t-',num2str(table{1,4}),')/',num2str(r),')'] ,'t');
table{2,2}=inline([num2str(-L/2), '+', num2str(r), '*sin(3*pi/2 + (t-',num2str(table{1,4}),')/',num2str(r),')'],'t');
table{2,3}=table{1,4};
table{2,4}=table{2,3} + A;
table{2,5}=2;

% 3. Right edge: from (w/2-r, -w/2+r) to (w/2-r, w/2-r)
table{3,1}=inline(num2str(L/2),'t');
table{3,2}=inline(['t-',num2str(table{2,4}+L/2)],'t');
table{3,3}=table{2,4};
table{3,4}=table{3,3} + L;
table{3,5}=1;

% 4. Top-right arc: from (w/2-r, w/2-r) to (w/2-r, w/2-r)
% Parameterize by arc length s, angle = 0 + s/r, s in [0, A]
table{4,1}=inline([num2str(L/2), '+', num2str(r), '*cos(0 + (t-',num2str(table{3,4}),')/',num2str(r),')'],'t');
table{4,2}=inline([num2str(L/2), '+', num2str(r), '*sin(0 + (t-',num2str(table{3,4}),')/',num2str(r),')'],'t');
table{4,3}=table{3,4};
table{4,4}=table{4,3} + A;
table{4,5}=2;

% 5. Top edge: from (w/2-r, w/2-r) to (-w/2+r, w/2-r)
table{5,1}=inline(['-t+',num2str(L/2 + table{4,4})],'t');
table{5,2}=inline(num2str(L/2),'t');
table{5,3}=table{4,4};
table{5,4}=table{5,3} + L;
table{5,5}=1;

% 6. Top-left arc: from (-w/2+r, w/2-r) to (-w/2+r, w/2-r)
% Parameterize by arc length s, angle = pi/2 + s/r, s in [0, A]
table{6,1}=inline([num2str(-L/2), '+', num2str(r), '*cos(pi/2 + (t-',num2str(table{5,4}),')/',num2str(r),')'],'t');
table{6,2}=inline([num2str(L/2), '+', num2str(r), '*sin(pi/2 + (t-',num2str(table{5,4}),')/',num2str(r),')'],'t');
table{6,3}=table{5,4};
table{6,4}=table{6,3} + A;
table{6,5}=2;

% 7. Left edge: from (-w/2+r, w/2-r) to (-w/2+r, -w/2+r)
table{7,1}=inline(num2str(-L/2),'t');
table{7,2}=inline(['-t+',num2str(L/2 + table{6,4})],'t');
table{7,3}=table{6,4};
table{7,4}=table{7,3} + L;
table{7,5}=1;

% 8. Bottom-left arc: from (-w/2+r, -w/2+r) to (w/2-r, -w/2+r)
% Parameterize by arc length s, angle = pi + s/r, s in [0, A]
table{8,1}=inline([num2str(-L/2), '+', num2str(r), '*cos(pi + (t-',num2str(table{7,4}),')/',num2str(r),')'],'t');
table{8,2}=inline([num2str(-L/2), '+', num2str(r), '*sin(pi + (t-',num2str(table{7,4}),')/',num2str(r),')'],'t');
table{8,3}=table{7,4};
table{8,4}=table{8,3} + A;
table{8,5}=2;

hold on;
for n=1:8
    ezplot(table{n,1}, table{n,2}, [table{n,3}, table{n,4}]);
end
axis equal
hold off
end
