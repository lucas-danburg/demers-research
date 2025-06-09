function table=doublemushroom(rx1,ry1,rx2,ry2,sh,sw,wr1,wr2,to)
global table
table=[];

if (sh < 0)
    error('Error: The stem height should be non-negative.')
end
if (wr1 < 0 | wr2 < 0)
    error('Error: The width ratios should be non-negative.')
end
if (sw <= 0)
    error('Error: The stem width should be positive.')
end
if (rx1<=0) | (ry1<=0) | (rx2<=0) | (ry2<=0)
    error('Error: All radii must be positive.')
end
if (sw > 2*rx1) | (sw > 2*rx2)
    error('Error: The width of the stem cannot be greater than either of the horizontal diameters.')
end

L11 = (2*rx1 - sw)/(1 + wr1);
L12 = wr1 * L11;

L21 = (2*rx2 - sw)/(1 + wr2);
L22 = wr2 * L21;


table{1,1} = inline([num2str(sw/2 + L11 + to), '-t']);
table{1,2} = inline(num2str(sh/2), 't');
table{1,3} = to;
table{1,4} = table{1,3} + L11;
table{1,5} = 1;

table{2,1} = inline(num2str(sw/2), 't');
table{2,2} = inline([num2str(sh/2 + table{1,4}), '-t']);
table{2,3} = table{1,4};
table{2,4} = table{2,3} + sh;
table{2,5} = 1;

table{3,1} = inline([num2str(sw/2 - table{2,4}), '+t']);
table{3,2} = inline(num2str(-sh/2), 't');
table{3,3} = table{2,4};
table{3,4} = table{3,3} + L21;
table{3,5} = 1;

length2 = ry2 * quad(inline(['1+', num2str((rx2^2 - ry2^2)/ry2^2), '*sin(t).^2']), 0, 2 * pi);
table{4,1} = inline([num2str(rx2), '*cos((t-', num2str(table{3,4}), ')*', num2str(2*pi/length2), ')+', num2str(L21 + sw/2 - rx2)]);
table{4,2} = inline([num2str(-ry2), '*sin((t-', num2str(table{3,4}), ')*', num2str(2*pi/length2), ')+', num2str(-sh/2)]);
table{4,3} = table{3,4};
table{4,4} = table{4,3} + length2/2;
table{4,5} = 2;

table{5,1} = inline([num2str(-sw/2 - L22 - table{4,4}), '+t']);
table{5,2} = inline(num2str(-sh/2), 't');
table{5,3} = table{4,4};
table{5,4} = table{5,3} + L22;
table{5,5} = 1;

table{6,1} = inline(num2str(-sw/2), 't');
table{6,2} = inline([num2str(-sh/2 - table{5,4}), '+t']);
table{6,3} = table{5,4};
table{6,4} = table{6,3} + sh;
table{6,5} = 1;

table{7,1} = inline([num2str(-sw/2 + table{6,4}), '-t']);
table{7,2} = inline(num2str(sh/2), 't');
table{7,3} = table{6,4};
table{7,4} = table{7,3} + L12;
table{7,5} = 1;

length1 = ry1 * quad(inline(['1+', num2str((rx1^2 - ry1^2)/ry1^2), '*sin(t).^2']), 0, 2 * pi);
table{8,1} = inline([num2str(-rx1), '*cos((t-', num2str(table{7,4}), ')*', num2str(2*pi/length1), ')+', num2str(L11 + sw/2 - rx1)]);
table{8,2} = inline([num2str(ry1), '*sin((t-', num2str(table{7,4}), ')*', num2str(2*pi/length1), ')+', num2str(sh/2)]);
table{8,3} = table{7,4};
table{8,4} = table{8,3} + length1/2;
table{8,5} = 2;

%table{3,1}=inline([num2str(-rx2-table{2,4}),'+t']);
%table{3,2}=inline(num2str(-h/2),'t');
%table{3,3}=table{2,4};
%table{3,4}=table{3,3}+2*rx2-w;
%table{3,5}=1;
%table{4,1}=inline(num2str(rx2-w),'t');
%table{4,2}=inline([num2str(-h/2-table{3,4}),'+t']);
%table{4,3}=table{3,4};
%table{4,4}=table{4,3}+h;
%table{4,5}=1;
%table{5,1}=inline([num2str(rx1-w+table{4,4}),'-t']);
%table{5,2}=inline(num2str(h/2),'t');
%table{5,3}=table{4,4};
%table{5,4}=table{5,3}+2*rx1-w;
%table{5,5}=1;

%length=ry1*quad(inline(['1+',num2str((rx1^2-ry1^2)/ry1^2),'*sin(t).^2']),0,2*pi);
%table{6,1}=inline([num2str(rx1),'*cos(pi-(t-',num2str(table{5,4}),')*',num2str(2*pi/length),')']);
%table{6,2}=inline([num2str(ry1),'*sin(pi-(t-',num2str(table{5,4}),')*',num2str(2*pi/length),')+',num2str(h/2)]);
%table{6,3}=table{5,4};
%table{6,4}=table{6,3}+length/2;
%table{6,5}=2;

%else %------------------------------------------------------------------------------------------------------------
%table{1,1}=inline([num2str(rx1+to),'-t']);
%table{1,2}=inline(num2str(h/2),'t');
%table{1,3}=to;
%table{1,4}=table{1,3}+(2*rx1-w)/(1+wr);
%table{1,5}=1;
%table{2,1}=inline(num2str(((wr-1)*rx1+w)/(wr+1)),'t');
%table{2,2}=inline(['-t+',num2str(table{1,4}+h/2)]);
%table{2,3}=table{1,4};
%table{2,4}=table{2,3}+h;
%table{2,5}=1;

%table{3,1}=inline([num2str(((wr-1)*rx2+w)/(wr+1)-table{2,4}),'+t']);
%table{3,2}=inline(num2str(-h/2),'t');
%table{3,3}=table{2,4};
%table{3,4}=table{3,3}+(2*rx2-w)/(1+wr);
%table{3,5}=1;
%if (wr==0) & ~(rx1==rx2)
%    error('Since width radio = 0, Top horizontal radius must equal bottom horizontal radius.')
%end

%length=ry2*quad(inline(['1+',num2str((rx2^2-ry2^2)/ry2^2),'*sin(t).^2']),0,2*pi);
%table{4,1}=inline([num2str(rx2),'*cos((t-',num2str(table{3,4}),')*',num2str(2*pi/length),')']);
%table{4,2}=inline([num2str(-ry2),'*sin((t-',num2str(table{3,4}),')*',num2str(2*pi/length),')+',num2str(-h/2)]);
%table{4,3}=table{3,4};
%table{4,4}=table{4,3}+length/2;
%table{4,5}=2;

%table{5,1}=inline([num2str(-rx2-table{4,4}),'+t']);
%table{5,2}=inline(num2str(-h/2),'t');
%table{5,3}=table{4,4};
%table{5,4}=table{5,3}+wr*(2*rx2-w)/(1+wr);
%table{5,5}=1;
%table{6,1}=inline(num2str(((wr-1)*rx2+w)/(wr+1)-w),'t');
%table{6,2}=inline(['t-',num2str(table{5,4}+h/2)]);
%table{6,3}=table{5,4};
%table{6,4}=table{6,3}+h;
%table{6,5}=1;
%table{7,1}=inline([num2str(-rx1+wr*(2*rx1-w)/(1+wr)+table{6,4}),'-t']);
%table{7,2}=inline(num2str(h/2),'t');
%table{7,3}=table{6,4};
%table{7,4}=table{7,3}+wr*(2*rx1-w)/(1+wr);
%table{7,5}=1;


%table{3,1}=inline([num2str(((wr-1)*rx+w)/(wr+1)+table{2,4}),'-t']);
%table{3,2}=inline(num2str(-h/2),'t');
%table{3,3}=table{2,4};
%table{3,4}=table{2,4}+w;
%table{3,5}=1;
%table{4,1}=inline(num2str(((wr-1)*rx+w)/(wr+1)-w),'t');
%table{4,2}=inline(['t-',num2str(table{3,4}+h)]);
%table{4,3}=table{3,4};
%table{4,4}=table{4,3}+h;
%table{4,5}=1;
%table{5,1}=inline(['-t+',num2str(((wr-1)*rx+w)/(wr+1)-w+table{4,4})]);
%table{5,2}=inline('0','t');
%table{5,3}=table{4,4};
%table{5,4}=table{5,3}+wr*(2*rx-w)/(wr+1);
%table{5,5}=1;

%length=ry1*quad(inline(['1+',num2str((rx1^2-ry1^2)/ry1^2),'*sin(t).^2']),0,2*pi);
%table{8,1}=inline([num2str(rx1),'*cos(pi+(-t+',num2str(table{7,4}),')*',num2str(2*pi/length),')']);
%table{8,2}=inline([num2str(ry1),'*sin(pi+(-t+',num2str(table{7,4}),')*',num2str(2*pi/length),')+',num2str(h/2)]);
%table{8,3}=table{7,4};
%table{8,4}=table{8,3}+length/2;
%table{8,5}=2;

%end % if wr == inf