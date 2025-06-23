function table=squirclecell(w,r,rho,delta,to)
global table
table={12,5};

if (rho + r) < (w/2)
    error('The inner squircle and corner arcs combined are too small to block trajectories.');
end
    
% delta constraints (morphing parameter between 0 and 1)
if delta < 0 || delta > 1
    error('Delta must be between 0 and 1.');
end

%if (rho + r) < 


    % Parameters
    L = w - 2*r;      % length of straight segment
    A = pi/2*r;       % length of arc (quarter circle)
    to = 0;           % starting parameter for first arc
    
    % 1. Bottom-right arc: center at (w/2, -w/2), angle = pi/2 to pi
    table{1,1} = inline([num2str(w/2), '+', num2str(r), '*cos(pi/2 + (t-', num2str(to), ')/', num2str(r), ')'], 't');  % X(t)
    table{1,2} = inline([num2str(-w/2), '+', num2str(r), '*sin(pi/2 + (t-', num2str(to), ')/', num2str(r), ')'], 't'); % Y(t)
    table{1,3} = to;     % Start time
    table{1,4} = to + A; % End time
    table{1,5} = 2;      % Determines type of boundary
    
    % 2. Bottom edge: from (w/2, -w/2) to (-w/2, -w/2)
    table{2,1} = inline(['-t+',num2str(L/2 + table{1,4})], 't');
    table{2,2} = inline(num2str(-w/2) ,'t');
    table{2,3} = table{1,4};
    table{2,4} = table{2,3} + L;
    table{2,5} = 1;
    
    % 3. Bottom-left arc: angle = pi to 3*pi/2
    table{3,1} = inline([num2str(-w/2), '+', num2str(r), '*cos(0 + (t-', num2str(table{2,4}), ')/', num2str(r), ')'], 't');
    table{3,2} = inline([num2str(-w/2), '+', num2str(r), '*sin(0 + (t-', num2str(table{2,4}), ')/', num2str(r), ')'], 't');
    table{3,3} = table{2,4};
    table{3,4} = table{3,3} + A;
    table{3,5} = 2;
    
    % 4. Left edge: from (-w/2, -w/2) to (-w/2, w/2)
    table{4,1}=inline(num2str(-w/2),'t');
    table{4,2}=inline(['t+',num2str(-L/2 - table{3,4})],'t');
    table{4,3}=table{3,4};
    table{4,4}=table{4,3} + L;
    table{4,5}=1;
    
    % 5. Top-left arc: angle = 3*pi/2 to 0
    table{5,1} = inline([num2str(-w/2), '+', num2str(r), '*cos(3*pi/2 + (t-', num2str(table{4,4}), ')/', num2str(r), ')'], 't');
    table{5,2} = inline([num2str(w/2), '+', num2str(r), '*sin(3*pi/2 + (t-', num2str(table{4,4}), ')/', num2str(r), ')'], 't');
    table{5,3}=table{4,4};
    table{5,4}=table{5,3} + A;
    table{5,5}=2;
    
    % 6. Top edge: from (-w/2, w/2) to (w/2, w/2)
    table{6,1}=inline(['t+',num2str(-L/2 - table{5,4})], 't');
    table{6,2}=inline(num2str(w/2), 't');
    table{6,3}=table{5,4};
    table{6,4}=table{6,3} + L;
    table{6,5}=1;
    
    % 7. Top-right arc:angle = 0 to pi/2 
    table{7,1} = inline([num2str(w/2), '+', num2str(r), '*cos(pi + (t-', num2str(table{6,4}), ')/', num2str(r), ')'], 't');
    table{7,2} = inline([num2str(w/2), '+', num2str(r), '*sin(pi + (t-', num2str(table{6,4}), ')/', num2str(r), ')'], 't');
    table{7,3}=table{6,4};
    table{7,4}=table{7,3} + A;
    table{7,5}=2;
    
    % 8. Right edge: from (w/2, -w/2) to (w/2, w/2)
    table{8,1}=inline(num2str(w/2),'t');
    table{8,2}=inline(['-t+',num2str(table{7,4} + L/2)], 't');
    table{8,3}=table{7,4};
    table{8,4}=table{8,3} + L;
    table{8,5}=1;

% 9. Middle squircle:

%alpha = ['(t/', num2str(rho), ' - pi/2*round(2*t/(', num2str(rho), '*pi)))'];

% f(t) - circle
%fx = ['cos(t/', num2str(rho), ')'];
%fy = ['sin(t/', num2str(rho), ')'];

% g(t) - square (substitute alpha_str directly)
%gx = ['(2*pi*', num2str(rho), '/8)*cos(t/', num2str(rho), ')/cos', alpha];
%gy = ['(2*pi*', num2str(rho), '/8)*sin(t/', num2str(rho), ')/cos', alpha];

% 9. Middle squircle:

    table{9,1} = inline([num2str(delta*rho),'*cos((t-(pi*',num2str(rho),'/4)-',num2str(table{8,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(pi*',num2str(rho),'/4)'], 't');
    table{9,2} = inline([num2str(delta*rho),'*sin((t-(pi*',num2str(rho),'/4)-',num2str(table{8,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(t-(pi*',num2str(rho),'/4)-',num2str(table{8,4}),')'], 't');
    table{9,3} = table{8,4};
    table{9,4} = table{9,3} + pi*rho/2;
    table{9,5} = 3;
    
    table{10,1} = inline([num2str(delta*rho),'*cos((t+(pi*',num2str(rho),'/4)-',num2str(table{9,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(-t+(pi*',num2str(rho),'/4)+',num2str(table{9,4}),')'], 't');
    table{10,2} = inline([num2str(delta*rho),'*sin((t+(pi*',num2str(rho),'/4)-',num2str(table{9,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(pi*',num2str(rho),'/4)'], 't');
    table{10,3} = table{9,4};
    table{10,4} = table{10,3} + pi*rho/2;
    table{10,5} = 3;
    
    table{11,1} = inline([num2str(delta*rho),'*cos((t+(3*pi*',num2str(rho),'/4)-',num2str(table{10,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(-pi*',num2str(rho),'/4)'], 't');
    table{11,2} = inline([num2str(delta*rho),'*sin((t+(3*pi*',num2str(rho),'/4)-',num2str(table{10,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(-t+(pi*',num2str(rho),'/4)+',num2str(table{10,4}),')'], 't');
    table{11,3} = table{10,4};
    table{11,4} = table{11,3} + pi*rho/2;
    table{11,5} = 3;
    
    table{12,1} = inline([num2str(delta*rho),'*cos((t+(5*pi*',num2str(rho),'/4)-',num2str(table{11,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(t-(pi*',num2str(rho),'/4)-',num2str(table{11,4}),')'], 't');
    table{12,2} = inline([num2str(delta*rho),'*sin((t+(5*pi*',num2str(rho),'/4)-',num2str(table{11,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(-pi*',num2str(rho),'/4)'], 't');
    table{12,3} = table{11,4};
    table{12,4} = table{12,3} + pi*rho/2;
    table{12,5} = 3;


hold on;
for n=1:12
ezplot(table{n,1}, table{n,2}, [table{n,3}, table{n,4}]);
end
axis equal
hold off
end
