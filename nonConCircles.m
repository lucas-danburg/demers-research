function table=nonConCircles(router,rinner,vshift,to)
global t
global table

if (rinner < 0 | router < 0 | vshift < 0)
    error('Inner radius, outer radius, and vertical shift should all be positive.');
end
if ((vshift + rinner) > router)
    error('All of the inner circle must fit inside the outer circle.');
end

%table=[circle(router,to);circle(rinner,to+2*pi*router)];
%table{2,2}=inline(['-',char(table{2,2})],'t');   %reverse direction circle is traced in
%table{2,3}=inline([num2str(vshift),'+',char(table{2,3})],'t'); %shift the inner circle up vertically
if to==0
    table{1,1}=inline([num2str(router),'*cos(t/',num2str(router),')']);
    table{1,2}=inline([num2str(-router),'*sin(t/',num2str(router),')']);
else
    table{1,1}=inline([num2str(router),'*cos((t-',num2str(to),')/',num2str(router), ')']);
    table{1,2}=inline([num2str(-router),'*sin((t-',num2str(to),')/',num2str(router),')']);
end
table{1,3}=to;
table{1,4}=2*pi*router+to;
table{1,5}=2;

table{2,1}=inline([num2str(rinner),'*cos((t-',num2str(table{1,4}),')/',num2str(rinner), ')']);
table{2,2}=inline([num2str(vshift),'-(',num2str(rinner),'*sin((t-',num2str(table{1,4}),')/',num2str(rinner),'))']);
table{2,3}=table{1,4};
table{2,4}=table{2,3}+2*pi*rinner;
table{2,5}=2;
