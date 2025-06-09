function table=mushroom(rx,ry,a,h,w,wr,to)
global table

table=[];

%RIGHT BASE OF CAP
table{1,1}=inline([num2str(rx+to),'-t*',num2str(cos(a))]); %x(t)
table{1,2}=inline([num2str(sin(a)),'*t']); %y(t)
table{1,3}=to; %lower bound entry, t1 starts
table{1,4}=table{1,3}+((2*rx-w)/(1+wr))/cos(a); %upper bound, t ends
table{1,5}=1; %line segment flag: 1=line segment, 2=other
  
%RIGHT SIDE OF STEM
table{2,1}=inline(num2str(((wr-1)*rx+w)/(wr+1)),'t');
table{2,2}=inline([num2str(table{1,4}+tan(a)*(2*rx-w)/(wr+1)),'-t']);
table{2,3}=table{1,4};
table{2,4}=table{2,3}+h+tan(a)*(2*rx-w)/(1+wr);
table{2,5}=1;

%BOTTOM OF STEM
table{3,1}=inline([num2str(((wr-1)*rx+w)/(wr+1)+table{2,4}),'-t']);
table{3,2}=inline(num2str(-h),'t');
table{3,3}=table{2,4};
table{3,4}=table{2,4}+w;
table{3,5}=1;

%LEFT SIDE OF STEM
table{4,1}=inline(num2str(((wr-1)*rx+w)/(wr+1)-w),'t');
table{4,2}=inline([num2str(table{3,4}+tan(a)*wr*(2*rx-w)/(1+wr)),'-t']);
table{4,3}=table{3,4};
table{4,4}=table{4,3}+h+tan(a)*wr*(2*rx-w)/(1+wr);
table{4,5}=1;

%LEFT BASE OF CAP
table{5,1}=inline([num2str(((wr-1)*rx+w)/(wr+1)-w+table{4,4}*cos(a)),'-t*',num2str(cos(a))]);
table{5,2}=inline([num2str(sin(a)*((wr*(2*rx-w)/(wr+1))/cos(a))+table{4,4}*sin(a)),'-t*',num2str(sin(a))]);
table{5,3}=table{4,4};
table{5,4}=table{5,3}+(wr*(2*rx-w)/(wr+1))/cos(a);
table{5,5}=1;

if wr==inf
    table{2,1}=inline(num2str(rx),'t');
    table{3,1}=inline([num2str(rx+table{2,4}),'-t']);
    table{4,1}=inline(num2str(rx-w),'t');
    table{5,1}=inline(['-t+',num2str(rx-w+table{4,4})]);
    table{5,4}=table{5,3}+2*rx-w;
end

if (rx<=0) | (ry<=0)
    error('Error radius must be positive.')
else
%MUSHROOM CAP
    length=ry*quad(inline(['1+',num2str((rx^2-ry^2)/ry^2),'*sin(t).^2']),0,2*pi);
    table{6,1}=inline([num2str(rx),'*cos(pi+(-t+',num2str(table{5,4}),')*',num2str(2*pi/length),')']);
    table{6,2}=inline([num2str(ry),'*sin(pi+(-t+',num2str(table{5,4}),')*',num2str(2*pi/length),')']);
    table{6,3}=table{5,4};
    table{6,4}=table{5,4}+length/2;
    table{6,5}=2;
end