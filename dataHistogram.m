function output = f(filename, delta)
    % Let w=5,R=2,rho=1
    w = 5;
    r = 2;
    rho = 1;
    % Parameters
    L = w - 2*r;      % length of straight segment
    A = pi/2*r;       % length of arc (quarter circle)
    to = 0;           % starting parameter for first arc

    % 1. Bottom-right arc: center at (w/2, -w/2), angle = pi/2 to pi
        table{1,1} = inline([num2str(w/2), '+', num2str(r), '*cos(pi/2 + (t-', num2str(to), ')/', num2str(r), ')'], 't');  % X(t)
        table{1,2} = inline([num2str(-w/2), '+', num2str(r), '*sin(pi/2 + (t-', num2str(to), ')/', num2str(r), ')'], 't'); % Y(t)
        table{1,3} = to;     % Start time
        table{1,4} = to + A; % End time
    % 2. Bottom edge: from (w/2, -w/2) to (-w/2, -w/2)
        table{2,1} = inline(['-t+',num2str(L/2 + table{1,4})], 't');
        table{2,2} = inline(num2str(-w/2) ,'t');
        table{2,3} = table{1,4};
        table{2,4} = table{2,3} + L;     
    % 3. Bottom-left arc: angle = pi to 3*pi/2
        table{3,1} = inline([num2str(-w/2), '+', num2str(r), '*cos(0 + (t-', num2str(table{2,4}), ')/', num2str(r), ')'], 't');
        table{3,2} = inline([num2str(-w/2), '+', num2str(r), '*sin(0 + (t-', num2str(table{2,4}), ')/', num2str(r), ')'], 't');
        table{3,3} = table{2,4};
        table{3,4} = table{3,3} + A;
    % 4. Left edge: from (-w/2, -w/2) to (-w/2, w/2)
        table{4,1} = inline(num2str(-w/2),'t');
        table{4,2} = inline(['t+',num2str(-L/2 - table{3,4})],'t');
        table{4,3} = table{3,4};
        table{4,4} = table{4,3} + L;   
    % 5. Top-left arc: angle = 3*pi/2 to 0
        table{5,1} = inline([num2str(-w/2), '+', num2str(r), '*cos(3*pi/2 + (t-', num2str(table{4,4}), ')/', num2str(r), ')'], 't');
        table{5,2} = inline([num2str(w/2), '+', num2str(r), '*sin(3*pi/2 + (t-', num2str(table{4,4}), ')/', num2str(r), ')'], 't');
        table{5,3} = table{4,4};
        table{5,4} = table{5,3} + A;
    % 6. Top edge: from (-w/2, w/2) to (w/2, w/2)
        table{6,1} = inline(['t+',num2str(-L/2 - table{5,4})], 't');
        table{6,2} = inline(num2str(w/2), 't');
        table{6,3} = table{5,4};
        table{6,4} = table{6,3} + L;
    % 7. Top-right arc:angle = 0 to pi/2 
        table{7,1} = inline([num2str(w/2), '+', num2str(r), '*cos(pi + (t-', num2str(table{6,4}), ')/', num2str(r), ')'], 't');
        table{7,2} = inline([num2str(w/2), '+', num2str(r), '*sin(pi + (t-', num2str(table{6,4}), ')/', num2str(r), ')'], 't');
        table{7,3} = table{6,4};
        table{7,4} = table{7,3} + A;
    % 8. Right edge: from (w/2, -w/2) to (w/2, w/2)
        table{8,1} = inline(num2str(w/2),'t');
        table{8,2} = inline(['-t+',num2str(table{7,4} + L/2)], 't');
        table{8,3} = table{7,4};
        table{8,4} = table{8,3} + L;
    % 9. Middle squircle:
        table{9,1} = inline([num2str(delta*rho),'*cos((t-(pi*',num2str(rho),'/4)-',num2str(table{8,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(pi*',num2str(rho),'/4)'], 't');
        table{9,2} = inline([num2str(delta*rho),'*sin((t-(pi*',num2str(rho),'/4)-',num2str(table{8,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(t-(pi*',num2str(rho),'/4)-',num2str(table{8,4}),')'], 't');
        table{9,3} = table{8,4};
        table{9,4} = table{9,3} + pi*rho/2;
        table{10,1} = inline([num2str(delta*rho),'*cos((t+(pi*',num2str(rho),'/4)-',num2str(table{9,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(-t+(pi*',num2str(rho),'/4)+',num2str(table{9,4}),')'], 't');
        table{10,2} = inline([num2str(delta*rho),'*sin((t+(pi*',num2str(rho),'/4)-',num2str(table{9,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(pi*',num2str(rho),'/4)'], 't');
        table{10,3} = table{9,4};
        table{10,4} = table{10,3} + pi*rho/2;
        table{11,1} = inline([num2str(delta*rho),'*cos((t+(3*pi*',num2str(rho),'/4)-',num2str(table{10,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(-pi*',num2str(rho),'/4)'], 't');
        table{11,2} = inline([num2str(delta*rho),'*sin((t+(3*pi*',num2str(rho),'/4)-',num2str(table{10,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(-t+(pi*',num2str(rho),'/4)+',num2str(table{10,4}),')'], 't');
        table{11,3} = table{10,4};
        table{11,4} = table{11,3} + pi*rho/2;
        table{12,1} = inline([num2str(delta*rho),'*cos((t+(5*pi*',num2str(rho),'/4)-',num2str(table{11,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(t-(pi*',num2str(rho),'/4)-',num2str(table{11,4}),')'], 't');
        table{12,2} = inline([num2str(delta*rho),'*sin((t+(5*pi*',num2str(rho),'/4)-',num2str(table{11,4}),')/',num2str(rho),')+(1-',num2str(delta),')*(-pi*',num2str(rho),'/4)'], 't');
        table{12,3} = table{11,4};
        table{12,4} = table{12,3} + pi*rho/2;

    file = load(filename);
    disp(filename);
    data = file.data;
    tbl = file.table;
    initcond = file.initcond;
    
    partTWO = (delta^2*rho/2)*((pi*rho/4)+(rho/2))+delta*(1-delta)*rho^2*(1+pi/4)*(sqrt(2)/2)+(1-delta)^2*(pi^2*rho^2/16);
    partTHREE = -0.5*(delta*rho*(sqrt(2)/2) + (1-delta)*(pi*rho/4))^2;
    squircle = 8*(partTWO + partTHREE);
    area = (w^2)-(pi*r^2)-squircle;
    
    side_squircle = integral(@(s)sqrt(delta^2+(2*delta*cos(s/rho)*(1-delta))+(1-delta)^2), -pi*rho/4, pi*rho/4);
    length = 4*(pi*r/2) + 4*(w-2*r)+4*(side_squircle);
    
    tauBar = pi*area/length;
    array = [];
    filteredArray = [];
    variance = [];
    for i = 1: numel(data)
        total = 0;
        x_values = [];
        y_values = [];
        for j = 1:99
            t = data{i}(j,1);
            piece = data{i}(j,4);
            t_next = data{i}(j+1,1);
            piece_next = data{i}(j+1,4);
            if ~isnan(t) && ~isnan(piece) && ~isnan(t_next) && ~isnan(piece_next)
                x = table{piece,1}(t);
                y = table{piece,2}(t);
                x_next = table{piece_next,1}(t_next);
                y_next = table{piece_next,2}(t_next);
                total = total + sqrt((x_next-x)^2+(y_next-y)^2) - tauBar;
            end
        end
        average = total/sqrt(99);
        array = [array, average];
        disp(i);
    end

    generation = [sqrt(size(data)), sqrt(size(data)), size(data)];
    table_params = [w, r, rho, delta];
    [sigma2s, second_terms] = myVariance(initcond, generation, data, tbl, table_params);
    sigma2 = sigma2s(end);  % or pick whichever index you want
    disp(sigma2);

    figure;
    histogram(array)
    hold on;
    fplot(@(x)(1000 / sqrt(2*pi*sigma2)) * exp(-(x).^2 / (2*sigma2)),[min(array) max(array)]);
    fplot(@(x)(1000 / sqrt(pi*sigma2)) * exp(-(x).^2 / (sigma2)),[min(array) max(array)]);
    title(sprintf('Delta = %.2f', delta));
    hold off;

end
