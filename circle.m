function table=circle(r,to)
global table
table=[];
if to==0
    table{1,1}=inline([num2str(r),'*cos(t/',num2str(r),')']);
    table{1,2}=inline([num2str(-r),'*sin(t/',num2str(r),')']);
else
    table{1,1}=inline([num2str(r),'*cos((t-',num2str(to),')/',num2str(r), ')']);
    table{1,2}=inline([num2str(-r),'*sin((t-',num2str(to),')/',num2str(r),')']);
end
table{1,3}=to;
table{1,4}=2*pi*r+to;
table{1,5}=2;

%will waas here

%aaaaahi