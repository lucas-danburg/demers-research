function table=limacon(a,b,to)
global table
table=[];
if to==0
    table{1,1}=@(t) (a+b*cos(t))*cos(t);
    table{1,2}=@(t) (a+b*cos(t))*sin(t);
    table{1,4}=2*pi;
else
    table{1,1}=@(t) (a+b*cos(t-to))*cos(t-to);
    table{1,2}=@(t) (a+b*cos(t-to))*sin(t-to);
end
table{1,3}=to;
table{1,4}=to+2*pi;
table{1,5}=0;