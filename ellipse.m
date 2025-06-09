function table=ellipse(a,b,to)
global table
table=[];
if (a<=0) | (b<=0)
    error('Error a,b must be positive.')
else
    length=b*quad(inline(['1+',num2str((a^2-b^2)/b^2),'*sin(t).^2']),0,2*pi);
    if to==0
        table{1,1}=inline([num2str(a),'*cos(t*',num2str(2*pi/length),')']);
        table{1,2}=inline([num2str(-b),'*sin(t*',num2str(2*pi/length),')']);
    else
        table{1,1}=inline([num2str(a),'*cos((t-',num2str(to),')*',num2str(2*pi/length),')']);
        table{1,2}=inline([num2str(-b),'*sin((t-',num2str(to),')*',num2str(2*pi/length),')']);
    end
    table{1,3}=to;
    table{1,4}=to+length;
    table{1,5}=2;
end


