function table = moon(upper,lower,d,to)
global t
global table


table=[];

if (lower < 0 | upper < 0 | d < 0)
    error('Radius and shift should all greater than 0.');
end
if (d >= upper + lower | upper - lower >= d )
    error('No cross over');
end
%naming half span of central angles
hsl = sym('hsl'); %half span of central angle of lower circle
hsu = sym('hsu'); %half span of central angle of upper circle

hsl = acos(((lower)^2 + (d)^2 - (upper)^2) / (2*d*lower)); %half span of central angle of lower circle
hsu = acos(((upper)^2 + (d)^2 - (lower)^2) / (2*d*upper)); %half span of central angle of upper circle

%Parameterize the Moon Shape
%COUNTERCLOCKWISE LOWER ARC OF LEMON（UPPER ARC OF MOON）
table{1,1} = inline([num2str(upper),'*cos((t/',num2str(upper),')+',num2str(((3*pi)/2)+ hsu),')']);  %x(t)
table{1,2} = inline([num2str(d), '+', num2str(upper), '*sin((t/', num2str(upper) ,')+', num2str(((3*pi)/2) + hsu),')']);  %y(t)
table{1,3} = to;                                             %t2 start
table{1,4}=table{1,3} + (2*pi-2*hsu)*upper;                     %t2 end
table{1,5}=2;

%CLOCKWISE UPPER ARC OF LEMON (LOWER ARC OF MOON)
table{2,1}= inline([num2str(lower),'*cos(((t -',num2str(table{1,4}),')/',num2str(lower),')+',num2str(((3*pi)/2)- hsl),')']);   %x(t)
table{2,2}= inline([num2str(-lower), '*sin(((t-', num2str(table{1,4}),')/', num2str(lower) ,')+', num2str(((3*pi)/2) - hsl),')']);  %y(t)
table{2,3}= table{1,4}; 			%t2 start
table{2,4}= table{2,3} + 2*hsl*lower;		%t2 end
table{2,5}= 2;					%flag for circular arc













