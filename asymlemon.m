function table=asymlemon(larger,smaller,d,to)
global t
global table



table=[];

if (smaller < 0 | larger < 0 | d < 0)
    error('Radius and shift should all greater than 0.');
end
if (d >= larger + smaller | larger - smaller >= d )
    error('No cross over');
end

sm = sym('sm');
n = sym('n'); 

sm = acos(((smaller)^2 + (d)^2 - (larger)^2) / (2*d*smaller)); %half span of central angle of smaller circle
n = acos(((larger)^2 + (d)^2 - (smaller)^2) / (2*d*larger)); %half span of central angle of larger circle



%CLOCKWISE PARAMETERIZATION 
%LOWER ARC
table{1,1}= inline([num2str(larger),'*cos((t/',num2str(larger),')+',num2str((pi/2) - n),')']);   %x(t)
table{1,2}= inline([num2str(d),'+',num2str(-larger), '*sin((t/',num2str(larger),')+',num2str((pi/2) - n),')']); %y(t)
table{1,3}= to;					%t1 start
table{1,4}= table{1,3}+2*n*larger;		%t1 end
table{1,5}=2;					%flag for circular arc


%UPPER ARC
table{2,1}= inline([num2str(smaller),'*cos(((t -',num2str(table{1,4}),')/',num2str(smaller),')+',num2str(((3*pi)/2)- sm),')']);   %x(t)
table{2,2}= inline([num2str(-smaller), '*sin(((t-', num2str(table{1,4}),')/', num2str(smaller) ,')+', num2str(((3*pi)/2) - sm),')']);  %y(t)
table{2,3}= table{1,4}; 			%t2 start
table{2,4}= table{2,3} + 2*sm*smaller;		%t2 end
table{2,5}= 2;					%flag for circular arc



%COUNTERCLOCKWISE
%LOWER ARC
%table{2,1} = inline([num2str(larger),'*cos(((t -',num2str(table{1,4}),')/',num2str(larger),')+',num2str(((3*pi)/2)- n),')']);  %x(t)
%table{2,2} = inline([num2str(d), '+', num2str(larger), '*sin(((t-', num2str(table{1,4}),')/', num2str(larger) ,')+', num2str(((3*pi)/2) - n),')']);  %y(t)
%table{2,3}=table{1,4};                                               %t2 start
%table{2,4}=table{2,3} + 2*n*larger;                                  %t2 end
%table{2,5}=2;





%UPPER ARC
%table{1,1} = inline([num2str(smaller),'*cos((t/',num2str(smaller),')+',num2str((pi/2) - sm),')']);    %x(t)
%table{1,2} = inline([num2str(smaller), '*sin((t/',num2str(smaller),')+',num2str((pi/2) - sm),')']);     %y(t)
%table{1,3}=to;                                                       %t1 start
%table{1,4}=table{1,3}+2*sm*smaller;                                    %t1 end
%table{1,5}=2;       















