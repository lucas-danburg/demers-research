function table=lemon(delta,to)
global table
table = [];

% We have y = +- (sqrt(1 + delta*(delta-2)*(1-x^2))-1)/(delta-2);
% And we need to scale appropriately to take into account arc length

if (delta < 0)
	error('Delta should be positive.');
end

if (delta == 2)
	error('Delta should not be 2.');
end

syms x;
f = (sqrt(1 + delta*(delta-2)*(1-x^2))-1)/(delta-2);
ArcLen = double(int(f,-1,1));

%disp('Part 1 completed')

table{1,1} = inline(['1 - 2*(t - (',num2str(to),'))/(', num2str(ArcLen),')']);
table{1,2} = inline(['(sqrt(1 + ((', num2str(delta*(delta-2)), ')*(1-(1 - 2*(t - (',num2str(to),'))/(', num2str(ArcLen),'))^2)))-1)/(', num2str(delta-2),')']);
table{1,3} = to;
table{1,4} = table{1,3} + ArcLen;
table{1,5} = 0;

%disp('Part 2 completed')

table{2,1} = inline(['2*(t - (',num2str(table{1,4}),'))/(', num2str(ArcLen),') - 1']);
table{2,2} = inline(['-(sqrt(1 + ((', num2str(delta*(delta-2)), ')*(1-(1 - 2*(t - (',num2str(table{1,4}),'))/(', num2str(ArcLen),'))^2)))-1)/(', num2str(delta-2),')']);
table{2,3} = table{1,4};
table{2,4} = table{2,3} + ArcLen;
table{2,5} = 0;

%disp('Part 3 completed')