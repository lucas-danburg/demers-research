function table=inversecone(rx,ry,h,w1,w2,wr,to)
global table
%w1 is width at top of stem
%w2 is width at bottom of stem
%length of right horizontal segments
right=(2*rx-w1)/(1+wr);
left=2*rx-right-w1;
%diagonal segment length
stemlength=sqrt(h^2+(w1-w2)^2/4);

table=[];
table{1,1}=inline([num2str(rx+to),'-t']);
table{1,2}=inline('0','t');
table{1,3}=to;
table{1,4}=table{1,3}+right;
table{1,5}=1;
table{2,1}=inline([num2str(((wr-1)*rx+w1)/(wr+1)),'-(t-',num2str(table{1,4}),')*',num2str((w1-w2)/2/stemlength)],'t');
if wr==inf
   table{2,1}=inline([num2str(rx),'-(t-',num2str(table{1,4}),')*',num2str((w1-w2)/2/stemlength)],'t'); 
end
table{2,2}=inline(['-(t-',num2str(table{1,4}),')*',num2str(h/stemlength)]);
table{2,3}=table{1,4};
table{2,4}=table{2,3}+stemlength;
table{2,5}=1;
table{3,1}=inline([num2str(rx-right+(w2-w1)/2),'-(t-',num2str(table{2,4}),')'],'t');
table{3,2}=inline(num2str(-h),'t');
table{3,3}=table{2,4};
table{3,4}=table{3,3}+w2;
table{3,5}=1;
table{4,1}=inline([num2str(-rx+left-(w2-w1)/2),'+(t-',num2str(table{3,4}),')*',num2str((w2-w1)/2/stemlength)],'t');
table{4,2}=inline([num2str(-h),'+(t-',num2str(table{3,4}),')*',num2str(h/stemlength)]);
table{4,3}=table{3,4};
table{4,4}=table{4,3}+stemlength;
table{4,5}=1;
table{5,1}=inline(['-t+',num2str(-rx+left+table{4,4})]);
table{5,2}=inline('0','t');
table{5,3}=table{4,4};
table{5,4}=table{5,3}+left;
table{5,5}=1;
length=ry*quad(inline(['1+',num2str((rx^2-ry^2)/ry^2),'*sin(t).^2']),0,2*pi);
table{6,1}=inline([num2str(rx),'*cos(pi+(-t+',num2str(table{5,4}),')*',num2str(2*pi/length),')']);
table{6,2}=inline([num2str(ry),'*sin(pi+(-t+',num2str(table{5,4}),')*',num2str(2*pi/length),')']);
table{6,3}=table{5,4};
table{6,4}=table{6,3}+length/2;
table{6,5}=2;
