function table=stadium(c,w,rx,ry,to)
global table
table=[];
switch c
 case 1
	length=rx*quad(inline(['1+',num2str((ry^2-rx^2)/rx^2),'*sin(t).^2']),0,2*pi)/2;
	
    table{1,3}=to;
    table{1,4}=table{1,3}+w;
    table{1,5}=1;
    table{2,3}=table{1,4};
    table{2,4}=table{2,3}+length;
    table{2,5}=2;
    table{3,3}=table{2,4};
    table{3,4}=table{3,3}+w;
    table{3,5}=1;
    table{4,3}=table{3,4};
    table{4,4}=table{4,3}+length;
    table{4,5}=2;
    
    table{1,1}=inline(['-t+',num2str(w/2+table{1,3})]);
    table{1,2}=inline(num2str(-ry),'t');
    table{2,1}=inline([num2str(-w/2),'+',num2str(rx),'*sin(pi+(t-',num2str(table{2,3}),')/',num2str(length/pi),')']);
    table{2,2}=inline([num2str(ry),'*cos(pi+(t-',num2str(table{2,3}),')/',num2str(length/pi),')']);
    table{3,1}=inline(['t-',num2str(table{3,3}+w/2)]);
    table{3,2}=inline(num2str(ry),'t');
    table{4,1}=inline([num2str(w/2),'-',num2str(rx),'*sin((t-',num2str(table{4,3}-length),')/',num2str(length/pi),')']);
    table{4,2}=inline([num2str(-ry),'*cos((t-',num2str(table{4,3}-length),')/',num2str(length/pi),')']);
case 2
	length=rx*quad(inline(['1+',num2str((ry^2-rx^2)/rx^2),'*sin(t).^2']),0,2*pi)/2;
	
    table{1,3}=to;
    table{1,4}=table{1,3}+w;
    table{1,5}=1;
    table{2,3}=table{1,4};
    table{2,4}=table{2,3}+length;
    table{2,5}=2;
    table{3,3}=table{2,4};
    table{3,4}=table{3,3}+w;
    table{3,5}=1;
    table{4,3}=table{3,4};
    table{4,4}=table{4,3}+2*ry;
    table{4,5}=1;
    
    table{1,1}=inline(['-t+',num2str(w/2+table{1,3})]);
    table{1,2}=inline(num2str(-ry),'t');
    table{2,1}=inline([num2str(-w/2),'+',num2str(rx),'*sin(pi+(t-',num2str(table{2,3}),')/',num2str(length/pi),')']);
    table{2,2}=inline([num2str(ry),'*cos(pi+(t-',num2str(table{2,3}),')/',num2str(length/pi),')']);
    table{3,1}=inline(['t-',num2str(table{3,3}+w/2)]);
    table{3,2}=inline(num2str(ry),'t');
    table{4,1}=inline(num2str(w/2),'t');
    table{4,2}=inline(['-t+',num2str(ry+table{4,3})]);
case 3
	length=rx*quad(inline(['1+',num2str((ry^2-rx^2)/rx^2),'*sin(t).^2']),0,2*pi)/4;
	
    table{1,1}=inline(['-t+',num2str(w/2+rx+to)]);
    table{1,2}=inline(num2str(-ry),'t');
    table{1,3}=to;
    table{1,4}=table{1,3}+w+2*rx;
    table{1,5}=1;
    table{2,1}=inline(num2str(-w/2-rx),'t');
    table{2,2}=inline(['t+',num2str(-ry-table{1,4})]);
    table{2,3}=table{1,4};
    table{2,4}=table{2,3}+ry;
    table{2,5}=1;
    table{3,1}=inline([num2str(-w/2),'+',num2str(rx),'*cos(pi+(t-',num2str(table{2,4}),')/',num2str(2*length/pi),')']);
    table{3,2}=inline([num2str(ry),'*sin((t-',num2str(table{2,4}),')/',num2str(2*length/pi),')']);
    table{3,3}=table{2,4};
    table{3,4}=table{3,3}+length;
    table{3,5}=2;
    table{4,1}=inline(['t-',num2str(w/2+table{3,4})]);
    table{4,2}=inline(num2str(ry),'t');
    table{4,3}=table{3,4};
    table{4,4}=table{4,3}+w+rx;
    table{4,5}=1;
    table{5,1}=inline(num2str(w/2+rx),'t');
    table{5,2}=inline(['-t+',num2str(ry+table{4,4})]);
    table{5,3}=table{4,4};
    table{5,4}=table{5,3}+2*ry;
    table{5,5}=1;
end