function table=roundedmushroom(rx,ry,h,w,wr,r,to)
global table
table=[];
if (r > h) | (r > (rx-w/2))
    error('Quarter circle radius must be less than the stem height and the length of the cap on either side of the stem.')
end
table{1,1}=inline([num2str(rx+to),'-t']);
table{1,2}=inline('0','t');
table{1,3}=to;
table{1,4}=table{1,3}+(2*rx-w)/(1+wr)-r;
table{1,5}=1;
start=table{1,1}(table{1,4});
table{2,1}=inline([num2str(start),'-',num2str(r),'*sin((t-',num2str(table{1,4}),')/',num2str(r),')']);
table{2,2}=inline([num2str(-r),'+',num2str(r),'*cos((t-',num2str(table{1,4}),')/',num2str(r),')']);
table{2,3}=table{1,4};
table{2,4}=table{2,3}+pi*r/2;
table{2,5}=2;
table{3,1}=inline(num2str(((wr-1)*rx+w)/(wr+1)),'t');
table{3,2}=inline(['-t+',num2str(table{2,4}-r)]);
table{3,3}=table{2,4};
table{3,4}=table{3,3}+h-r;
table{3,5}=1;
table{4,1}=inline([num2str(((wr-1)*rx+w)/(wr+1)+table{3,4}),'-t']);
table{4,2}=inline(num2str(-h),'t');
table{4,3}=table{3,4};
table{4,4}=table{3,4}+w;
table{4,5}=1;
table{5,1}=inline(num2str(((wr-1)*rx+w)/(wr+1)-w),'t');
table{5,2}=inline(['t-',num2str(table{4,4}+h)]);
table{5,3}=table{4,4};
table{5,4}=table{5,3}+h-r;
table{5,5}=1;
start=((wr-1)*rx+w)/(wr+1)-w-r;
table{6,1}=inline([num2str(start),'+',num2str(r),'*cos((t-',num2str(table{5,4}),')/',num2str(r),')']);
table{6,2}=inline([num2str(-r),'+',num2str(r),'*sin((t-',num2str(table{5,4}),')/',num2str(r),')']);
table{6,3}=table{5,4};
table{6,4}=table{6,3}+pi*r/2;
table{6,5}=2;
table{7,1}=inline(['-t+',num2str(((wr-1)*rx+w)/(wr+1)-w+table{6,4}-r)]);
table{7,2}=inline('0','t');
table{7,3}=table{6,4};
table{7,4}=table{7,3}+wr*(2*rx-w)/(wr+1)-r;
table{7,5}=1;

if (rx<=0) | (ry<=0)
    error('Error radius must be positive.')
else
    length=ry*quad(inline(['1+',num2str((rx^2-ry^2)/ry^2),'*sin(t).^2']),0,2*pi);
    table{8,1}=inline([num2str(rx),'*cos(pi+(-t+',num2str(table{7,4}),')*',num2str(2*pi/length),')']);
    table{8,2}=inline([num2str(ry),'*sin(pi+(-t+',num2str(table{7,4}),')*',num2str(2*pi/length),')']);
    table{8,3}=table{7,4};
    table{8,4}=table{7,4}+length/2;
    table{8,5}=2;
end