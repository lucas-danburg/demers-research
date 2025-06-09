function table=polygon(n,w,to)
global table
r=w/2/cos(pi*(n-2)/2/n);
points=zeros(n+1,4);
points(1,1)=r;
for m=2:n+1
    points(m,1)=r*cos(2*pi/n*(m-1));
    points(m,2)=-r*sin(2*pi/n*(m-1));
    points(m,3)=(points(m,1)-points(m-1,1));
    points(m,4)=(points(m,2)-points(m-1,2));
end

table=[];

if to==0
    %table(1,1)=t*points(2,3)/w+points(1,1)
    table{1,1}=inline(['t*',num2str(points(2,3)/w),'+',num2str(points(1,1))],'t');
    %table(1,2)=t*points(2,4)/w
    table{1,2}=inline(['t*',num2str(points(2,4)/w)],'t');
else
    %table(1,1)=(t-to)*points(2,3)/w+points(1,1)
    table{1,1}=inline(['(t-',num2str(to),')*',num2str(points(2,3)/w),'+',num2str(points(1,1))],'t'); 
    %table(1,2)=(t-to)*points(2,4)/w
    table{1,2}=inline(['(t-',num2str(to),')*',num2str(points(2,4)/w)],'t');
end
table{1,3}=to;
table{1,4}=to+w;
table{1,5}=1;
    
for m=2:n
    %table{m,1}=(t-(m-1)*w-to)*points(m+1,3)/w+points(m,1)
    table{m,1}=inline(['(t-',num2str((m-1)*w+to),')*',num2str(points(m+1,3)/w),'+',num2str(points(m,1))],'t');
    %table{m,2}=(t-(m-1)*w-to)*points(m+1,4)/w+points(m,2)
    table{m,2}=inline(['(t-',num2str((m-1)*w+to),')*',num2str(points(m+1,4)/w),'+',num2str(points(m,2))],'t');
    table{m,3}=to+(m-1)*w;
    table{m,4}=to+m*w;
    table{m,5}=1;
end