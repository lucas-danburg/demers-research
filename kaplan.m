function table=kaplan(s,h,r,option,to)
global table
table = [];

if (h < 0 | s < 0 | r < 0)
	error('All quantities must be positive.');
end

if (h + 2*r > s)
	error('The semi-circle does not fit onto the side.');
end

table{1,1}=inline(num2str(s/2),'t');
table{1,2}=inline([num2str(s/2+to),'-t']);
table{1,3}=to;
table{1,4}=to + (s - (h + 2*r));
table{1,5}=1;

if (option == 1) % then the semi-circle should be focusing (outside)
    table{2,1}=inline([num2str(s/2),'+',num2str(r),'*sin((t-',num2str(table{1,4}),')/',num2str(r),')']);
    table{2,2}=inline([num2str(h-s/2+r),'+',num2str(r),'*cos((t-',num2str(table{1,4}),')/',num2str(r),')']);
    table{2,3}=table{1,4};
    table{2,4}=table{2,3} + pi*r;
    table{2,5}=2;
else             % then the semi-circle should be dispersive (inside)
    table{2,1}=inline([num2str(s/2),'-',num2str(r),'*sin((t-',num2str(table{1,4}),')/',num2str(r),')']);
    table{2,2}=inline([num2str(h-s/2+r),'+',num2str(r),'*cos((t-',num2str(table{1,4}),')/',num2str(r),')']);
    table{2,3}=table{1,4};
    table{2,4}=table{2,3} + pi*r;
    table{2,5}=2;
end
    

table{3,1}=inline(num2str(s/2),'t');
table{3,2}=inline([num2str(h-s/2+table{2,4}),'-t']);
table{3,3}=table{2,4};
table{3,4}=table{3,3} + h;
table{3,5}=1;

table{4,1}=inline([num2str(s/2+table{3,4}),'-t']);
table{4,2}=inline(num2str(-s/2),'t');
table{4,3}=table{3,4};
table{4,4}=table{4,3} + s;
table{4,5}=1;

table{5,1}=inline(num2str(-s/2),'t');
table{5,2}=inline([num2str(-s/2-table{4,4}),'+t']);
table{5,3}=table{4,4};
table{5,4}=table{5,3} + s;
table{5,5}=1;

table{6,1}=inline([num2str(-s/2-table{5,4}),'+t']);
table{6,2}=inline(num2str(s/2),'t');
table{6,3}=table{5,4};
table{6,4}=table{6,3} + s;
table{6,5}=1;