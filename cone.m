function table=cone(rx,ry,h,w,wr,to)
global table
table=[];
table{1,1}=inline([num2str(rx+to),'-t']);
table{1,2}=inline('0','t');
table{1,3}=to;
table{1,4}=table{1,3}+(2*rx-w)/(1+wr);
table{1,5}=1;
stemlength=sqrt(h^2+w^2/4);
table{2,1}=inline([num2str(((wr-1)*rx+w)/(wr+1)),'-(t-',num2str(table{1,4}),')*',num2str((w/2)/stemlength)],'t');
table{2,2}=inline(['-(t-',num2str(table{1,4}),')*',num2str(h/stemlength)]);
table{2,3}=table{1,4};
table{2,4}=table{2,3}+stemlength;
table{2,5}=1;
table{3,1}=inline([num2str(((wr-1)*rx+w)/(wr+1)-w/2),'-(t-',num2str(table{2,4}),')*',num2str((w/2)/stemlength)],'t');
table{3,2}=inline([num2str(-h),'+(t-',num2str(table{2,4}),')*',num2str(h/stemlength)]);
table{3,3}=table{2,4};
table{3,4}=table{3,3}+stemlength;
table{3,5}=1;
table{4,1}=inline(['-t+',num2str(((wr-1)*rx+w)/(wr+1)-w+table{3,4})]);
table{4,2}=inline('0','t');
table{4,3}=table{3,4};
table{4,4}=table{4,3}+wr*(2*rx-w)/(wr+1);
if wr==inf
    table{4,4}=table{4,3}+2*rx-w;
end
table{4,5}=1;
length=ry*quad(inline(['1+',num2str((rx^2-ry^2)/ry^2),'*sin(t).^2']),0,2*pi);
table{5,1}=inline([num2str(rx),'*cos(pi+(-t+',num2str(table{4,4}),')*',num2str(2*pi/length),')']);
table{5,2}=inline([num2str(ry),'*sin(pi+(-t+',num2str(table{4,4}),')*',num2str(2*pi/length),')']);
table{5,3}=table{4,4};
table{5,4}=table{4,4}+length/2;
table{5,5}=2;

if wr==inf
    table{2,1}=inline([num2str(rx),'-(t-',num2str(table{1,4}),')*',num2str((w/2)/stemlength)],'t');
    table{3,1}=inline([num2str(rx-w/2),'-(t-',num2str(table{2,4}),')*',num2str((w/2)/stemlength)],'t');
    table{4,1}=inline(['-t+',num2str(rx-w+table{3,4})]);
end