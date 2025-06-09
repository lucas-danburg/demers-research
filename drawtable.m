function varargout = drawtable(varargin)
%Custom billiard table drawer
%handles.table  saved table
%   columns:  x(t), y(t), lower bound for t, upper bound for t
%   each row is a different piece of the table

%points is a vector containing the coordinates of selected points

% DRAWTABLE Application M-file for drawtable.fig
%    FIG = DRAWTABLE launch drawtable GUI.
%    DRAWTABLE('callback_name', ...) invoke the named callback.

if nargin == 0 || (nargin==1 && ishandle(varargin{1})) % LAUNCH GUI
    fig = openfig(mfilename,'reuse');
    
	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
    if nargin==1
        handles.call=varargin{1};   %stores handle of billiards gui
    end
	if nargout > 0
		varargout{1} = fig;
	end

    call=guidata(handles.call);  %handles structure of billiards gui
    handles.stable=[];  %will hold saved table from billiards
    if call.tables  %if a saved table is present
        handles.stable=call.stable; %save current table from billiards
        %draw saved table
        for n=1:size(handles.stable,1)   %loop through all pieces
            ezplot(handles.stable{n,1},handles.stable{n,2},[handles.stable{n,3},handles.stable{n,4}])   %plot each piece
            hold on
            if handles.stable{n,5}==1  %check for horizontal and vertical pieces
                line([handles.stable{n,1}(handles.stable{n,3}),handles.stable{n,1}(handles.stable{n,4})],[handles.stable{n,2}(handles.stable{n,3}),handles.stable{n,2}(handles.stable{n,4})])   %darken horizontal and vertical lines
            end
        end
        axis([str2double(get(handles.xmin,'String')),str2double(get(handles.xmax,'String')),str2double(get(handles.ymin,'String')),str2double(get(handles.ymax,'String'))]) %set bounds for axis to user defined values
        set(handles.axes,'XGrid','on')  %show x-grid
        set(handles.axes,'YGrid','on')  %show y-grid
        title('Billiard Table')
        
    end
    guidata(fig, handles);

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end

end

% --------------------------------------------------------------------
function new_Callback(hObject, eventdata, handles)
%Start new table
cla %clear graph

%draw saved table
for n=1:size(handles.stable,1)   %loop through all pieces
    ezplot(handles.stable{n,1},handles.stable{n,2},[handles.stable{n,3},handles.stable{n,4}])   %plot each piece
    hold on
    if handles.stable{n,5}==1  %check for horizontal and vertical pieces
        line([handles.stable{n,1}(handles.stable{n,3}),handles.stable{n,1}(handles.stable{n,4})],[handles.stable{n,2}(handles.stable{n,3}),handles.stable{n,2}(handles.stable{n,4})])   %darken horizontal and vertical lines
    end
end
axis([str2num(get(handles.xmin,'String')),str2num(get(handles.xmax,'String')),str2num(get(handles.ymin,'String')),str2num(get(handles.ymax,'String'))]) %set bounds for axis to user defined values
set(handles.axes,'XGrid','on')  %show x-grid
set(handles.axes,'YGrid','on')  %show y-grid
title('Billiard Table')

handles.table=[];   %clear table
guidata(gcbo,handles);
set(handles.delete,'Visible','off') %disable delete button
set(handles.continue1,'Visible','off')  %disable continue from last endpoint button
set(handles.continue2,'Visible','off')  %disable start at new endpoint button

% --------------------------------------------------------------------
function varargout = open_Callback(h, eventdata, handles, varargin)
%Open a saved table
uiload;    %load prompt
handles.table=table;
guidata(gcbo,handles);
hold off
plot(0) %clear graph

%draw saved table
for n=1:size(handles.stable,1)   %loop through all pieces
    ezplot(handles.stable{n,1},handles.stable{n,2},[handles.stable{n,3},handles.stable{n,4}])   %plot each piece
    hold on
    if handles.stable{n,5}==1  %check for horizontal and vertical pieces
        line([handles.stable{n,1}(handles.stable{n,3}),handles.stable{n,1}(handles.stable{n,4})],[handles.stable{n,2}(handles.stable{n,3}),handles.stable{n,2}(handles.stable{n,4})])   %darken horizontal and vertical lines
    end
end

%draw current table
for n=1:size(handles.table,1)   %loop through each piece
    ezplot(handles.table{n,1},handles.table{n,2},[handles.table{n,3},handles.table{n,4}])   %draw each piece
    hold on
    if handles.table{n,5}==1  %check for horizontal and vertical pieces
        line([handles.table{n,1}(handles.table{n,3}),handles.table{n,1}(handles.table{n,4})],[handles.table{n,2}(handles.table{n,3}),handles.table{n,2}(handles.table{n,4})])   %darken horizontal and vertical lines
    end
end
set(handles.axes,'XGrid','on')  %turn x-grid lines on
set(handles.axes,'YGrid','on')  %turn y-grid lines on
title('Billiard Table')
set(handles.continue1,'Visible','on')   %enable continue from last endpoint button
set(handles.continue2,'Visible','on')   %enable start at new endpoint button
answer=get(handles.axes,'XLim');    %get upper and lower bounds for x-axis
set(handles.xmin,'String',num2str(answer(1)))   %display the lower bound for x-axis
set(handles.xmax,'String',num2str(answer(2)))   %display the upper bound for x-axis
answer=get(handles.axes,'YLim');    %get upper and lower bounds for y-axis
set(handles.ymin,'String',num2str(answer(1)))   %display the lower bound for y-axis
set(handles.ymax,'String',num2str(answer(2)))   %display the upper bound for y-axis
set(handles.delete,'Visible','on')  %enable delete button


% --------------------------------------------------------------------
function varargout = save_Callback(h, eventdata, handles, varargin)
%Save current table
if size(handles.stable)~=0  %is there a saved table
    syms t
    to=handles.stable{size(handles.stable,2),4};
    for n=1:size(handles.table,1)
        handles.table{n,1}=@(t) handles.table{n,1}(t-to);   %make x(t) be x(t-to)
        handles.table{n,2}=@(t) handles.table{n,2}(t-to);   %make y(t) be x(t-to)
        handles.table{n,3}=handles.table{n,3}+to;   %shift lower bound by to
        handles.table{n,4}=handles.table{n,4}+to;   %shift upper bound by to
    end
    table=[handles.stable;handles.table];   %combine unsaved and saved tables
else
    table=handles.table;    %store saved table into table
end
save(uiputfile,'table') %save dialog


% --------------------------------------------------------------------
function varargout = about_Callback(h, eventdata, handles, varargin)
%About menu option
msgbox(char('Billiards Version 2.0','Updated by Samuel King, Caitlin Keady, Emily Joslin, Michael Vavala, advised by Mark Demers',...
    'Originally created by Steven Lansel and advised by Mason Porter','Fairfield University','Mathematics REU Summer 2016'),'About Billiards')


% --------------------------------------------------------------------
function varargout = xmin_Callback(h, eventdata, handles, varargin)
%Changes lower bound for x-axis and redraws table
set(handles.axes,'XLim',[str2num(get(handles.xmin,'String')),str2num(get(handles.xmax,'String'))])



% --------------------------------------------------------------------
function varargout = xmax_Callback(h, eventdata, handles, varargin)
%Changes upper bound for x-axis and redraws table
set(handles.axes,'XLim',[str2num(get(handles.xmin,'String')),str2num(get(handles.xmax,'String'))])



% --------------------------------------------------------------------
function varargout = ymin_Callback(h, eventdata, handles, varargin)
%Changes lower bound for y-axis and redraws table
set(handles.axes,'YLim',[str2num(get(handles.ymin,'String')),str2num(get(handles.ymax,'String'))])



% --------------------------------------------------------------------
function varargout = ymax_Callback(h, eventdata, handles, varargin)
%Changes upper bound for y-axis and redraws table
set(handles.axes,'YLim',[str2num(get(handles.ymin,'String')),str2num(get(handles.ymax,'String'))])



% --------------------------------------------------------------------
function varargout = line_Callback(h, eventdata, handles, varargin)
%Creation of a line segment
%distance is distance of segment

%if beginning and ending points are selected (segment may not start where the table left off)
if ~(strcmp(get(handles.continue2,'Visible'),'on') & get(handles.continue1,'Value'))
    %if points are typed in (not selected from graph)
    if get(handles.points1,'Value')==0
        answer=inputdlg({'x-coordinate of starting point','y-coordinate of starting point','angle wrt horizontal','length'},'Enter values'); %input prompt
        points=zeros(1,4);
        points(1,1)=str2double(answer{1}); %x-coordinate of starting point
        points(1,2)=str2double(answer{2}); %y-coordinate of starting point
        points(1,3)=str2double(answer{3}); %angle
        points(1,4)=str2double(answer{4}); %length
    else    %if points are selected from graph (not typed in)
        set(handles.directions,'String','Select starting point of segment.')    %directions below graph
        points=round(ginput(1),1);  %allow user to select a point from the graph and round to one decimal place
        set(handles.directions,'String','Select endpoint of segment.')  %directions below graph
        endpt=round(ginput(1),1);  %allow user to select the end point of the line segment and round to one decimal place
        dist=sqrt((points(1,1)-endpt(1,1))^2+(points(1,2)-endpt(1,2))^2); %length of line segment
        ang=atan((points(1,2)-endpt(1,2))/(points(1,1)-endpt(1,1)));%angle wrt horizontal of line segment
        if endpt(1,1)<points(1,1);
            ang=pi+ang;
        end
        points=[points,ang,dist];
        set(handles.directions,'String','') %clear directions below graph
    end
    if strcmp(get(handles.delete,'Visible'),'off')  %if this is the first piece (start at t=0)
        %new piece:  [points(1,1)+(points(2,1)-points(1,1))*t/distance,points(1,2)+(points(2,2)-points(1,2))*t/distance,0,distance];
        handles.table{1,1}=inline([num2str(points(1,1)),'+t*',num2str(cos(points(1,3)))],'t');
        %@(t) points(1,1)+t*cos(points(1,3));    %x(t)
        handles.table{1,2}=inline([num2str(points(1,1)),'+t*',num2str(sin(points(1,3)))],'t');
        %@(t) points(1,2)+t*sin(points(1,3));    %y(t)
        handles.table{1,3}=0;   %lower bound for piece
        handles.table{1,4}=points(1,4);    %upper bound for piece
        handles.table{1,5}=1;   %line segment flag
    else    %this is not the first piece
        %new piece:  [points(1,1)+(points(2,1)-points(1,1))*(t-handles.table{end,4))/distance,points(1,2)+(points(2,2)-points(1,2))*(t-handles.table{end,4))/distance,handles.table{end,4),handles.table{end,4)+distance];
        n=size(handles.table,1)+1;  %number of piece being added
        handles.table{n,1}=inline([num2str(points(1,1)),'+(t-',num2str(handles.table{n-1,4}),')*',num2str(cos(points(1,3)))],'t');
        %@(t) points(1,1)+(t-handles.table{n-1,4})*cos(points(1,3));    %x(t)
        handles.table{n,2}=inline([num2str(points(1,2)),'+(t-',num2str(handles.table{n-1,4}),')*',num2str(sin(points(1,3)))],'t');
        %@(t) points(1,2)+(t-handles.table{n-1,4})*sin(points(1,3));    %y(t)
        handles.table{n,3}=handles.table{n-1,4};    %lower bound for piece
        handles.table{n,4}=handles.table{n-1,4}+points(1,4);   %upper bound for piece
        handles.table{n,5}=1;   %line segment flag
    end
    set(handles.delete,'Visible','on')  %enable delete button
else    %use the point where the table left off as the starting point for the new piece
    %if points are typed in (not selected from graph)
    if get(handles.points1,'Value')==0
        answer=inputdlg({'angle wrt horizontal','length'},'Enter values');  %input prompt
        points=zeros(1,2);
        points(1,1)=str2double(answer{1}); %angle
        points(1,2)=str2double(answer{2}); %length
    else    %if points are selected from graph (not typed in)
        set(handles.directions,'String','Select endpoint of segment.')  %directions below graph
        endpt=round(ginput(1),1); %allow user to select the end point of the line segment and round to one decimal place
        points=[handles.table{end,1}(handles.table{end,4}),handles.table{end,2}(handles.table{end,4})]; %matrix containing starting points (previous endpoints)
        dist=sqrt((points(1,1)-endpt(1,1))^2+(points(1,2)-endpt(1,2))^2); %length of line segment
        ang=atan((endpt(1,2)-points(1,2))/(endpt(1,1)-points(1,1))); %angle wrt horizontal of line segment
        if endpt(1,1)<points(1,1);
            ang=pi+ang;
        end
        points=[ang,dist]; 
        set(handles.directions,'String','') %clear directions below graph
    end
    points=[handles.table{end,1}(handles.table{end,4}),handles.table{end,2}(handles.table{end,4}),points]; %add starting points as the first two columns of points (point where previous piece ended)

    n=size(handles.table,1)+1;  %number of piece being added
    %new piece:  [points(1,1)+(points(2,1)-points(1,1))*(t-handles.table{end,4})/distance,points(1,2)+(points(2,2)-points(1,2))*(t-handles.table{end,4})/distance,handles.table{end,4},handles.table{end,4}+distance];
    handles.table{n,1}=inline([num2str(points(1,1)),'+(t-',num2str(handles.table{n-1,4}),')*',num2str(cos(points(1,3)))]);
    %@(t) points(1,1)+(t-handles.table{n-1,4})*cos(points(1,3));    %x(t)
    handles.table{n,2}=inline([num2str(points(1,2)),'+(t-',num2str(handles.table{n-1,4}),')*',num2str(sin(points(1,3)))]);
    %@(t) points(1,2)+(t-handles.table{n-1,4})*sin(points(1,3));    %y(t)
    handles.table{n,3}=handles.table{n-1,4};    %lower bound for piece
    handles.table{n,4}=handles.table{n-1,4}+points(1,4);   %upper bound for piece
    handles.table{n,5}=1;   %line segment flag
    
end
n=size(handles.table,1);    %number of piece being added
ezplot(handles.table{n,1},handles.table{n,2},[handles.table{n,3},handles.table{n,4}])   %draw new piece
line([handles.table{n,1}(handles.table{n,3}),handles.table{n,1}(handles.table{n,4})],[handles.table{n,2}(handles.table{n,3}),handles.table{n,2}(handles.table{n,4})])   %draw new line segment
hold on
axis([str2num(get(handles.xmin,'String')),str2num(get(handles.xmax,'String')),str2num(get(handles.ymin,'String')),str2num(get(handles.ymax,'String'))]) %set axis to user-defined values
set(handles.axes,'XGrid','on')  %turn x-grid on
set(handles.axes,'YGrid','on')  %turn y-grid on
title('Billiard Table')
set(handles.continue1,'Visible','on')   %enable continue from last endpoint button
set(handles.continue2,'Visible','on')   %enable start from new endpoint button
guidata(gcbo,handles);


% --------------------------------------------------------------------
%Draws quarter circles
%points contains x and y coordinates of starting point, ending point, and a
%point toward the inside of the arc
function varargout = quartercircle_Callback(h, eventdata, handles, varargin)
%if beginning and ending points are selected (segment may not start where the table left off)
if ~(strcmp(get(handles.continue2,'Visible'),'on') & get(handles.continue1,'Value'))
    %if points are typed in (not selected from graph)
    if get(handles.points1,'Value')==0
        answer=inputdlg({'x-coordinate of starting point','y-coordinate of starting point','x-coordinate of ending point',...
            'y-coordinate of ending point','x-coordiante of point on inside','y-coordiante of point on inside'},'Enter points.'); %prompt for inputing points
        points=zeros(3,2);
        points(1,1)=str2double(answer{1}); %x-coordinate of start point
        points(1,2)=str2double(answer{2}); %y-coordinate of start point
        points(2,1)=str2double(answer{3}); %x-coordinate of end point
        points(2,2)=str2double(answer{4}); %y-coordinate of end point
        points(3,1)=str2double(answer{5}); %x-coordinate of point on inside of arc
        points(3,2)=str2double(answer{6}); %y-coordinate of point on inside of arc
    else    %if points are selected from graph (not typed in)
        set(handles.directions,'String','Select starting point of quarter circle.') %directions below graph
        points=round(ginput(1),1);    %allow user to select a point from the graph and round to one decimal place
        set(handles.directions,'String','Select endpoint of quarter circle.') %directions below graph
        points=[points;round(ginput(1),1)];    %allow user to select a point from the graph and round to one decimal place
        set(handles.directions,'String','Select inside of quarter circle.') %directions below graph
        points=[points;ginput(1)];    %allow user to select a point from the graph and round to one decimal place
        set(handles.directions,'String','') %clear directions below graph
    end
    
else    %use the point where the table left off as the starting point for the new piece
    %if points are typed in (not selected from graph)
    if get(handles.points1,'Value')==0
        answer=inputdlg({'x-coordinate of ending point','y-coordinate of ending point','x-coordiante of point on inside','y-coordiante of point on inside'},'Enter points.');   %input prompt
        points=zeros(2,2);
        points(1,1)=str2double(answer{1}); %x-coordinate of ending point
        points(1,2)=str2double(answer{2}); %y-coordinate of ending point
        points(2,1)=str2double(answer{3}); %x-coordinate of inside point
        points(2,2)=str2double(answer{4}); %y-coordinate of inside point
    else    %if points are selected from graph (not typed in)
        set(handles.directions,'String','Select endpoint of quarter circle.')   %directions below graph
        points=round(ginput(1),1);        %allow user to select a point from the graph and round to one decimal place
        set(handles.directions,'String','Select inside of quarter circle.')   %directions below graph
        points=[points;ginput(1)];    %allow user to select a point from the graph
        set(handles.directions,'String','')   %clear directions below graph
    end
    points=[handles.table{end,1}(handles.table{end,4}),handles.table{end,2}(handles.table{end,4});points];  %add starting point as the 1st row of points (the point where the previous piece ended)
end
 
    
%creation of piece
%if start and end points lie on a vertical line
if points(1,1)==points(2,1)
    %if the arc is traced clockwise
    if xor(points(3,1)<points(1,1),points(1,2)<points(2,2))
        center=[(points(1,1)-points(1,2)+points(2,1)+points(2,2))/2,(points(1,1)+points(1,2)-points(2,1)+points(2,2))/2];   %center of circle
        distance=sqrt((points(1,1)-center(1,1))^2+(points(1,2)-center(1,2))^2); %distance of arc
        theta=atan2(points(1,2)-center(1,2),points(1,1)-center(1,1));   %angle from center of circle to starting point
        if strcmp(get(handles.delete,'Visible'),'off')  %if first piece
            %new piece:  [center(1,1)+distance*cos(-t/distance+theta),center(1,2)+distance*sin(-t/distance+theta),0,distance*pi/2]
            handles.table{1,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos(-t/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,1)+distance*cos(-t/distance+theta);    %x(t)
            handles.table{1,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin(-t/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,2)+distance*sin(-t/distance+theta);    %y(t)
            handles.table{1,3}=0;   %lower bound for piece
            handles.table{1,4}=distance*pi/2;   %upper bound for piece
            handles.table{1,5}=2;   %arc flag
        else    %not first piece
            %new piece:  [center(1,1)+distance*cos(-(t-handles.table{end,4})/distance+theta),center(1,2)+distance*sin(-(t-handles.table{end,4})/distance+theta),handles.table{end,4},handles.table{end,4}+distance*pi/2]
            n=size(handles.table,1)+1;  %number of current piece
            handles.table{n,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos((-t+',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,1)+distance*cos((-t+handles.table{n-1,4})/distance+theta);    %x(t)
            handles.table{n,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin((-t+',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,2)+distance*sin((-t+handles.table{n-1,4})/distance+theta);    %y(t)
            handles.table{n,3}=handles.table{n-1,4};    %lower bound for piece
            handles.table{n,4}=handles.table{n-1,4}+distance*pi/2;  %upper bound for piece
            handles.table{n,5}=2;   %arc flag
        end
    else    %the arc is traced counterclockwise
        center=[(points(1,1)+points(1,2)+points(2,1)-points(2,2))/2,(-points(1,1)+points(1,2)+points(2,1)+points(2,2))/2];  %center of circle
        distance=sqrt((points(1,1)-center(1,1))^2+(points(1,2)-center(1,2))^2); %distance of arc
        theta=atan2(points(1,2)-center(1,2),points(1,1)-center(1,1));   %angle from center of circle to starting point
        if strcmp(get(handles.delete,'Visible'),'off')  %if first piece
            %new piece:  [center(1,1)+distance*cos(t/distance+theta),center(1,2)+distance*sin(t/distance+theta),0,distance*pi/2]
            handles.table{1,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos(t/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,1)+distance*cos(t/distance+theta); %x(t)
            handles.table{1,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin(t/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,2)+distance*sin(t/distance+theta); %y(t)
            handles.table{1,3}=0;   %lower bound for piece
            handles.table{1,4}=distance*pi/2;   %upper bound for piece
            handles.table{1,5}=2;   %arc flag
        else    %not first piece
            %new piece:  [center(1,1)+distance*cos((t-handles.table{end,4})/distance+theta),center(1,2)+distance*sin((t-handles.table{end,4})/distance+theta),handles.table{end,4},handles.table{end,4}+distance*pi/2]
            n=size(handles.table,1)+1;  %number of current piece
            handles.table{n,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos((t-',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,1)+distance*cos((t-handles.table{n-1,4})/distance+theta); %x(t)
            handles.table{n,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin((t-',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,2)+distance*sin((t-handles.table{n-1,4})/distance+theta); %y(t)
            handles.table{n,3}=handles.table{n-1,4};    %lower bound for piece
            handles.table{n,4}=handles.table{n-1,4}+distance*pi/2;  %upper bound for piece
            handles.table{n,5}=2;   %arc flag
        end
    end
else    %start and end points do not lie on a vertical line
    %if the arc is traced clockwise
    if xor(points(3,2)>((points(1,2)-points(2,2))*points(3,1)+points(1,1)*points(2,2)-points(1,2)*points(2,1))/(points(1,1)-points(2,1)),points(1,1)<points(2,1))
        center=[(points(1,1)-points(1,2)+points(2,1)+points(2,2))/2,(points(1,1)+points(1,2)-points(2,1)+points(2,2))/2];   %center of circle
        distance=sqrt((points(1,1)-center(1,1))^2+(points(1,2)-center(1,2))^2); %distance of arc
        theta=atan2(points(1,2)-center(1,2),points(1,1)-center(1,1));   %angle from center of circle to starting point
        if strcmp(get(handles.delete,'Visible'),'off')
            %new piece:  [center(1,1)+distance*cos(-t/distance+theta),center(1,2)+distance*sin(-t/distance+theta),0,distance*pi/2]
            handles.table{1,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos(-t/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,1)+distance*cos(-t/distance+theta);    %x(t)
            handles.table{1,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin(-t/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,2)+distance*sin(-t/distance+theta);    %y(t)
            handles.table{1,3}=0;   %lower bound for piece
            handles.table{1,4}=distance*pi/2;   %upper bound for piece
            handles.table{1,5}=2;   %arc flag
        else
            %new piece:  [center(1,1)+distance*cos(-(t-handles.table{end,4})/distance+theta),center(1,2)+distance*sin(-(t-handles.table{end,4})/distance+theta),handles.table{end,4},handles.table{end,4}+distance*pi/2]
            n=size(handles.table,1)+1;  %number of current piece
            handles.table{n,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos((-t+',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,1)+distance*cos((-t+handles.table{n-1,4})/distance+theta);    %x(t)
            handles.table{n,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin((-t+',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,2)+distance*sin((-t+handles.table{n-1,4})/distance+theta);    %y(t)
            handles.table{n,3}=handles.table{n-1,4};    %lower bound for piece
            handles.table{n,4}=handles.table{n-1,4}+distance*pi/2;  %upper bound for piece
            handles.table{n,5}=2;   %arc flag
        end
    else    %arc is traced counterclockwise
        center=[(points(1,1)+points(1,2)+points(2,1)-points(2,2))/2,(-points(1,1)+points(1,2)+points(2,1)+points(2,2))/2];   %center of circle
        distance=sqrt((points(1,1)-center(1,1))^2+(points(1,2)-center(1,2))^2); %distance of arc
        theta=atan2(points(1,2)-center(1,2),points(1,1)-center(1,1));   %angle from center of circle to starting point
        if strcmp(get(handles.delete,'Visible'),'off')
            %new piece:  [center(1,1)+distance*cos(t/distance+theta),center(1,2)+distance*sin(t/distance+theta),0,distance*pi/2]
            handles.table{1,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos(t/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,1)+distance*cos(t/distance+theta); %x(t)
            handles.table{1,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin(t/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,2)+distance*sin(t/distance+theta); %y(t)
            handles.table{1,3}=0;   %lower bound for piece
            handles.table{1,4}=distance*pi/2;   %upper bound for piece
            handles.table{1,5}=2;   %arc flag
        else
            %new piece:  [center(1,1)+distance*cos((t-handles.table{end,4})/distance+theta),center(1,2)+distance*sin((t-handles.table{end,4})/distance+theta),handles.table{end,4},handles.table{end,4}+distance*pi/2]
            n=size(handles.table,1)+1;  %number of current piece
            handles.table{n,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos((t-',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,1)+distance*cos((t-handles.table{n-1,4})/distance+theta); %x(t)
            handles.table{n,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin((t-',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']);
            %@(t) center(1,2)+distance*sin((t-handles.table{n-1,4})/distance+theta); %y(t)
            handles.table{n,3}=handles.table{n-1,4};    %lower bound for piece
            handles.table{n,4}=handles.table{n-1,4}+distance*pi/2;  %upper bound for piece
            handles.table{n,5}=2;   %arc flag
        end
    end
end
set(handles.delete,'Visible','on')  %enable delete button
n=size(handles.table,1);    %number of new piece
ezplot(handles.table{n,1},handles.table{n,2},[handles.table{n,3},handles.table{n,4}])   %draw new piece
hold on
axis([str2num(get(handles.xmin,'String')),str2num(get(handles.xmax,'String')),str2num(get(handles.ymin,'String')),str2num(get(handles.ymax,'String'))]) %set axis to user-defined values
set(handles.axes,'XGrid','on')  %show x-grid
set(handles.axes,'YGrid','on')  %show y-grid
title('Billiard Table')
set(handles.continue1,'Visible','on')   %enable continue from last endpoint button
set(handles.continue2,'Visible','on')   %enable start from new endpoint button
guidata(gcbo,handles);


% --------------------------------------------------------------------
%Draws semicircles
%points contains x and y coordinates of starting point, ending point, and a
%point toward the inside of the arc
function varargout = semicircle_Callback(h, eventdata, handles, varargin)
%if beginning and ending points are selected (segment may not start where the table
% left off)
if ~(strcmp(get(handles.continue2,'Visible'),'on') & get(handles.continue1,'Value'))
    %if points are typed in (not selected from graph)
    if get(handles.points1,'Value')==0
        answer=inputdlg({'x-coordinate of starting point','y-coordinate of starting point','x-coordinate of ending point','y-coordinate of ending point','x-coordiante of point on inside','y-coordiante of point on inside'},'Enter points.'); %prompt for inputing points
        points=zeros(3,2);
        points(1,1)=str2double(answer{1}); %x-coordinate of start point
        points(1,2)=str2double(answer{2}); %y-coordinate of start point
        points(2,1)=str2double(answer{3}); %x-coordinate of end point
        points(2,2)=str2double(answer{4}); %y-coordinate of end point
        points(3,1)=str2double(answer{5}); %x-coordiante of point on inside of arc
        points(3,2)=str2double(answer{6}); %y-coordiante of point on inside of arc
    else    %if points are selected from graph (not typed in)
        set(handles.directions,'String','Select starting point of semicircle.')  %directions below graph
        points=round(ginput(1));    %allow user to select a point from the graph and round to the nearest integer
        set(handles.directions,'String','Select endpoint of semicircle.') %directions below graph
        points=[points;round(ginput(1))];   %allow user to select a point from the graph and round to the nearest integer
        set(handles.directions,'String','Select inside of semicircle.') %directions below graph
        points=[points;ginput(1)];  %allow user to select a point from the graph and round to the nearest integer
        set(handles.directions,'String','') %clear directions below graph
    end
    
else    %use the point where the table left off as the starting point for the new piece
    %if points are typed in (not selected from graph)
    if get(handles.points1,'Value')==0
        answer=inputdlg({'x-coordinate of ending point','y-coordinate of ending point','x-coordiante of point on inside','y-coordiante of point on inside'},'Enter points.');   %input prompt
        points=zeros(2,2);
        points(1,1)=str2double(answer{1}); %x-coordinate of ending point
        points(1,2)=str2double(answer{2}); %y-coordinate of ending point
        points(2,1)=str2double(answer{3}); %x-coordinate of inside point
        points(2,2)=str2double(answer{4}); %y-coordinate of inside point
    else    %if points are selected from graph (not typed in)
        set(handles.directions,'String','Select endpoint of semicircle.')   %directions below graph
        points=round(ginput(1));    %allow user to select a point from the graph and round to the nearest integer
        set(handles.directions,'String','Select inside of semicircle.') %directions below graph
        points=[points;ginput(1)];  %allow user to select a point from the graph
        set(handles.directions,'String','') %clear directions below graph
    end
    points=[handles.table{end,1}(handles.table{end,4}),handles.table{end,2}(handles.table{end,4});points];  %add starting point as the 1st row of points (the point where the previous piece ended)
end

%creation of piece
center=[(points(1,1)+points(2,1))/2,(points(1,2)+points(2,2))/2];   %center of circle
distance=sqrt((points(1,1)-center(1,1))^2+(points(1,2)-center(1,2))^2); %distance of arc

%if start and end points lie on a vertical line
if points(1,1)==points(2,1)
    %if the arc is traced clockwise
    if xor(points(3,1)<points(1,1),points(1,2)<points(2,2))
        theta=atan2(points(1,2)-center(1,2),points(1,1)-center(1,1));   %angle from center of circle to starting point
        if strcmp(get(handles.delete,'Visible'),'off')  %if first piece
            %new piece:  [center(1,1)+distance*cos(-t/distance+theta),center(1,2)+distance*sin(-t/distance+theta),0,distance*pi]
            handles.table{1,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos(-t/',num2str(distance),'+',num2str(theta),')']);    %x(t)
             %@(t) center(1,1)+distance*cos(-t/distance+theta);    %x(t)
            handles.table{1,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin(-t/',num2str(distance),'+',num2str(theta),')']);    %y(t)
             %@(t) center(1,2)+distance*sin(-t/distance+theta);    %x(t)
            handles.table{1,3}=0;   %lower bound for piece
            handles.table{1,4}=distance*pi; %upper bound for piece
            handles.table{1,5}=2;   %arc flag
        else    %not first piece
            %new piece:  [center(1,1)+distance*cos(-(t-handles.table{end,4})/distance+theta),center(1,2)+distance*sin(-(t-handles.table{end,4})/distance+theta),handles.table{end,4},handles.table{end,4}+distance*pi]
            n=size(handles.table,1)+1;  %number of current piece
            handles.table{n,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos((-t+',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']);    %x(t)
           %@(t) center(1,1)+distance*cos((-t+handles.table{n-1,4})/distance)+theta;    %x(t)
            handles.table{n,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin((-t+',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']);    %y(t)
            %@(t) center(1,2)+distance*sin((-t+handles.table{n-1,4})/distance)+theta;    %x(t)
            handles.table{n,3}=handles.table{n-1,4};    %lower bound for piece
            handles.table{n,4}=handles.table{n-1,4}+distance*pi;    %upper bound for piece
            handles.table{n,5}=2;   %arc flag
        end
    else    %the arc is traced counterclockwise
        theta=atan2(points(1,2)-center(1,2),points(1,1)-center(1,1));   %angle from center of circle to starting point
        if strcmp(get(handles.delete,'Visible'),'off')  %if first piece
            %new piece:  [center(1,1)+distance*cos(t/distance+theta),center(1,2)+distance*sin(t/distance+theta),0,distance*pi]
            handles.table{1,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos(t/',num2str(distance),'+',num2str(theta),')']); %x(t)
            %@(t) center(1,1)+distance*cos(t/distance+theta); %x(t)
            handles.table{1,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin(t/',num2str(distance),'+',num2str(theta),')']); %y(t)
            %@(t) center(1,2)+distance*sin(t/distance+theta); %x(t)
            handles.table{1,3}=0;   %lower bound for piece
            handles.table{1,4}=distance*pi; %upper bound for piece
            handles.table{1,5}=2;   %arc flag
        else    %not first piece
            %new piece:  [center(1,1)+distance*cos((t-handles.table{end,4})/distance+theta),center(1,2)+distance*sin((t-handles.table{end,4})/distance+theta),handles.table{end,4},handles.table{end,4}+distance*pi]
            n=size(handles.table,1)+1;
            handles.table{n,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos((t-',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']); %x(t)
            %@(t) center(1,1)+distance*cos((t-handles.table{n-1,4})/distance+theta); %x(t)
            handles.table{n,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin((t-',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']); %y(t)
            %@(t) center(1,2)+distance*sin((t-handles.table{n-1,4})/distance+theta); %x(t)
            handles.table{n,3}=handles.table{n-1,4};    %lower bound for piece
            handles.table{n,4}=handles.table{n-1,4}+distance*pi;    %upper bound for piece
            handles.table{n,5}=2;   %arc flag
        end
    end
    
else    %start and end points do not lie on a vertical line
    %if the arc is traced clockwise
    if xor(points(3,2)>((points(1,2)-points(2,2))*points(3,1)+points(1,1)*points(2,2)-points(1,2)*points(2,1))/(points(1,1)-points(2,1)),points(1,1)<points(2,1))
        theta=atan2(points(1,2)-center(1,2),points(1,1)-center(1,1));   %angle from center of circle to starting point
        if strcmp(get(handles.delete,'Visible'),'off')  %if first piece
            %new piece:  [center(1,1)+distance*cos(-t/distance+theta),center(1,2)+distance*sin(-t/distance+theta),0,distance*pi]
            handles.table{1,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos(-t/',num2str(distance),'+',num2str(theta),')']);    %x(t)
            %@(t) center(1,1)+distance*cos(-t/distance+theta);    %x(t)
            handles.table{1,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin(-t/',num2str(distance),'+',num2str(theta),')']);    %y(t)
            %@(t) center(1,2)+distance*sin(-t/distance+theta);    %x(t)
            handles.table{1,3}=0;   %lower bound for piece
            handles.table{1,4}=distance*pi; %upper bound for piece
            handles.table{1,5}=2;   %arc flag
        else    %not first piece
            %new piece:  [center(1,1)+distance*cos(-(t-handles.table{end,4})/distance+theta),center(1,2)+distance*sin(-(t-handles.table{end,4})/distance+theta),handles.table{end,4},handles.table{end,4}+distance*pi]
            n=size(handles.table,1)+1;  %number of current piece
            handles.table{n,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos((-t+',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']);    %x(t)
            %@(t) center(1,1)+distance*cos((-t+handles.table{n-1,4})/distance+theta);    %x(t)
            handles.table{n,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin((-t+',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']);    %y(t)
            %@(t) center(1,2)+distance*sin((-t+handles.table{n-1,4})/distance+theta);    %x(t)
            handles.table{n,3}=handles.table{n-1,4};    %lower bound for piece
            handles.table{n,4}=handles.table{n-1,4}+distance*pi;    %upper bound for piece
            handles.table{n,5}=2;   %arc flag    
        end

    else
        theta=atan2(points(1,2)-center(1,2),points(1,1)-center(1,1));   %angle from center of circle to starting point
        if strcmp(get(handles.delete,'Visible'),'off')  %if first piece
            %new piece:  [center(1,1)+distance*cos(t/distance+theta),center(1,2)+distance*sin(t/distance+theta),0,distance*pi]
            handles.table{1,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos(t/',num2str(distance),'+',num2str(theta),')']); %x(t)
            %@(t) center(1,1)+distance*cos(t/distance+theta); %x(t)
            handles.table{1,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin(t/',num2str(distance),'+',num2str(theta),')']); %y(t)
            %@(t) center(1,2)+distance*sin(t/distance+theta); %x(t)
            handles.table{1,3}=0;   %lower bound for piece
            handles.table{1,4}=distance*pi; %upper bound for piece
            handles.table{1,5}=2;   %arc flag
        else    %not first piece
            %new piece:  [center(1,1)+distance*cos((t-handles.table{end,4})/distance+theta),center(1,2)+distance*sin((t-handles.table{end,4})/distance+theta),handles.table{end,4},handles.table{end,4}+distance*pi]
            n=size(handles.table,1)+1;  %number of current piece
            handles.table{n,1}=inline([num2str(center(1,1)),'+',num2str(distance),'*cos((t-',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']); %x(t)
            %@(t) center(1,1)+distance*cos((t-handles.table{n-1,4})/distance+theta); %x(t)
            handles.table{n,2}=inline([num2str(center(1,2)),'+',num2str(distance),'*sin((t-',num2str(handles.table{n-1,4}),')/',num2str(distance),'+',num2str(theta),')']); %y(t)
            %@(t) center(1,2)+distance*sin((t-handles.table{n-1,4})/distance+theta); %x(t)
            handles.table{n,3}=handles.table{n-1,4};    %lower bound for piece
            handles.table{n,4}=handles.table{n-1,4}+distance*pi;    %upper bound for piece
            handles.table{n,5}=2;   %arc flag
        end
    end
end
 
set(handles.delete,'Visible','on')  %enable delete button
n=size(handles.table,1);    %number of new piece
ezplot(handles.table{n,1},handles.table{n,2},[handles.table{n,3},handles.table{n,4}])   %draw new piece
hold on
axis([str2num(get(handles.xmin,'String')),str2num(get(handles.xmax,'String')),str2num(get(handles.ymin,'String')),str2num(get(handles.ymax,'String'))]) %set axis to user-defined values
set(handles.axes,'XGrid','on')  %show x-grid
set(handles.axes,'YGrid','on')  %show y-grid
title('Billiard Table')
set(handles.continue1,'Visible','on')   %enable continue from last endpoint button
set(handles.continue2,'Visible','on')   %enable start from new endpoint button
guidata(gcbo,handles);


% --------------------------------------------------------------------
%Draws quarter ellipse
%points contains x and y coordinates of starting point, ending point, and a
%point toward the inside of the arc
function varargout = quarterellipse_Callback(h, eventdata, handles, varargin)
%if beginning and ending points are selected (segment may not start where the table
% left off)
if ~(strcmp(get(handles.continue2,'Visible'),'on') & get(handles.continue1,'Value'))
    %if points are typed in (not selected from graph)
    if get(handles.points1,'Value')==0
        answer=inputdlg({'x-coordinate of starting point','y-coordinate of starting point','x-coordinate of ending point',...
            'y-coordinate of ending point','x-coordiante of point on inside','y-coordiante of point on inside'},'Enter points.'); %prompt for inputing points
        points=zeros(3,2);
        points(1,1)=str2double(answer{1}); %x-coordinate of start point
        points(1,2)=str2double(answer{2}); %y-coordinate of start point
        points(2,1)=str2double(answer{3}); %x-coordinate of end point
        points(2,2)=str2double(answer{4}); %y-coordinate of end point
        points(3,1)=str2double(answer{5}); %x-coordiante of point on inside of arc
        points(3,2)=str2double(answer{6}); %y-coordiante of point on inside of arc
    else    %if points are selected from graph (not typed in)
        set(handles.directions,'String','Select starting point of quarter ellipse.') %directions below graph
        points=round(ginput(1),1);    %allow user to select a point from the graph and round to one decimal place
        set(handles.directions,'String','Select endpoint of quarter ellipse.') %directions below graph
        points=[points;round(ginput(1),1)];    %allow user to select a point from the graph and round to one decimal place
        set(handles.directions,'String','Select inside of quarter ellipse.') %directions below graph
        points=[points;ginput(1)];    %allow user to select a point from the graph and round to one decimal place
        set(handles.directions,'String','') %clear directions below graph
    end
    
else    %use the point where the table left off as the starting point for the new piece
    %if points are typed in (not selected from graph)
    if get(handles.points1,'Value')==0
        answer=inputdlg({'x-coordinate of ending point','y-coordinate of ending point','x-coordiante of point on inside','y-coordiante of point on inside'},'Enter points.');   %input prompt
        points=zeros(2,2);
        points(1,1)=str2double(answer{1}); %x-coordinate of ending point
        points(1,2)=str2double(answer{2}); %y-coordinate of ending point
        points(2,1)=str2double(answer{3}); %x-coordinate of inside point
        points(2,2)=str2double(answer{4}); %y-coordinate of inside point
    else    %if points are selected from graph (not typed in)
        set(handles.directions,'String','Select endpoint of quarter ellipse.')   %directions below graph
        points=round(ginput(1),1);        %allow user to select a point from the graph and round to one decimal place
        set(handles.directions,'String','Select inside of quarter ellipse.')   %directions below graph
        points=[points;ginput(1)];    %allow user to select a point from the graph
        set(handles.directions,'String','')   %clear directions below graph
    end
    points=[handles.table{end,1}(handles.table{end,4}),handles.table{end,2}(handles.table{end,4});points];  %add starting point as the 1st row of points (the point where the previous piece ended)
end
 
    
%creation of piece
a=abs(points(1,1)-points(2,1)); %horizontal radius
b=abs(points(1,2)-points(2,2)); %vertical radius
%distance=b*integral (@(t) (1+(a^2-b^2)/b^2*sin(t).^2),0,2*pi)/4;   %length of quarter ellipse
distance=b*quad(inline(['1+',num2str((a^2-b^2)/b^2),'*sin(t).^2']),0,2*pi)/4;   %length of quarter ellipse

if points(1,1)<points(2,1)  %if 1st point is left of 2nd point
    if points(1,2)<points(2,2)  %if 1st point is above 2nd point
        %if inside point is to top left
        if points(3,2)>((points(1,2)-points(2,2))*points(3,1)+points(1,1)*points(2,2)-points(1,2)*points(2,1))/(points(1,1)-points(2,1))
            table{1,1}=inline([num2str(points(1,1)),'+',num2str(a),'*cos(3*pi/2+t*',num2str(pi/distance/2),')']);
            %@(t) points(1,1)+a*cos(3*pi/2+t*pi/distance/2);
            table{1,2}=inline([num2str(points(2,2)),'+',num2str(b),'*sin(3*pi/2+t*',num2str(pi/distance/2),')']);
            %@(t) points(2,2)+b*sin(3*pi/2+t*pi/distance/2);
        else    %inside point is to bottom right
            table{1,1}=inline([num2str(points(2,1)),'+',num2str(a),'*cos(pi-t*',num2str(pi/distance/2),')']);
            %@(t) points(2,1)+a*cos(pi-t*pi/distance/2);
            table{1,2}=inline([num2str(points(1,2)),'+',num2str(b),'*sin(pi-t*',num2str(pi/distance/2),')']);
            %@(t) points(1,2)+b*sin(pi-t*pi/distance/2);
        end
    else    %1st point is below 2nd point
        %if inside point is to top right
        if points(3,2)>((points(1,2)-points(2,2))*points(3,1)+points(1,1)*points(2,2)-points(1,2)*points(2,1))/(points(1,1)-points(2,1))
            table{1,1}=inline([num2str(points(2,1)),'+',num2str(a),'*cos(pi+t*',num2str(pi/distance/2),')']);
            %@(t) points(2,1)+a*cos(pi+t*pi/distance/2);
            table{1,2}=inline([num2str(points(1,2)),'+',num2str(b),'*sin(pi+t*',num2str(pi/distance/2),')']);
            %@(t) points(1,2)+b*sin(pi+t*pi/distance/2);
        else    %inside point is to bottom left
            table{1,1}=inline([num2str(points(1,1)),'+',num2str(a),'*cos(pi/2-t*',num2str(pi/distance/2),')']);
            %@(t) points(1,1)+a*cos(pi/2-t*pi/distance/2);
            table{1,2}=inline([num2str(points(2,2)),'+',num2str(b),'*sin(pi/2-t*',num2str(pi/distance/2),')']);
            %@(t) points(2,2)+b*sin(pi/2-t*pi/distance/2);
        end
    end
    
else    %1st point is to right of the 2nd point
    if points(1,2)<points(2,2)  %if 1st point is above 2nd point
        %if inside point is to top right
        if points(3,2)>((points(1,2)-points(2,2))*points(3,1)+points(1,1)*points(2,2)-points(1,2)*points(2,1))/(points(1,1)-points(2,1))
            table{1,1}=inline([num2str(points(1,1)),'+',num2str(a),'*cos(3*pi/2-t*',num2str(pi/distance/2),')']);
            %@(t) points(1,1)+a*cos(3*pi/2-t*pi/distance/2);
            table{1,2}=inline([num2str(points(2,2)),'+',num2str(b),'*sin(3*pi/2-t*',num2str(pi/distance/2),')']);
            %@(t) points(2,2)+b*sin(3*pi/2-t*pi/distance/2);
        else    %inside point is to bottom left
            table{1,1}=inline([num2str(points(2,1)),'+',num2str(a),'*cos(t*',num2str(pi/distance/2),')']);
            %@(t) points(2,1)+a*cos(t*pi/distance/2);
            table{1,2}=inline([num2str(points(1,2)),'+',num2str(b),'*sin(t*',num2str(pi/distance/2),')']);
            %@(t) points(1,2)+b*sin(t*pi/distance/2);
        end
    else    %1st point is below 2nd point
        %if inside point is to top left
        if points(3,2)>((points(1,2)-points(2,2))*points(3,1)+points(1,1)*points(2,2)-points(1,2)*points(2,1))/(points(1,1)-points(2,1))
            table{1,1}=inline([num2str(points(2,1)),'+',num2str(a),'*cos(-t*',num2str(pi/distance/2),')']);
            %@(t) points(2,1)+a*cos(-t*pi/distance/2);
            table{1,2}=inline([num2str(points(1,2)),'+',num2str(b),'*sin(-t*',num2str(pi/distance/2),')']);
            %@(t) points(1,2)+b*sin(-t*pi/distance/2);
        else    %inside point is to bottom right
            table{1,1}=inline([num2str(points(1,1)),'+',num2str(a),'*cos(pi/2+t*',num2str(pi/distance/2),')']);
            %@(t) points(1,1)+a*cos(pi/2+t*pi/distance/2);
            table{1,2}=inline([num2str(points(2,2)),'+',num2str(b),'*sin(pi/2+t*',num2str(pi/distance/2),')']);
            %@(t) points(2,2)+b*sin(pi/2+t*pi/distance/2);
        end
    end
end

if strcmp(get(handles.delete,'Visible'),'off')  %if first piece
    n=1;
    handles.table{1,1}=table{1,1};
    handles.table{1,2}=table{1,2};
    handles.table{1,3}=0;
    handles.table{1,4}=distance;
    handles.table{1,5}=2;
else    %if this is not the first piece
    syms t
    n=size(handles.table,1)+1;  %number of current piece
    to=handles.table{n-1,4};
    handles.table{n,1}=inline(char(table{1,1}(t-to)),'t');
    %@(t) char(table{1,1}(t-to));   %make x(t) be x(t-to)
    handles.table{n,2}=inline(char(table{1,2}(t-to)),'t');
    %@(t) char(table{1,2}(t-to));   %make y(t) be x(t-to)
    handles.table{n,3}=to;
    handles.table{n,4}=to+distance;
    handles.table{n,5}=2;
end


set(handles.delete,'Visible','on')  %enable delete button
ezplot(handles.table{n,1},handles.table{n,2},[handles.table{n,3},handles.table{n,4}])   %draw new piece
hold on
axis([str2num(get(handles.xmin,'String')),str2num(get(handles.xmax,'String')),str2num(get(handles.ymin,'String')),str2num(get(handles.ymax,'String'))]) %set axis to user-defined values
set(handles.axes,'XGrid','on')  %show x-grid
set(handles.axes,'YGrid','on')  %show y-grid
title('Billiard Table')
set(handles.continue1,'Visible','on')   %enable continue from last endpoint button
set(handles.continue2,'Visible','on')   %enable start from new endpoint button
guidata(gcbo,handles);



% --------------------------------------------------------------------
function varargout = delete_Callback(h, eventdata, handles, varargin)
%deletes last piece from table

%if table only contains one piece
if size(handles.table,1)==1
    handles.table=[];   %delete table
    set(handles.delete,'Visible','off') %disable delete button
    set(handles.continue1,'Visible','off')  %disable continue from last endpoint button
    set(handles.continue2,'Visible','off')  %disable start from new endpoint button
else    %more than one piece is present
    %delete last piece from table
    for n=1:size(handles.table,1)-1
        for m=1:5
            table{n,m}=handles.table{n,m};
        end
    end
    handles.table=table;
end
hold off
cla %clear graph

%draw saved table
for n=1:size(handles.stable,1)   %loop through all pieces
    ezplot(handles.stable{n,1},handles.stable{n,2},[handles.stable{n,3},handles.stable{n,4}])   %plot each piece
    hold on
    if handles.stable{n,5}==1  %check for horizontal and vertical pieces
        line([handles.stable{n,1}(handles.stable{n,3}),handles.stable{n,1}(handles.stable{n,4})],[handles.stable{n,2}(handles.stable{n,3}),handles.stable{n,2}(handles.stable{n,4})])   %darken horizontal and vertical lines
    end
end

%draw new table
for n=1:size(handles.table,1)   %loop through all pieces
    ezplot(handles.table{n,1},handles.table{n,2},[handles.table{n,3},handles.table{n,4}])   %plot each piece
    hold on
    if handles.table{n,5}==1  %check for horizontal and vertical pieces
        line([handles.table{n,1}(handles.table{n,3}),handles.table{n,1}(handles.table{n,4})],[handles.table{n,2}(handles.table{n,3}),handles.table{n,2}(handles.table{n,4})])   %darken horizontal and vertical lines
    end
end
axis([str2double(get(handles.xmin,'String')),str2double(get(handles.xmax,'String')),str2double(get(handles.ymin,'String')),str2double(get(handles.ymax,'String'))]) %set bounds for axis to user defined values
set(handles.axes,'XGrid','on')  %show x-grid
set(handles.axes,'YGrid','on')  %show y-grid
title('Billiard Table')
guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = continue1_Callback(h, eventdata, handles, varargin)
%turn off start from new endpoint button when continue from last endpoint
%button is pressed
set(handles.continue2,'Value',0)


% --------------------------------------------------------------------
function varargout = continue2_Callback(h, eventdata, handles, varargin)
%turn off continue from last endpoint button when start from new endpoint
%button is pressed
set(handles.continue1,'Value',0)


% --------------------------------------------------------------------
function varargout = done_Callback(h, eventdata, handles, varargin)
%close program and return table back to the billiard program when done
close
billiards('custom_Callback',handles.call,[],guidata(handles.call),handles.table);


% --------------------------------------------------------------------
function varargout = parametric_Callback(h, eventdata, handles, varargin)
%create parametric pieces
answer=inputdlg({'x(t)','y(t)','lower bound for t','upper bound for t'},'Parametric equations for a piece',1,{'','','0',''});   %input prompt
syms t  %declar t a symbolic variable
for n=1:4
    answer{n}=sym(answer{n});   %make entered values symbolic
end
if double(answer{3})~=0 %if parametric equation does not start at t=0
    answer{1}=subs(answer{1},t-answer{3});  %shift x(t) so piece starts at t=0
    answer{2}=subs(answer{2},t-answer{3});  %shift y(t) so piece starts at t=0
end
if strcmp(get(handles.delete,'Visible'),'off')  %if this is the first piece
    handles.table{1,1}=@(t) char(answer{1}); %x(t)
    handles.table{1,2}=@(t) char(answer{2}); %y(t)
    handles.table{1,3}=double(answer{3});   %lower bound for piece
    handles.table{1,4}=double(answer{4});   %upper bound for piece
    handles.table{1,5}=0;   %non-segment/arc flag
else    %not the first piece
    answer{1}=subs(answer{1},t-handles.table{end,4});   %shift x(t) so piece starts where the previous piece ended
    answer{2}=subs(answer{2},t-handles.table{end,4});   %shift y(t) so piece starts where the previous piece ended
    answer{4}=answer{4}-answer{3}+handles.table{end,4}; %upper bound for piece
    answer{3}=handles.table{end,4}; %lower bound for piece
    n=size(handles.table,1)+1;  %number of current piece
    
    handles.table{n,1}=@(t) char(answer{1}); %x(t)
    handles.table{n,2}=@(t) char(answer{2}); %y(t)
    handles.table{n,3}=double(answer{3});   %lower bound for piece
    handles.table{n,4}=double(answer{4});   %upper bound for piece
    handles.table{n,5}=0;  %non-segment/arc flag
    
end
guidata(gcbo,handles);
n=size(handles.table,1);    %number of new piece
ezplot(handles.table{n,1},handles.table{n,2},[handles.table{n,3},handles.table{n,4}])   %draw new piece
hold on

%change input values of axes bounds to the automatic rescaled values
answer=get(handles.axes,'XLim');
set(handles.xmin,'String',num2str(answer(1)))
set(handles.xmax,'String',num2str(answer(2)))
answer=get(handles.axes,'YLim');
set(handles.ymin,'String',num2str(answer(1)))
set(handles.ymax,'String',num2str(answer(2)))
set(handles.delete,'Visible','on')
set(handles.axes,'XGrid','on')
set(handles.axes,'YGrid','on')

title('Billiard Table')
set(handles.continue1,'Visible','on')   %enable continue from last endpoint button
set(handles.continue2,'Visible','on')   %enable start from new endpoint button


% --------------------------------------------------------------------
function varargout = points1_Callback(h, eventdata, handles, varargin)
%disable typing in coordinates when clicking on graph button is pressed
set(handles.points2,'Value',0)


% --------------------------------------------------------------------
function varargout = points2_Callback(h, eventdata, handles, varargin)
%disable clicking on graph to enter coordinates when typing button is
%pressed
set(handles.points1,'Value',0)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over line.
function line_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on line and none of its controls.
function line_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to line (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
