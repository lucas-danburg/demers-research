function varargout = billiards(varargin)
%Program to simulate arbitrary classical billiard systems.
%handles.table  saved table
%   columns:  x(t), y(t), lower bound for t, upper bound for t
%   each row is a different piece of the table
%handles.data  iteration data
%   this is a cell array, 1 cell for each new set of initial conditions
%   columns:  t, horizontal initl3, incident initl3, piece
%   1 row for each iteration
%handles.initcond  cell array of all initial conditions (used primarily for
%   drawing configuration space)
%handles.tables  boolean saying whether or not tables are saved for creating overlapping
%   tables
%handles.stable saved table that should not be edited when creating
%   overlapping tables
%handles stores all data for the GUI that must be carried between different
%   functions including GUI details, table, data, etc
%set(handles.___,'Visible','on/off') turns GUI object to be visible or not
%   visible (controls what GUI buttons/labels are present)
%guidata(fig,handles) saves modified handles structure

% BILLIARDS Application M-file for billiards.fig
%    FIG = BILLIARDS launch billiards BILLIARDS.
%    BILLIARDS('callback_name', ...) invoke the named callback.
% Last Modified by GUIDE v2.5 16-Jun-2025 09:55:50
if nargin == 0  % LAUNCH GUI
   
	fig = openfig(mfilename,'reuse');
	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));
	% Generate a structure of handles to pass to callbacks, and store it. 
    handles = guihandles(fig);
    
    %performed once during launch of billiards
    handles.tables=0;   %there are no saved tables
    handles.fps=3;  %default frame rate for movies
    handles.data=[];    %clear data on start-up
    guidata(fig, handles);
    set(handles.savet,'Enable','off')   %turn off file, save table
    set(handles.saved,'Enable','off')   %turn off file, save data
    set(handles.newinitmenu,'Enable','off') %turn off file, new initial conditions
    
	if nargout > 0
		varargout{1} = fig;
	end
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
function varargout = newtable_Callback(h, eventdata, handles, varargin)
%starts program over so one can enter a new table
cla %clear preview plot
handles.tables=0;   %no saved tables are present
handles.data=[];    %clear data
guidata(gcbo,handles);
set(handles.stop,'Visible','off')
set(handles.stopl,'Visible','off')
set(handles.analysisl,'Visible','off')
set(handles.datal,'Visible','off')
set(handles.moviel,'Visible','off')
set(handles.movie1,'Visible','off')
set(handles.movie2,'Visible','off')
set(handles.movieview,'Visible','off')
set(handles.moviesave1,'Visible','off')
set(handles.moviesave2,'Visible','off')
set(handles.moviebutton,'Visible','off')
set(handles.databox,'Visible','off')
set(handles.radio1,'Visible','off')
set(handles.radio2,'Visible','off')
set(handles.databutton,'Visible','off')
set(handles.plotsl,'Visible','off')
set(handles.analysis,'Visible','off')
set(handles.analysisbutton,'Visible','off')
set(handles.newtable,'Visible','off')
set(handles.initial,'Visible','off')
set(handles.more,'Visible','off')
set(handles.nmore,'Visible','off')
set(handles.frame3,'Visible','off')
set(handles.frame4,'Visible','off')
set(handles.frame5,'Visible','off')
set(handles.frame6,'Visible','off')
set(handles.frame1,'Visible','on')
set(handles.frame2,'Visible','on')
set(handles.frame9,'Visible','on')
set(handles.nmax,'String','')
set(handles.nmax,'Visible','on')
set(handles.nmaxl,'Visible','on')
set(handles.run,'Visible','on')
set(handles.init,'Visible','on')
set(handles.initradio1,'Visible','on')
set(handles.initradio2,'Visible','on')
%set(handles.radiobutton9, 'Visible','on')
set(handles.inite3,'String','')
set(handles.inite3,'Visible','on')
set(handles.inite2,'String','')
set(handles.inite2,'Visible','on')
set(handles.initl3,'Visible','on')
set(handles.initl2,'Visible','on')
set(handles.inite1,'String','')
set(handles.inite1,'Visible','on')
set(handles.initl1,'Visible','on')
set(handles.initphase,'Visible','on')
set(handles.tablepopup,'Visible','on')
set(handles.tablepopup,'Value',1)
set(handles.param1l,'Visible','off')
set(handles.param1e,'Visible','off')
set(handles.param1e2,'Visible','off')
set(handles.param2l,'Visible','off')
set(handles.param2e,'Visible','off')
set(handles.param2e2,'Visible','off')
set(handles.param3l,'Visible','off')
set(handles.param3e,'Visible','off')
set(handles.param3e2,'Visible','off')
set(handles.param4l,'Visible','off')
set(handles.param4e,'Visible','off')
set(handles.param4e2,'Visible','off')
set(handles.extraoptions,'Visible','off')
set(handles.extraoptions2,'Visible','off')
set(handles.center,'Visible','off')
set(handles.cxl,'Visible','off')
set(handles.cyl,'Visible','off')
set(handles.cx,'Visible','off')
set(handles.cy,'Visible','off')
set(handles.add,'Visible','off')
set(handles.preview,'Visible','off')
set(handles.saved,'Enable','off')   %turn off file, save data
set(handles.savet,'Enable','off')   %turn off file, save table
set(handles.newinitmenu,'Enable','off') %turn off file, new initial conditions
set(handles.initphase,'Enable','off')   %ghost button for selecting initial conditions from phase space
set(handles.text21,'Visible','off') %TEST
% --------------------------------------------------------------------
function varargout = opent_Callback(h, eventdata, handles, varargin)
%open a saved table
uiload;    %prompt for selecting file
set(handles.savet,'Enable','on')    %turn on file, save table
set(handles.newinitmenu,'Enable','on')  %turn on file, new initial conditions
set(handles.initphase,'Enable','on')    %enable button for selecting initial conditions from phase space
handles.table=table;    %load table
handles.data={};    %clear data
handles.initcond={};    %clear initial conditions
guidata(gcbo,handles);
initial_Callback(h, eventdata, handles, varargin)   %execute same code as when you enter new initial conditions

% --------------------------------------------------------------------
function varargout = opend_Callback(h, eventdata, handles, varargin)
%open saved table and data
uiload;    %prompt for selecting file
cla %clear preview plot
set(handles.savet,'Enable','on')    %turn on file, save table
set(handles.saved,'Enable','on')    %turn on file, save table and data
set(handles.newinitmenu,'Enable','on')  %turn on file, new initial conditions
handles.table=table;    %save loaded table to handles
handles.tables=0;   %there are no saved tables
handles.data=data;  %load data
handles.initcond=initcond;  %load initial conditions
guidata(gcbo,handles);
set(handles.preview,'Visible','off')
set(handles.frame1,'Visible','off')
set(handles.frame2,'Visible','off')
set(handles.frame9,'Visible','off')
set(handles.nmax,'Visible','off')
set(handles.nmaxl,'Visible','off')
set(handles.run,'Visible','off')
set(handles.center,'Visible','off')
set(handles.cxl,'Visible','off')
set(handles.cyl,'Visible','off')
set(handles.cx,'Visible','off')
set(handles.cy,'Visible','off')
set(handles.init,'Visible','off')
set(handles.initradio1,'Visible','off')
set(handles.initradio2,'Visible','off')
%set(handles.radiobutton9, 'Visible','off')
set(handles.inite3,'Visible','off')
set(handles.inite2,'Visible','off')
set(handles.initl3,'Visible','off')
set(handles.initl2,'Visible','off')
set(handles.inite1,'Visible','off')
set(handles.initl1,'Visible','off')
set(handles.initphase,'Visible','off')
set(handles.tablepopup,'Visible','off') 
set(handles.param1l,'Visible','off')
set(handles.param1e,'Visible','off')
set(handles.param1e2,'Visible','off')
set(handles.param2l,'Visible','off')
set(handles.param2e,'Visible','off')
set(handles.param2e2,'Visible','off')
set(handles.param3l,'Visible','off')
set(handles.param3e,'Visible','off')
set(handles.param3e2,'Visible','off')
set(handles.param4l,'Visible','off')
set(handles.param4e,'Visible','off')
set(handles.param4e2,'Visible','off')
set(handles.extraoptions,'Visible','off')
set(handles.extraoptions2,'Visible','off')
set(handles.add,'Visible','off')
set(handles.stop,'Visible','off')
set(handles.stopl,'Visible','off')
set(handles.analysisl,'Visible','on')
set(handles.datal,'Visible','on')
set(handles.datal,'Visible','on')
set(handles.moviel,'Visible','on')
set(handles.movie1,'Visible','on')
set(handles.movie2,'Visible','on')
set(handles.movieview,'Visible','on')
set(handles.moviesave1,'Visible','on')
set(handles.moviesave2,'Visible','on')
set(handles.moviebutton,'Visible','on')
set(handles.databox,'Visible','on')
set(handles.radio1,'Visible','on')
set(handles.radio2,'Visible','on')
set(handles.databutton,'Visible','on')
set(handles.plotsl,'Visible','on')
set(handles.analysis,'Visible','on')
set(handles.analysisbutton,'Visible','on')
set(handles.newtable,'Visible','on')
set(handles.initial,'Visible','on')
set(handles.more,'Visible','on')
set(handles.nmore,'Visible','on')
set(handles.frame3,'Visible','on')
set(handles.frame4,'Visible','on')
set(handles.frame5,'Visible','on')
set(handles.frame6,'Visible','on')
set(handles.text21,'Visible','off') %TEST
% --------------------------------------------------------------------
function varargout = savet_Callback(h, eventdata, handles, varargin)
%save current table
if handles.tables & handles.stable{size(handles.stable,1),4}~=handles.table{size(handles.table,1),4}  %is there a saved table and a new unsaved table
    table=[handles.stable;handles.table];   %combine unsaved and saved tables
else
    table=handles.table;    %store saved table into table
end
save(uiputfile,'table') %prompt for where to save table and save it there


% --------------------------------------------------------------------
function varargout = saved_Callback(h, eventdata, handles, varargin)
%save current table and data
data=handles.data;
table=handles.table;
initcond=handles.initcond;
save(uiputfile,'data','table','initcond')  %these variables store all info about table and data

% --------------------------------------------------------------------
function varargout = exit_Callback(h, eventdata, handles, varargin)
%file, close menu option
close

% --------------------------------------------------------------------
function varargout = fps_Callback(h, eventdata, handles, varargin)
%frame rate menu option
answer=inputdlg('Enter frame rate for movies.  (Default is 3.)','Frames per second');   %prompt for frame rate
handles.fps=answer{1};  %save input to handles.fps
guidata(gcbo,handles);

% --------------------------------------------------------------------
function varargout = about_Callback(h, eventdata, handles, varargin)
%about menu option
msgbox(char('Mathematical Billiards Version 2.0','','Updated by Samuel King, Caitlin Keady, Emily Joslin and Michael Vavala and advised by Mark Demers','Fairfield University Mathematics REU Summer 2016','Originally by Steven Lansel and advised by Mason Porter','Georgia Institute of Technology','School of Mathematics','REU/Vigre Program'),'About Billiards')    %about dialog box

% --------------------------------------------------------------------
function varargout = param_Callback(h, eventdata, handles, varargin)
%Called when a dimension is entered, if all dimensions for the table have
%been entered then the table is created and saved and a preview is
%generated, if not all dimensions have been entered nothing happens
%table creation functions have dimensions and the starting t value for the
%table passed in, they automatically save the table to global table
global table
%checks to see if all relevant dimensions have been entered
if (strcmp(get(handles.param1e,'Visible'),'off') | ~(strcmp(get(handles.param1e,'String'),'') | strcmp(get(handles.param1e,'String'),'Horizontal') | strcmp(get(handles.param1e,'String'),'Top'))) & (strcmp(get(handles.param2e,'Visible'),'off') | ~(strcmp(get(handles.param2e,'String'),'') | strcmp(get(handles.param2e,'String'),'Horizontal'))) & (strcmp(get(handles.param3e,'Visible'),'off') | ~(strcmp(get(handles.param3e,'String'),'') | strcmp(get(handles.param3e,'String'),'Height'))) & (strcmp(get(handles.param4e,'Visible'),'off') | ~(strcmp(get(handles.param4e,'String'),'') | strcmp(get(handles.param4e,'String'),'Top'))) & (strcmp(get(handles.param1e2,'Visible'),'off') | ~(strcmp(get(handles.param1e2,'String'),'') | strcmp(get(handles.param1e2,'String'),'Vertical') | strcmp(get(handles.param1e2,'String'),'Bottom'))) & (strcmp(get(handles.param2e2,'Visible'),'off') | ~(strcmp(get(handles.param2e2,'String'),'') | strcmp(get(handles.param2e2,'String'),'Vertical'))) & (strcmp(get(handles.param3e2,'Visible'),'off') | ~(strcmp(get(handles.param3e2,'String'),'') | strcmp(get(handles.param3e2,'String'),'Width'))) & (strcmp(get(handles.param4e2,'Visible'),'off') | ~(strcmp(get(handles.param4e2,'String'),'') | strcmp(get(handles.param4e2,'String'),'Bottom')))
    set(handles.savet,'Enable','on')    %enable file, save table
    set(handles.newinitmenu,'Enable','on')  %enable file, new initial conditions
    set(handles.initphase,'Enable','on')    %enable button for selecting initial conditions from phase space
    %create appropriate table based on dimensions
    switch get(handles.tablepopup,'Value')
    case 2  %circle
        if handles.tables  %whether combined with a saved table
            circle(str2num(get(handles.param1e,'String')),handles.to);  %if saved table make lowest t value for this new table be where the saved table leaves off
        else
            circle(str2num(get(handles.param1e,'String')),0);  %create table starting at t=0
        end
    case 3  %non-concentric circles
        if handles.tables
            nonConCircles(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),str2num(get(handles.param3e,'String')),handles.to);
        else
            nonConCircles(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),str2num(get(handles.param3e,'String')),0);
        end
    case 4  %ellipse
        if handles.tables
            ellipse(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),handles.to);
        else
            ellipse(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),0);
        end
    case 5  %limacon
        if handles.tables
            limacon(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),handles.to);
        else
            limacon(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),0);
        end   
        
     
        
	case 6  %Lemon billiard
		if handles.tables
			lemon(str2num(get(handles.param1e,'String')),handles.to);
		else
			lemon(str2num(get(handles.param1e,'String')),0);
		end
        
    case 7 %asym lemon billiard
        if handles.tables
            asymlemon(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),str2num(get(handles.param3e,'String')),handles.to);
        else
            asymlemon(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),str2num(get(handles.param3e,'String')),0);
        end    
    case 8  %moon billiard
        if handles.tables
            moon(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),str2num(get(handles.param3e,'String')),handles.to);
        else
            moon(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),str2num(get(handles.param3e,'String')),0);
        end  
    case 9  %mushroom
        if get(handles.extraoptions,'Value')==1    %if circular mushroom
            ry=str2num(get(handles.param1e,'String'));    %use rx for ry
        else    %if elliptical mushroom
            ry=str2num(get(handles.param1e2,'String'));    %use entered value for ry
        end            
        if handles.tables
            mushroom(str2num(get(handles.param1e,'String')),ry,str2num(get(handles.param2e,'String')),str2num(get(handles.param3e,'String')),str2num(get(handles.param3e2,'String')),str2num(get(handles.param4e,'String')),handles.to);
        else
            mushroom(str2num(get(handles.param1e,'String')),ry,str2num(get(handles.param2e,'String')),str2num(get(handles.param3e,'String')),str2num(get(handles.param3e2,'String')),str2num(get(handles.param4e,'String')),0);
        end
    case 10  %doublemushroom
        if get(handles.extraoptions,'Value')==1    %if circular double mushroom
            rx1=str2num(get(handles.param1e,'String'));  
            rx2=str2num(get(handles.param1e2,'String'));
            ry1=rx1;    %use rx1 for ry1
            ry2=rx2;   %use rx2 for ry2
            sh=str2num(get(handles.param2e,'String'));   
            sw=str2num(get(handles.param3e,'String'));  
        else    %if elliptical double mushroom
            rx1=str2num(get(handles.param1e,'String'));  
            rx2=str2num(get(handles.param2e,'String'));
            ry1=str2num(get(handles.param1e2,'String'));    %use entered value for ry1
            ry2=str2num(get(handles.param2e2,'String'));    %use entered value for ry2
            sh=str2num(get(handles.param3e,'String'));   
            sw=str2num(get(handles.param3e2,'String'));            
        end            
        
        wr1 = str2num(get(handles.param4e,'String'));
        wr2 = str2num(get(handles.param4e2,'String'));
        
        if handles.tables
            doublemushroom(rx1,ry1,rx2,ry2,sh,sw,wr1,wr2,handles.to);
        else
            doublemushroom(rx1,ry1,rx2,ry2,sh,sw,wr1,wr2,0);
        end
    case 11  %rounded mushroom
        if get(handles.extraoptions,'Value')==1    %if circular mushroom
            ry=str2num(get(handles.param1e,'String'));    %use rx for ry
        else    %if elliptical mushroom
            ry=str2num(get(handles.param1e2,'String'));    %use entered value for ry
        end            
        if handles.tables
            roundedmushroom(str2num(get(handles.param1e,'String')),ry,str2num(get(handles.param3e,'String')),str2num(get(handles.param3e2,'String')),str2num(get(handles.param4e,'String')),str2num(get(handles.param2e,'String')),handles.to);
        else
            roundedmushroom(str2num(get(handles.param1e,'String')),ry,str2num(get(handles.param3e,'String')),str2num(get(handles.param3e2,'String')),str2num(get(handles.param4e,'String')),str2num(get(handles.param2e,'String')),0);
        end
    case 12  %stadium
		if get(handles.extraoptions2,'Value')==1 %circular stadium
			ry = str2num(get(handles.param3e,'String'));
		else
			ry = str2num(get(handles.param4e,'String'));
		end
		
        if handles.tables
            stadium(get(handles.extraoptions,'Value'),str2num(get(handles.param2e,'String')),str2num(get(handles.param3e,'String')),ry,handles.to);
        else
            stadium(get(handles.extraoptions,'Value'),str2num(get(handles.param2e,'String')),str2num(get(handles.param3e,'String')),ry,0);
        end
    case 13  %polygon
        if handles.tables
            polygon(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),handles.to);
        else
            polygon(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),0);
        end
    case 14  %rectangle
        if handles.tables
            rectang(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),handles.to);
        else
            rectang(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),0);
        end
    case 15  %sinai
        if handles.tables
            sinai(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),handles.to);
        else
            sinai(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),0);
        end
	case 16  %Kaplan billiard
		if handles.tables
			kaplan(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),str2num(get(handles.param3e,'String')),get(handles.extraoptions,'Value'),handles.to);
		else
			kaplan(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')),str2num(get(handles.param3e,'String')),get(handles.extraoptions,'Value'),0);
		end
    case 17  %Squircle Cell
        if handles.tables
            squirclecell(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')), str2num(get(handles.param3e,'String')), str2num(get(handles.param4e,'String')),handles.to);
        else
            squirclecell(str2num(get(handles.param1e,'String')),str2num(get(handles.param2e,'String')), str2num(get(handles.param3e,'String')), str2num(get(handles.param4e,'String')), 0);
        end
    end
    
    handles.table=table;
    
    %move center of table if desired
    if str2num(get(handles.cx,'String'))~=0
        for n=1:size(handles.table,1)   %loop through each piece of the table
            table{n,1}=inline([char(handles.table{n,1}),'+',get(handles.cx,'String')]);    %add desired amount to each x(t) to shift table so the center is at the desired location
        end
    end
    if str2num(get(handles.cy,'String'))~=0
        for n=1:size(handles.table,1)   %loop through each piece of the table
            table{n,2}=inline([char(handles.table{n,2}),'+',get(handles.cy,'String')]);    %add desired amount to each x(t) to shift table so the center is at the desired location
        end
    end
    handles.table=table;    %saves changes to table if the center was moved
    guidata(gcbo,handles);
    
    if handles.tables   %if saved table present
        %draw saved table
        for n=1:size(handles.stable,1)
            ezplot(handles.stable{n,1},handles.stable{n,2},[handles.stable{n,3},handles.stable{n,4}])   %draw each piece of the table
            hold on
            if handles.stable{n,5}==1  %check for horizontal and vertical pieces
                line([handles.stable{n,1}(handles.stable{n,3}),handles.stable{n,1}(handles.stable{n,4})],[handles.stable{n,2}(handles.stable{n,3}),handles.stable{n,2}(handles.stable{n,4})])   %darken horizontal and vertical lines
            end
        end
    end
    for n=1:size(table,1)
        ezplot(table{n,1},table{n,2},[table{n,3},table{n,4}])   %draw each piece of the table
        hold on
        if table{n,5}==1  %check for horizontal and vertical pieces
            line([handles.table{n,1}(handles.table{n,3}),handles.table{n,1}(handles.table{n,4})],[handles.table{n,2}(handles.table{n,3}),handles.table{n,2}(handles.table{n,4})])   %darken horizontal and vertical lines
        end
    end
    title('Preview')
    hold off
    set(handles.preview,'Visible','on')
    set(handles.add,'Visible','on')   %turn on button for adding another table
else    %if not all parameters for table have been entered
    if ~handles.tables  %if saved tables are present
        set(handles.savet,'Enable','off')   %disable saved table
        set(handles.newinitmenu,'Enable','off') %disable file, new initial conditions
        set(handles.initphase,'Enable','off')   %ghost button for selecting initial conditions from phase space
        set(handles.preview,'Visible','off')
        cla %clear preview
    end
end

% --------------------------------------------------------------------
function varargout = extraoptions_Callback(h, eventdata, handles, varargin)
%called when extraoptions pulldown menu is changed, used to pick
%circular/elliptical mushrooms/double/rounded mushrooms and full/half/quarter stadiums
if get(handles.tablepopup,'Value')==8   %if mushroom
    set(handles.param3e2, 'Visible','on')
    set(handles.param3e2, 'String','Width')
    if get(handles.extraoptions,'Value')==1 %if circular mushroom
        set(handles.param1e2,'Visible','off')   %disable vertical radius
        if strcmp(get(handles.param1e,'String'),'Horizontal')   %if radius box says Horizontal
            set(handles.param1e,'String','')    %clear radius box
        end
    else    %if elliptical mushroom
        set(handles.param1e2,'Visible','on')    %enable vertical radius
        set(handles.param1e,'String','Horizontal')  %put word Horizontal in 1st radius box
        set(handles.param1e2,'String','Vertical')   %put word Vertical in 2nd radius box
    end
end
if get(handles.tablepopup,'Value')==9   %if double mushroom
    if get(handles.extraoptions,'Value')==1 %if circular double mushroom
        set(handles.param1e2,'Visible','on')
        set(handles.param2e2,'Visible','off')   %We just need a top and bottom radius
        set(handles.param3e2,'Visible','off')
        %if strcmp(get(handles.param1e2,'String'),'Vertical')   %if radius box says Vertical
            set(handles.param1e2,'String','Bottom')    %clear radius box
        %end
        %if strcmp(get(handles.param1e,'String'),'TopHor')   %if radius box says Horizontal
            set(handles.param1e,'String','Top')    %clear radius box
        %end
        if strcmp(get(handles.param2e,'String'),'Horizontal')%if radius box says Horizontal
            set(handles.param2e,'String','')          %clear radius box
        end
        if strcmp(get(handles.param3e,'String'),'Height')%if box says Height
            set(handles.param3e,'String','')          %clear box
        end
        set(handles.param1l,'String','Radii')
        set(handles.param2l,'String','Stem Height')
        set(handles.param3l,'String','Stem Width')
    else    %if elliptical double mushroom
        set(handles.param1e2,'Visible','on')    %enable top vertical radius
        set(handles.param2e2,'Visible','on')    %enable bottom vertical radius
        set(handles.param3e2,'Visible','on')    %enable extra box for stemwidth
        set(handles.param1e,'String','Horizontal')  %put word Horizontal in 1st radius box
        set(handles.param1e2,'String','Vertical')   %put word Vertical in 2nd radius box
        set(handles.param2e,'String','Horizontal') %put word Horizontal in 3rd radius box
        set(handles.param2e2,'String','Vertical') %put word Vertical in 5th radius box
        set(handles.param3e,'String','Height') %put word Height in box for stem height
        set(handles.param3e2,'String','Width') %put word Width in box for stem width
        set(handles.param1l,'String','Top Radii')
        set(handles.param2l,'String','Bottom Radii')
        set(handles.param3l,'String','Stem Size')
    end
end
if get(handles.tablepopup,'Value')==10   %if rounded mushroom
    if get(handles.extraoptions,'Value')==1 %if circular rounded mushroom
        set(handles.param1e2,'Visible','off')   %disable vertical radius
        if strcmp(get(handles.param1e,'String'),'Horizontal')   %if radius box says Horizontal
            set(handles.param1e,'String','')    %clear radius box
        end
    else    %if elliptical rounded mushroom
        set(handles.param1e2,'Visible','on')    %enable vertical radius
        set(handles.param1e,'String','Horizontal')  %put word Horizontal in 1st radius box
        set(handles.param1e2,'String','Vertical')   %put word Vertical in 2nd radius box
    end
    set(handles.param3e,'String','Height')
    set(handles.param3e2,'String','Width')
end
if get(handles.tablepopup,'Value')==11   %if stadium
    param_Callback(h, eventdata, handles, varargin)
end
if get(handles.tablepopup,'Value')==13   %if kaplan
    param_Callback(h, eventdata, handles, varargin)
end

% --------------------------------------------------------------------


function extraoptions2_Callback(h, eventdata, handles, varargin)
%called when extraoptions pulldown menu is changed, used to pick
%circular/elliptical stadiums
if get(handles.tablepopup,'Value')==11   %if stadium
	if get(handles.extraoptions2,'Value')==1 %circular stadium
		set(handles.param4e,'Visible','off')   %disable second radius
		set(handles.param4l,'Visible','off')   %disable second radius text label
		set(handles.param3l,'String','Radius')
	end
	if get(handles.extraoptions2,'Value')==2 %elliptical stadium
		set(handles.param3l,'String','Horizontal Radius')
		set(handles.param4l,'String','Vertical Radius')
		set(handles.param4l,'Visible','on')
		set(handles.param4e,'Visible','on')
	end
    param_Callback(h, eventdata, handles, varargin)
end


% --------------------------------------------------------------------
function varargout = tablepopup_Callback(h, eventdata, handles, varargin)
%called when the table pull down menu is changed to a new type of table
%this controls which parameters are visible and their labels
%clear all boxes for entering dimensions
set(handles.param1e,'String','')
set(handles.param1e2,'String','')
set(handles.param2e,'String','')
set(handles.param3e,'String','')
set(handles.param2e2,'String','')
set(handles.param3e2,'String','')
set(handles.param4e,'String','')
set(handles.param1e2,'Visible','off')
set(handles.param2e2,'Visible','off')
set(handles.param3e2,'Visible','off')
set(handles.param4e2,'Visible','off')
if ~handles.tables  %if no saved tables, turn off and clear preview
    set(handles.preview,'Visible','off')
    cla
end
    
switch get(handles.tablepopup,'Value')  %store labels for each dimension based on the type of table selected
case 2  %Circle
    set(handles.param1l,'String','Radius')
case 3 %Non-concentric Circles
    set(handles.param1l,'String','Outer Radius')
    set(handles.param2l,'String','Inner Radius')
    set(handles.param3l,'String','Vertical Shift')
case 4  %Ellipse
    set(handles.param1l,'String','Horizontal Axis')
    set(handles.param2l,'String','Vertical Axis')
case 5  %Limacon
    set(handles.param1l,'String','a')
    set(handles.param2l,'String','b')
case 6 %lemon billiard
	set(handles.param1l,'String','Delta')
    set(handles.param2l,'String','0 < Delta, Delta != 2')
case 7 %asym Lemon
    set(handles.param1l,'String','Larger Radius')
    set(handles.param2l,'String','Smaller Radius')
    set(handles.param3l,'String','Distance between centers')
case 8 %Moon
    set(handles.param1l,'String','Radius of Upper Circle')
    set(handles.param2l,'String','Radius of Lower Circle')
    set(handles.param3l,'String','Distance between centers')
case 9  %Mushroom
    set(handles.param1l,'String','Radius')
%    set(handles.param2l,'String','Height of stem')
%    set(handles.param3l,'String','Width of stem')
    set(handles.param2l,'String','Angle')
    set(handles.param3l,'String','Stem')
    set(handles.param3e,'String','Height')
    set(handles.param3e2,'String','Width')
    set(handles.param4l,'String','Ratio of left to right sides')
case 10 %Double Mushroom
    set(handles.param1l,'String','Radius')
    set(handles.param2l,'String','Height of stem')
    set(handles.param3l,'String','Width of stem')
    set(handles.param4l,'String','Ratio of left to right sides')
case 11 %rounded mushroom
    set(handles.param1l,'String','Radius')
    set(handles.param2l,'String','Quarter Circle Radius')
    set(handles.param3l,'String','Stem Size')
    set(handles.param4l,'String','Ratio of left to right sides')
    set(handles.param3e,'String','Height')
    set(handles.param3e2,'String','Width')
case 12  %Stadium
    set(handles.param2l,'String','Length of line segments')
    set(handles.param3l,'String','Radius')
case 13  %Polygon
    set(handles.param1l,'String','Number of sides')
    set(handles.param2l,'String','Width of sides')
case 14  %Rectangle
    set(handles.param1l,'String','Length')
    set(handles.param2l,'String','Width')
case 15  %Sinai
    set(handles.param1l,'String','Width of square')
    set(handles.param2l,'String','Radius of circle')
case 16 %kaplan billiard
	set(handles.param1l,'String','Side Length')
	set(handles.param2l,'String','Height of semi-circle')
	set(handles.param3l,'String','Radius')
case 17  %Squircle Cell
    set(handles.text21, 'String', 'Convex: (Square)0-Deleta-1(Circle)')
    set(handles.param1l,'String','Width of square')
    set(handles.param2l,'String','Radius of outer circles')
    set(handles.param3l,'String','Inner radius')
    set(handles.param4l,'String','Squircle')
    set(handles.param4e,'String','Delta')
case 18 %Custom table
    drawtable(gcbo);    %launch drawtable program
    set(handles.Billiards,'Visible','off')  %hide billiards
end
set(handles.add,'Visible','off')
set(handles.param3l,'Visible','off')
set(handles.param3e,'Visible','off')
set(handles.param4l,'Visible','off')
set(handles.param4e,'Visible','off')
set(handles.param3e2,'Visible','off')
set(handles.param2e2,'Visible','off')
set(handles.param4e2,'Visible','off')
set(handles.extraoptions,'Visible','off')
set(handles.extraoptions2,'Visible','off')
set(handles.text21,'Visible','off') %TEST
if get(handles.tablepopup,'Value')==1 | get(handles.tablepopup,'Value')==16 %if selection is 'Select table' or 'Custom' do not display following objects
    set(handles.center,'Visible','off')
    set(handles.cxl,'Visible','off')
    set(handles.cyl,'Visible','off')
    set(handles.cx,'Visible','off')
    set(handles.cy,'Visible','off')
    set(handles.param1l,'Visible','off')
    set(handles.param1e,'Visible','off')
    set(handles.param2l,'Visible','off')
    set(handles.param2e,'Visible','off')
else    %if a pre-defined table is selected enable the following objects
    set(handles.center,'Visible','on')
    set(handles.cxl,'Visible','on')
    set(handles.cyl,'Visible','on')
    set(handles.cx,'Visible','on')
    set(handles.cy,'Visible','on')
    set(handles.param1l,'Visible','on')
    set(handles.param1e,'Visible','on')
    set(handles.param2l,'Visible','on')
    set(handles.param2e,'Visible','on')
end
switch get(handles.tablepopup,'Value')  %turn on the number of dimensions labels and inputs required for the table type
case 2  %circle
    set(handles.param2l,'Visible','off')
    set(handles.param2e,'Visible','off')
case 9 %mushroom
    set(handles.param3l,'Visible','on')
    set(handles.param3e,'Visible','on')
    set(handles.param4l,'Visible','on')
    set(handles.param4e,'Visible','on')
    set(handles.param3e2,'Visible','on')
    set(handles.param3e2,'String','Width')
    set(handles.extraoptions,'Visible','on')
    set(handles.extraoptions,'String',strvcat('Circular','Elliptical'))
    set(handles.extraoptions,'Value',1)
case 12  %stadium
    set(handles.extraoptions,'Visible','on')    %Full, half, and quarter stadium options
    set(handles.extraoptions,'String',strvcat('Full Stadium','Half Stadium','Quarter Stadium'))
    set(handles.extraoptions,'Value',1)
	set(handles.extraoptions2,'Visible','on')
	set(handles.extraoptions2,'Value',1)
	set(handles.param1e,'Visible','off')
	set(handles.param3e,'Visible','on')
	set(handles.param1l,'Visible','off')
	set(handles.param3l,'Visible','on')
case 10 %double mushroom
    set(handles.param1e2,'Visible','on')
    set(handles.param1e2,'String','Bottom')
    set(handles.param1e,'String','Top')
    set(handles.param3l,'Visible','on')
    set(handles.param3e,'Visible','on')
    %set(handles.param3e2,'Visible','on')
    %set(handles.param2e2,'Visible','on')
    set(handles.param4l,'Visible','on')
    set(handles.param4e,'Visible','on')
    set(handles.param4e2,'Visible','on')
    set(handles.param4e,'String','Top')
    set(handles.param4e2,'String','Bottom')
    set(handles.extraoptions,'Visible','on')
    set(handles.extraoptions,'String',strvcat('Circular','Elliptical'))
    set(handles.extraoptions,'Value',1)
case 3 %non-concentric circles
    set(handles.param3l,'Visible','on')
    set(handles.param3e,'Visible','on')
case 11 %rounded mushroom
    set(handles.param3l,'Visible','on')
    set(handles.param3e,'Visible','on')
    set(handles.param3e2,'Visible','on')
    set(handles.param4l,'Visible','on')
    set(handles.param4e,'Visible','on')
    set(handles.extraoptions,'Visible','on')
    set(handles.extraoptions,'String',strvcat('Circular','Elliptical'))
    set(handles.extraoptions,'Value',1)
case 16 %kaplan billiard
	set(handles.param3l,'Visible','on')
	set(handles.param3e,'Visible','on')
    set(handles.extraoptions,'Visible','on')
    set(handles.extraoptions,'String',strvcat('Focusing','Dispersive'))
    set(handles.extraoptions,'Value',1)
case 6 %lemon billiard
	set(handles.param2e,'Visible','off')
	%set(handles.param2l,'Visible','off')
case 7 %asym Lemon
    set(handles.param3l,'Visible','on')
    set(handles.param3e,'Visible','on')
case 8 %Moon
    set(handles.param3l,'Visible','on')
    set(handles.param3e,'Visible','on')
case 17 %Squircle Cell
    set(handles.param3l,'Visible','on')
    set(handles.param3e,'Visible','on')
    set(handles.param4l,'Visible','on')
    set(handles.param4e,'Visible','on')
    set(handles.text21,'Visible','on') %TEST
end
% --------------------------------------------------------------------
function varargout = custom_Callback(h, eventdata, handles, varargin)
%called by drawtable program when it is completed, table is passed in
handles.table=varargin{1};  %save passed in table
syms t  %set t as a symbolic variable
if handles.tables   %if saved table present, draw it
    for n=1:size(handles.stable,1)
        ezplot(handles.stable{n,1},handles.stable{n,2},[handles.stable{n,3},handles.stable{n,4}])   %draw each piece of the table
        hold on
        if handles.stable{n,5}==1  %check for horizontal and vertical pieces
            line([handles.stable{n,1}(handles.stable{n,3}),handles.stable{n,1}(handles.stable{n,4})],[handles.stable{n,2}(handles.stable{n,3}),handles.stable{n,2}(handles.stable{n,4})])   %darken horizontal and vertical lines
        end
    end
end
for n=1:size(handles.table,1)
    if handles.tables   %if there is a saved table, change all functions of the custom table so t for the custom table starts where the saved table leaves off
        handles.table{n,1}=inline(char(handles.table{n,1}(t-handles.to)),'t');   %make x(t) be x(t-to)
        handles.table{n,2}=inline(char(handles.table{n,2}(t-handles.to)),'t');   %make y(t) be x(t-to)
        handles.table{n,3}=handles.table{n,3}+handles.to;   %shift lower bound by to
        handles.table{n,4}=handles.table{n,4}+handles.to;   %shift upper bound by to
    end
    ezplot(handles.table{n,1},handles.table{n,2},[handles.table{n,3},handles.table{n,4}])   %draw each piece of the table
    hold on
    if handles.table{n,5}==1  %check for horizontal and vertical pieces
        line([handles.table{n,1}(handles.table{n,3}),handles.table{n,1}(handles.table{n,4})],[handles.table{n,2}(handles.table{n,3}),handles.table{n,2}(handles.table{n,4})])   %darken horizontal and vertical lines
    end
end
guidata(billiards,handles);
title('Preview')
hold off
set(handles.preview,'Visible','on')
set(handles.add,'Visible','on') %enable button for adding a table
set(handles.Billiards,'Visible','on')   %turn on billiards GUI
set(handles.savet,'Enable','on')    %enable file, save table
set(handles.newinitmenu,'Enable','on')  %enable file, new initial conditions
set(handles.initphase,'Enable','on')    %enable selecting initial conditions from phase space

% --------------------------------------------------------------------
function varargout = add_Callback(h, eventdata, handles, varargin)
%called when add table button is pressed
if handles.tables   %if there already is a saved table
    handles.stable=[handles.stable;handles.table]  %merge saved table and current table and store them as a saved table
else
    handles.stable=handles.table;   %save current table
end
handles.tables=1;   %now a saved table is present
handles.to=handles.table{end,4};    %upper bound for t for this table, used as lower bound for any new table created to go over this one
guidata(gcbo,handles);
%Reset for entering new table
set(handles.tablepopup,'Value',1)
set(handles.param1e,'Visible','off')
set(handles.param1e2,'Visible','off')
set(handles.param2e,'Visible','off')
set(handles.param3e,'Visible','off')
set(handles.param3e2,'Visible','off')
set(handles.param2e2,'Visible','off')
set(handles.param4e,'Visible','off')
set(handles.param4e2,'Visible','off')
set(handles.param1l,'Visible','off')
set(handles.param2l,'Visible','off')
set(handles.param3l,'Visible','off')
set(handles.param4l,'Visible','off')
set(handles.center,'Visible','off')
set(handles.cxl,'Visible','off')
set(handles.cyl,'Visible','off')
set(handles.cx,'Visible','off')
set(handles.cy,'Visible','off')
set(handles.add,'Visible','off')


% --------------------------------------------------------------------
function varargout = run_Callback(h, eventdata, handles, varargin)
%called when run button is pressed for simulations
global xo   %x-coordinate of last intersection
global yo   %y-coordiante of last intersection
global ao   %horizontal angle of last intersection
global nmax %maximum number of iterations
global table
global t
syms t  %make t a symbolic variable
%set initial values for x, y, and angle
if get(handles.initradio1,'Value')==1   %if initial conditions are entered with x/y
    xo=str2num(get(handles.inite1,'String'));   %get xo from entered initial conditions
    yo=str2num(get(handles.inite2,'String'));   %get yo from entered initial conditions
    ao=str2num(get(handles.inite3,'String'));   %get angle from entered intiial conditions

    handles.initcond{1}=[xo,yo,ao]; %save initial conditions for later use

% TODO: else if for t and incident
else    %initial conditions are entered with t and incident angle
    % temporary for testing generation
    if get(handles.inite1, 'String') == 'generate'
        % phase space bounds
        %axis([handles.table{1,3},handles.table{size(handles.table,1),4},-pi/2,pi/2])
        
        n_ts = 2 % this will become user input
        n_iangles = 3; % this will become user input

        % TODO: 3d array for f(T^k(t_ij, a_ij)) stuff

        % TODO (?): billiard table is equivilent to trajectories on a certain topology?

        % generating t values between to and tmax
        % we generate one additional value (an endpoint) and then remove it
        % since the first t value is equivalent topologically to the last one, because
        % t is arc length around the boundary.
        ts = linspace(handles.table{1, 3}, handles.table{size(handles.table, 1), 4}, n_ts + 1);
        ts = ts(1:end - 1);

        % for generating angles, we remove BOTH endpoints, because an outgoing angle of
        % +/- pi/2 would be tangent to the boundary, and the trajectory would shoot outside
        % of the table.
        % first, figure out dphi (delta-phi), the length that each phi point will cover
        % out of the (-pi/2, pi/2) interval
        dphi = pi / (n_iangles);
        % then generate values between -pi/2 + dphi/2 and pi/2 - dphi/2. this ensures that
        % 1) the endpoints of +/- pi/2 arent included, and 2) that each phi/iangle value 
        % is a midpoint value
        iangles = linspace(-pi/2 + dphi/2, pi/2 - dphi/2, n_iangles);
        % numpy's linspace function is much better

        [Ts, Iangles] = meshgrid(ts, iangles);
        Ts = Ts(:)
        Iangles = Iangles(:);

        for i = 1:size(Ts, 1)
            to = Ts(i);
            iangle = Iangles(i);

            xo=table{piece(table, to),1}(to);    %get xo from entered value of to
            yo=table{piece(table, to),2}(to);    %get yo from entered value of to

            x=eval(char(table{piece(table, to),1})); %symbolic expression for x(t) for relevant piece
            y=eval(char(table{piece(table, to),2})); %symbolic expression for y(t) for relevant piece
            at=atan2(subs(diff(y,t),to),subs(diff(x,t),to));  %tangent angle to the curve at the selected point
            at=double(at);
            ao=mod(iangle-pi/2+at,2*pi); %calculation of horizontal angle using selected incident angle and tangent angle at the point 
            if (ao>pi)   %make angle between -pi and pi if not
                ao=ao-2*pi;
            end

            handles.initcond{i} = [xo, yo, ao, to, iangle];
        end

    else
        to=str2num(get(handles.inite1,'String'));    %entered initial t value
        iangle=str2num(get(handles.inite3,'String'));    %entered initial incident angle
        
        xo=table{piece(to),1}(to);    %get xo from entered value of to
        yo=table{piece(to),2}(to);    %get yo from entered value of to
        x=eval(char(table{piece(to),1})); %symbolic expression for x(t) for relevant piece
        y=eval(char(table{piece(to),2})); %symbolic expression for y(t) for relevant piece
        at=atan2(subs(diff(y,t),to),subs(diff(x,t),to));  %tangent angle to the curve at the selected point
        ao=mod(iangle-pi/2+at,2*pi); %calculation of horizontal angle using selected incident angle and tangent angle at the point 
        if ao>pi   %make angle between -pi and pi if not
            ao=ao-2*pi;
        end
    end
end
   
nmax=str2num(get(handles.nmax,'String'));   %get max number of iterations from entered number
if handles.tables   %if saved table is present
    handles.table=[handles.stable;handles.table];   %merge saved and current tables
    handles.tables=0;   %no saved tables present now
end
table=handles.table;
cla %clear preview
if strcmp(get(handles.tablepopup,'Visible'),'on')   %if new table was created reset data and initial conditions
    handles.data={};
    handles.initcond={};
end

set(handles.preview,'Visible','off')
set(handles.frame1,'Visible','off')
set(handles.frame2,'Visible','off')
set(handles.frame9,'Visible','off')
set(handles.nmax,'Visible','off')
set(handles.nmaxl,'Visible','off')
set(handles.run,'Visible','off')
set(handles.center,'Visible','off')
set(handles.cxl,'Visible','off')
set(handles.cyl,'Visible','off')
set(handles.cx,'Visible','off')
set(handles.cy,'Visible','off')
set(handles.init,'Visible','off')
set(handles.initradio1,'Visible','off')
set(handles.initradio2,'Visible','off')
%set(handles.radiobutton9,'Visible','off')
set(handles.inite3,'Visible','off')
set(handles.inite2,'Visible','off')
set(handles.initl3,'Visible','off')
set(handles.initl2,'Visible','off')
set(handles.inite1,'Visible','off')
set(handles.initl1,'Visible','off')
set(handles.initphase,'Visible','off')
set(handles.tablepopup,'Visible','off') 
set(handles.param1l,'Visible','off')
set(handles.param1e,'Visible','off')
set(handles.param1e2,'Visible','off')
set(handles.param2l,'Visible','off')
set(handles.param2e,'Visible','off')
set(handles.param3l,'Visible','off')
set(handles.param3e,'Visible','off')
set(handles.param4l,'Visible','off')
set(handles.param4e,'Visible','off')
set(handles.param4e2,'Visible','off')
set(handles.param3e2,'Visible','off')
set(handles.param2e2,'Visible','off')
set(handles.extraoptions,'Visible','off')
set(handles.extraoptions2,'Visible','off')
set(handles.add,'Visible','off')
set(handles.text21,'Visible','off') %TEST

set(handles.stop,'Visible','on')    %turn on cancel button to stop iterations
set(handles.stopl,'Visible','on')   %turn on label for cancel button
set(handles.stopl,'String',['0/',num2str(nmax),' iterations completed'])    %set label for # iterations completed
drawnow %force Matlab to update the GUI display
handles.initcond{end+1}=[xo,yo,ao]; %save initial conditions for later use
guidata(gcbo,handles);

% FOR LOOP START (?)
condit_n = 1;
max_condits = size(handles.initcond, 2);
for initcondi = handles.initcond
    initcondi = initcondi{1}
    xo = initcondi(1);
    yo = initcondi(2);
    ao = initcondi(3);

    %d is initl3 of tangent line for each piece (d is a vector of functions of t)
    deriv=sym(zeros(size(table,1),1));
    for m=1:size(table,1)
        x=eval(char(table{m,1}));   %symbolic function for x(t)
        y=eval(char(table{m,2}));   %symbolic function for y(t)
        deriv(m,1)=atan(diff(y,t)/diff(x,t));
    end
    deriv
    data=zeros(nmax,4); %allocate space for all data
    n=1    %n is current iteration being calculated
    iterate %calculates the 1st iteration based upon the initial conditions
    disp('here')
    set(handles.stopl,'String',[num2str(n),'/',num2str(nmax),' iterations completed, ',num2str(condit_n),'/',num2str(max_condits),' conditions'])    %label for number of iterations completed
    set(handles.stopl,'Visible','on')   %display cancel label
    drawnow
    handles.done=0; %whether the calculations are done or not, changed by the cancel button to 1
    guidata(gcbo,handles);
    global derivComp    %table of components needed for derivative of the billiard map
    derivComp=zeros(nmax,4);   

    while n<=nmax && ~handles.done   %while we have not completed enough iterations and still not done
        derivComp(n,1)=xo;    %x, y, pieces and angular components used in the derivative function
        derivComp(n,2)=yo;
        derivComp(n,3)=data(n,3);
        derivComp(n,4)=data(n,4);

        set(handles.stopl,'String',[num2str(n),'/',num2str(nmax),' iterations completed'])  %update display with number of iterations completed
        n=n+1;
        drawnow %force Matlab to update the GUI display
        handles=guidata(gcbo);
        xo=table{data(n-1,4),1}(data(n-1,1));  %x-value of last intersection
        yo=table{data(n-1,4),2}(data(n-1,1));  %y-value of last intersection
        ao=data(n-1,2); %horizontal angle of last intersection

        iterate
        % try
        %     iterate %find the location and angle of the next collision
        % catch   %if error in iterate then run the following:
        %     'iterate error' %error message
        %     handles.done=1;   %prevents further calculations due to error
        % end
    end
    data=data(1:n,:);   %delete the rows of data that were not calculated
    handles.data{end+1}=data;   %add data that was just calculated to new cell array element at end of handles.data
    guidata(gcbo,handles);
end

set(handles.stop,'Visible','off')
set(handles.stopl,'Visible','off')
set(handles.frame3,'Visible','on')
set(handles.frame4,'Visible','on')
set(handles.frame5,'Visible','on')
set(handles.frame6,'Visible','on')
set(handles.saved,'Enable','on')
set(handles.analysisl,'Visible','on')
set(handles.datal,'Visible','on')
set(handles.moviel,'Visible','on')
set(handles.movie1,'Visible','on')
set(handles.movie2,'Visible','on')
set(handles.movieview,'Visible','on')
set(handles.moviesave1,'Visible','on')
set(handles.moviesave2,'Visible','on')
set(handles.moviebutton,'Visible','on')
set(handles.radio1,'Visible','on')
set(handles.radio2,'Visible','on')
set(handles.databutton,'Visible','on')
set(handles.plotsl,'Visible','on')
set(handles.analysisbutton,'Visible','on')
set(handles.newtable,'Visible','on')
set(handles.initial,'Visible','on')
set(handles.more,'Visible','on')
set(handles.nmore,'Visible','on')
set(handles.analysis,'Visible','on')
set(handles.databox,'Visible','on')

% --------------------------------------------------------------------
function varargout = stop_Callback(h, eventdata, handles, varargin)
%called when the stop button is pressed during calculations
handles.done=1; %stops further calculations after current calculation is completed
guidata(billiards,handles);

% --------------------------------------------------------------------
function varargout = analysisbutton_Callback(h, eventdata, handles, varargin)
%creates analysis plots
color='rkbgymcrkbgymcrkbgymcrkbgymc'; %order of colors for drawing plots, each initial condition gets a different color
global derivComp
global nmax
%if options 1 or 2 are selected draw the table
if get(handles.analysis,'Value')<=2
    figure    
    %draw table
    for n=1:size(handles.table,1)
        ezplot(handles.table{n,1},handles.table{n,2},[handles.table{n,3},handles.table{n,4}])   %draw each piece of the table
        hold on
        if handles.table{n,5}==1  %check for horizontal and vertical pieces
            line([handles.table{n,1}(handles.table{n,3}),handles.table{n,1}(handles.table{n,4})],[handles.table{n,2}(handles.table{n,3}),handles.table{n,2}(handles.table{n,4})])   %darken horizontal and vertical lines
        end
    end
    %place text labels on plot describing value of t at intersection of
    %pieces (t=2 is such a label)
    text(handles.table{1,1}(handles.table{1,3}),handles.table{1,2}(handles.table{1,3}),['s=',num2str(handles.table{1,3})],'VerticalAlignment','top')  %put label for starting point
    for n=1:size(handles.table,1)
        text(handles.table{n,1}(handles.table{n,4}),handles.table{n,2}(handles.table{n,4}),['s=',num2str(handles.table{n,4})],'VerticalAlignment','bottom')   %create text labels for s
    end
    
    %now draw trajectory lines if option 2 is selected
    if get(handles.analysis,'Value')==2
        for k=1:size(handles.data,2)    %loop through all data sets for each initial condition
            data=handles.data{k};   %store current data set to data
            line([handles.initcond{k}(1),handles.table{data(1,4),1}(data(1,1))],[handles.initcond{k}(2),handles.table{data(1,4),2}(data(1,1))],'color',color(k))  %draw line from initial condition to 1st intersection, in appropriate color
            for n=2:size(data,1)
                line([handles.table{data(n-1,4),1}(data(n-1,1)),handles.table{data(n,4),1}(data(n,1))],[handles.table{data(n-1,4),2}(data(n-1,1)),handles.table{data(n,4),2}(data(n,1))],'color',color(k))  %draw line between successive intersections, in appropriate color
            end
        end
    end
    title('Configuration Space')
end
switch get(handles.analysis,'Value')    %check which type of plot is desired
case 3  %graph of Lyapunov Exponent for Different Billiard domains
    raw=0;
    switch get(handles.tablepopup,'Value')  %check which billiard domain is being used
        case 2  %if the table is a circle run circlelyap
            r=str2num(get(handles.param1e,'String'));
            circlelyap(r,derivComp,nmax,raw)
        case 3 %the lyap function for non concentric circles does not exist
            rx1=str2num(get(handles.param1e,'String'));
            rx2=str2num(get(handles.param2e,'String'));
            nonconcirclyap(rx1,rx2,derivComp,nmax,raw)
        case 4  %if the table is an ellipse run ellipselyap
            rx=str2num(get(handles.param1e,'String'));
            ry=str2num(get(handles.param2e,'String'));
            cx=str2num(get(handles.cx,'String'));
            cy=str2num(get(handles.cy,'String'));
            ellipselyap(rx,ry,cx,cy,derivComp,nmax,raw)
        case 5 %the lyap function for limacon does not exist
            msgbox(char('The Lyapunov Exponent Function for this domain does not exist.'))
        case 6 %if the table is a lemon run lemonlyap
            delta=str2num(get(handles.param1e,'String'));
            lemonlyap(delta,derivComp,nmax,raw)
        case 7 %asym lemon
            rx1=str2num(get(handles.param1e,'String'));
            rx2=str2num(get(handles.param2e,'String'));
            asymlemonlyap(rx1,rx2,derivComp,nmax,raw)        
     
        
        case 9   %if the table is a mushroom then run mushroomlyap
            rx=str2num(get(handles.param1e,'String'));
            circ=get(handles.extraoptions,'Value');
            if circ==1    %if circular mushroom
                ry=rx;    %use rx for ry
            else    %if elliptical mushroom
                ry=str2num(get(handles.param1e2,'String'));    %use entered value for ry
            end     
            cx=str2num(get(handles.cx,'String'));
            cy=str2num(get(handles.cy,'String'));
            mushroomlyap(rx,ry,derivComp,nmax,circ,cx,cy,raw)
        case 10   %if the table is a double mushroom then run doubmushroomlyap
            rx1=str2num(get(handles.param1e,'String'));  
            ry1=str2num(get(handles.param1e2,'String')); 
            circ=get(handles.extraoptions, 'Value');  
            if circ==1    %if circular mushroom
                rx2=str2num(get(handles.param1e,'String'));
                ry2=rx2;    %use rx for ry
            else    %if elliptical mushroom
                rx2=str2num(get(handles.param1e2,'String'));
                ry2=str2num(get(handles.param2e2,'String'));    %use entered value for ry
            end     
            cx=str2num(get(handles.cx,'String')); 
            cy=str2num(get(handles.cy,'String'));
            doubmushroomlyap(rx1,ry1,rx2,ry2,cx,cy,derivComp,nmax,circ,raw)
        case 11 %if the billiard table is rounded mushroom run roundedmushroomlyap
            circ=get(handles.extraoptions,'Value');
            rx=str2num(get(handles.param1e,'String'));
            if circ==1    %if circular mushroom
                ry=rx;    %use rx for ry
            else    %if elliptical mushroom
                ry=str2num(get(handles.param1e2,'String'));    %use entered value for ry
            end
            cx=str2num(get(handles.cx,'String')); 
            cy=str2num(get(handles.cy,'String'));
            roundedmushroomlyap(rx,ry,derivComp,nmax,circ,cx,cy,raw)
        case 12  %if the billiard table is a stadium then run stadiumlyap
            type=get(handles.extraoptions,'Value');
            circ=get(handles.extraoptions2,'Value');
            rx=str2num(get(handles.param3e,'String'));
            if circ==1    %if circular mushroom
                ry=rx;    %use rx for ry
            else    %if elliptical mushroom
                ry=str2num(get(handles.param4e,'String'));    %use entered value for ry
            end    
            cx=str2num(get(handles.cx,'String'));
            cy=str2num(get(handles.cy,'String'));
            stadiumlyap(type,circ,rx,ry,derivComp,nmax,cx,cy,raw)
        case 13 %for any polygon domain
            msgbox(char('The Lyapunov Exponent for this domain is zero.'))
        case 14 %for any rectangle domain
            msgbox(char('The Lyapunov Exponent for this domain is zero.'))
        case 15 %run sinailyap if the domain is sinai
            r=str2num(get(handles.param2e,'String'));
            sinailyap(r,derivComp,nmax,raw)
        case 16 %run kaplanlyap if the domain is kaplan
            r=str2num(get(handles.param3e,'String'));
            option=get(handles.extraoptions,'Value');
            kaplanlyap(r,option,derivComp,nmax,raw)
        case 17 %run squirclecelllyap  if the domain is squirclecell 
            r=str2num(get(handles.param2e,'String'));
            rho = str2num(get(handles.param3e,'String'));
            squirclecelllyap(r,rho,derivComp,nmax,raw)
       
    end
case 4  %phase space:  s vs incident angle
    figure
    for k=1:size(handles.data,2)    %loop through all data sets
        plot(handles.data{k}(:,1),handles.data{k}(:,3),['.',color(k)])  %plot '.' at each point with t-value on the horizontal and incident angle on the vertical, using the approrpriate color
        hold on
    end
    axis([handles.table{1,3},handles.table{size(handles.table,1),4},-pi/2,pi/2])    %set window to outline phase space
    for n=1:size(handles.table,1)-1
        line([handles.table{n,4},handles.table{n,4}],[-pi/2,pi/2])  %draw vertical lines to distinguish different pieces
    end
    xlabel('s')
    ylabel('incident angle')
    title('Phase Space: arc length (s) vs incident angle')
    switch size(handles.data,2) %number of data sets
    %create a legend to show which color is which initial conditions
    case 2
        legend('Initial Conditions 1','Initial Conditions 2')
    case 3
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3')
    case 4
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3','Initial Conditions 4')
    case 5
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3','Initial Conditions 4','Initial Conditions 5')
    case 6
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3','Initial Conditions 4','Initial Conditions 5','Initial Conditions 6')
    end
case 5  %phase space:  s vs abs(incident angle)
    figure
    for k=1:size(handles.data,2)    %loop through all data sets
        plot(handles.data{k}(:,1),abs(handles.data{k}(:,3)),['.',color(k)])  %plot '.' at each point with t-value on the horizontal and incident angle on the vertical, using the approrpriate color
        hold on
    end
    axis([handles.table{1,3},handles.table{size(handles.table,1),4},0,pi/2])    %set window to outline phase space
    for n=1:size(handles.table,1)-1
        line([handles.table{n,4},handles.table{n,4}],[0,pi/2])  %draw vertical lines to distinguish different pieces
    end
    xlabel('s')
    ylabel('incident angle')
    title('Phase Space: arc length (s) vs abs(incident angle)')
    switch size(handles.data,2) %number of data sets
    %create a legend to show which color is which initial conditions
    case 2
        legend('Initial Conditions 1','Initial Conditions 2')
    case 3
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3')
    case 4
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3','Initial Conditions 4')
    case 5
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3','Initial Conditions 4','Initial Conditions 5')
    case 6
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3','Initial Conditions 4','Initial Conditions 5','Initial Conditions 6')
    end
case 6  %phase space:  s vs sin(incident) angle
    figure
    for k=1:size(handles.data,2)    %loop through all data sets
        plot(handles.data{k}(:,1),sin(handles.data{k}(:,3)),['.',color(k)])   %plot '.' at each point with t-value on the horizontal and sin(incident angle) on the vertical, using the approrpriate color
        hold on
    end
    axis([handles.table{1,3},handles.table{size(handles.table,1),4},-1,1])  %set window to outline phase space
    for n=1:size(handles.table,1)-1
        line([handles.table{n,4},handles.table{n,4}],[-1,1])    %draw vertical lines to distinguish different pieces
    end
    xlabel('s')
    ylabel('sin(incident angle)')
    title('Phase Space: arc length (s) vs sin(incident angle)')
    switch size(handles.data,2) %number of data sets
    %create a legend to show which color is which initial conditions
    case 2
        legend('Initial Conditions 1','Initial Conditions 2')
    case 3
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3')
    case 4
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3','Initial Conditions 4')
    case 5
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3','Initial Conditions 4','Initial Conditions 5')
    case 6
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3','Initial Conditions 4','Initial Conditions 5','Initial Conditions 6')
    end
case 7  %phase space:  s vs horizontal angle
    figure
    for k=1:size(handles.data,2)
        plot(handles.data{k}(:,1),handles.data{k}(:,2),['.',color(k)])  %plot '.' at each point with t-value on the horizontal and horizontal angle on the vertical, using the approrpriate color
        hold on
    end
    axis([handles.table{1,3},handles.table{size(handles.table,1),4},-pi,pi])    %set window to outline phase space
    for n=1:size(handles.table,1)-1
        line([handles.table{n,4},handles.table{n,4}],[-pi,pi])
    end
    xlabel('s')
    ylabel('horizontal angle')
    title('Phase Space: arc length (s) vs horizontal angle')
    switch size(handles.data,2) %number of data sets
    %create a legend to show which color is which initial conditions
    case 2
        legend('Initial Conditions 1','Initial Conditions 2')
    case 3
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3')
    case 4
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3','Initial Conditions 4')
    case 5
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3','Initial Conditions 4','Initial Conditions 5')
    case 6
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3','Initial Conditions 4','Initial Conditions 5','Initial Conditions 6')
    end
case 8  %phase space: incident vs horizontal angle
    figure
    for k=1:size(handles.data,2)
        plot(handles.data{k}(:,3),handles.data{k}(:,2),['.',color(k)])  %plot '.' at each point with incident angle on the horizontal and horizontal angle on the vertical, using the approrpriate color
        hold on
    end
    axis([-pi/2,pi/2,-pi,pi])   %set window to outline phase space
    xlabel('incident angle')
    ylabel('horizontal angle')
    title('Phase Space: incident angle vs horizontal angle')
    switch size(handles.data,2) %number of data sets
    %create a legend to show which color is which initial conditions
    case 2
        legend('Initial Conditions 1','Initial Conditions 2')
    case 3
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3')
    case 4
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3','Initial Conditions 4')
    case 5
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3','Initial Conditions 4','Initial Conditions 5')
    case 6
        legend('Initial Conditions 1','Initial Conditions 2','Initial Conditions 3','Initial Conditions 4','Initial Conditions 5','Initial Conditions 6')
    end
case 9  %histogram of incident angle
    for k=1:size(handles.data,2)    %loop through all data sets for each set of initial conditions
        figure
        hist(handles.data{k}(:,3))  %create histogram
        xlabel('incident angle')
        ylabel('number of times hit')
        title(['Histogram of Incident Angle for Initial Conditions ',num2str(k)])
    end
case 10  %histogram of horizontal angle
    for k=1:size(handles.data,2)    %loop through all data sets for each set of initial conditions
        figure
        hist(handles.data{k}(:,2))  %create histogram
        xlabel('horizontal angle')
        ylabel('number of times hit')
        title(['Histogram of Horizontal Angle for Initial Conditions ',num2str(k)])
    end
case 11  %histogram of distance between bounces
    for k=1:size(handles.data,2)    %loop through all data sets for each set of initial conditions
        figure
        temp=zeros(size(handles.data{k},1)-1,1);    %temp will be distance between each bounce
        for n=1:size(handles.data{k},1)-1
            temp(n,1)=sqrt((handles.table{handles.data{k}(n,4),1}(handles.data{k}(n,1))-handles.table{handles.data{k}(n+1,4),1}(handles.data{k}(n+1,1))).^2+(handles.table{handles.data{k}(n,4),2}(handles.data{k}(n,1))-handles.table{handles.data{k}(n+1,4),2}(handles.data{k}(n+1,1))).^2);  %calculate distance for each collision
        end
        hist(temp)  %create histogram
        xlabel('Distance')
        ylabel('number of times')
        title(['Histogram of Distance between bounces for Initial Conditions ',num2str(k)])
    end
case 12  %histogram of frequency of pieces hit
    for k=1:size(handles.data,2)
        figure
        hist(handles.data{k}(:,4))  %create histogram
        xlabel('pieces hit')
        ylabel('number of times hit')
        title(['Number of times each piece is hit for Initial Conditions ',num2str(k)])
    end
end

% --------------------------------------------------------------------
function varargout = radio1_Callback(h, eventdata, handles, varargin)
%turn radio button 2 off so both are not on
%controls if raw data should be saved or output to the command window
set(handles.radio2,'Value',0)


% --------------------------------------------------------------------
function varargout = radio2_Callback(h, eventdata, handles, varargin)
%turn radio button 1 off so both are not on
%controls if raw data should be saved or output to the command window
set(handles.radio1,'Value',0)


% --------------------------------------------------------------------
function varargout = databutton_Callback(h, eventdata, handles, varargin)
%exporting of raw data (left side of analysis options)
%if value of radio1 button is 1 then save data
%if value of radio2 button is 1 then send data to command window
data=handles.data;
table=handles.table;
global derivComp
global nmax
switch get(handles.databox,'Value') %choose which type of raw data to export based on selection in left menu
case 1  %Type of data:  Raw Data (t, horizontal, incident, piece)
    if get(handles.radio1,'Value')==1   %save data
        initcond=handles.initcond;
        save(uiputfile,'data','table','initcond')   %save prompt
    end
    if get(handles.radio2,'Value')==1   %export data to command window
        if size(data,2)==1  %if single initial conditions just display data
            disp(data{1})
        else
            for k=1:size(data,2)    %if multiple initial conditions display each with a header
                disp(['Initial Conditions ',num2str(k)])    %header for output
                disp(data{k})   %data for current initial conditions
            end
        end
    end
case 2  %type of data: positive lyapunov exponents
    raw=1;
    domain=get(handles.tablepopup,'Value');
    switch domain  %check which billiard domain is being used
        case 2  %if the table is a circle run circlelyap
            r=str2num(get(handles.param1e,'String'));
            limArr=circlelyap(r,derivComp,nmax,raw);
        case 3 %the lyap function for non concentric circles does not exist
            rx1=str2num(get(handles.param1e,'String'));
            rx2=str2num(get(handles.param2e,'String'));
            limArr=nonconcirclyap(rx1,rx2,derivComp,nmax,raw);
        case 4  %if the table is an ellipse run ellipselyap
            rx=str2num(get(handles.param1e,'String'));
            ry=str2num(get(handles.param2e,'String'));
            cx=str2num(get(handles.cx,'String'));
            cy=str2num(get(handles.cy,'String'));
            limArr=ellipselyap(rx,ry,cx,cy,derivComp,nmax,raw);
        case 5 %the lyap function for limacon does not exist
            msgbox(char('The Lyapunov Exponent Function for this domain does not exist.'))
        case 6 %if the table is a lemon run lemonlyap
            delta=str2num(get(handles.param1e,'String'));
            limArr=lemonlyap(delta,derivComp,nmax,raw);
        
        case 7 %asym lemon
            rx1=str2num(get(handles.param1e,'String'));
            rx2=str2num(get(handles.param2e,'String'));
            limArr=asymlemonlyap(rx1,rx2,derivComp,nmax,raw);        
        
        
        
        case 8   %if the table is a mushroom then run mushroomlyap
            rx=str2num(get(handles.param1e,'String'));
            circ=get(handles.extraoptions,'Value');
            if circ==1    %if circular mushroom
                ry=rx;    %use rx for ry
            else    %if elliptical mushroom
                ry=str2num(get(handles.param1e2,'String'));    %use entered value for ry
            end     
            cx=str2num(get(handles.cx,'String'));
            cy=str2num(get(handles.cy,'String'));
            limArr=mushroomlyap(rx,ry,derivComp,nmax,circ,cx,cy,raw);
        case 9   %if the table is a double mushroom then run doubmushroomlyap
            rx1=str2num(get(handles.param1e,'String'));  
            ry1=str2num(get(handles.param1e2,'String')); 
            circ=get(handles.extraoptions, 'Value');  
            if circ==1    %if circular mushroom
                rx2=str2num(get(handles.param1e,'String'));
                ry2=rx2;    %use rx for ry
            else    %if elliptical mushroom
                rx2=str2num(get(handles.param1e2,'String'));
                ry2=str2num(get(handles.param2e2,'String'));    %use entered value for ry
            end     
            cx=str2num(get(handles.cx,'String')); 
            cy=str2num(get(handles.cy,'String'));
            limArr=doubmushroomlyap(rx1,ry1,rx2,ry2,cx,cy,derivComp,nmax,circ,raw);
        case 10 %if the billiard table is rounded mushroom run roundedmushroomlyap
            circ=get(handles.extraoptions,'Value');
            rx=str2num(get(handles.param1e,'String'));
            if circ==1    %if circular mushroom
                ry=rx;    %use rx for ry
            else    %if elliptical mushroom
                ry=str2num(get(handles.param1e2,'String'));    %use entered value for ry
            end
            cx=str2num(get(handles.cx,'String')); 
            cy=str2num(get(handles.cy,'String'));
            limArr=roundedmushroomlyap(rx,ry,derivComp,nmax,circ,cx,cy,raw);
        case 11  %if the billiard table is a stadium then run stadiumlyap
            type=get(handles.extraoptions,'Value');
            circ=get(handles.extraoptions2,'Value');
            rx=str2num(get(handles.param3e,'String'));
            if circ==1    %if circular mushroom
                ry=rx;    %use rx for ry
            else    %if elliptical mushroom
                ry=str2num(get(handles.param4e,'String'));    %use entered value for ry
            end    
            cx=str2num(get(handles.cx,'String'));
            cy=str2num(get(handles.cy,'String'));
            limArr=stadiumlyap(type,circ,rx,ry,derivComp,nmax,cx,cy,raw);
        case 12 %for any polygon domain
            msgbox(char('The Lyapunov Exponent for this domain is zero.'))
        case 13 %for any rectangle domain
            msgbox(char('The Lyapunov Exponent for this domain is zero.'))
        case 14 %run sinailyap if the domain is sinai
            r=str2num(get(handles.param2e,'String'));
            limArr=sinailyap(r,derivComp,nmax,raw);
        case 15 %run kaplanlyap if the domain is kaplan
            r=str2num(get(handles.param3e,'String'));
            option=get(handles.extraoptions,'Value');
            limArr=kaplanlyap(r,option,derivComp,nmax,raw);
        case 16 %run squirclecelllyap if the domain is squircle cell
            r=str2num(get(handles.param2e,'String'));
            rho=str2num(get(handles.param3e,'String'));
            limArr=squirclecelllyap(r,rho, derivComp,nmax,raw);
    end
    if get(handles.radio1,'Value')==1 && domain~=5 && domain~=11 && domain~=12 %save data
        save(uiputfile,'limArr')  %save prompt
    end
    if get(handles.radio2,'Value')==1 && domain~=5 && domain~=11 && domain~=12 %export data to command window
        disp(limArr)
    end
case 3  %Type of data:  x and y
    for k=1:size(data,2)
        temp{k}=zeros(size(data,1),2);
        for n=1:size(data{k},1)
            temp{k}(n,:)=[table{data{k}(n,4),1}(data{k}(n,1)),table{data{k}(n,4),2}(data{k}(n,1))];   %creates x and y coordinates for each point using the appropriate piece function
        end
    end
        data=temp;
    if get(handles.radio1,'Value')==1   %save data
        save(uiputfile,'data','table')  %save prompt
    end
    if get(handles.radio2,'Value')==1   %export data to command window
        if size(data,2)==1  %if single initial conditions just display data
            disp(data{1})
        else
            for k=1:size(data,2)    %if multiple initial conditions display each with a header
                disp(['Initial Conditions ',num2str(k)])    %header for output
                disp(data{k})    %data for current initial conditions
            end
        end
    end
case 4  %Type of data:  Incident angle  (column 3 of data file)
    if get(handles.radio1,'Value')==1   %save data
        data=data(:,3)
        save(uiputfile,'data','table')  %save prompt
    end
    if get(handles.radio2,'Value')==1   %export data to command window
        if size(data,2)==1  %if single initial conditions just display data
            disp(data{1}(:,3))
        else
            for k=1:size(data,2)    %if multiple initial conditions display each with a header
                disp(['Initial Conditions ',num2str(k)])    %header for output
                disp(data{k}(:,3))  %data for current initial conditions
            end
        end
    end
case 5  %Type of data:  Horizontal angle  (column 2 of data file)
    if get(handles.radio1,'Value')==1   %save data
        data=data(:,2)
        save(uiputfile,'data','table')  %save prompt
    end
    if get(handles.radio2,'Value')==1   %export data to command window
        if size(data,2)==1  %if single initial conditions just display data
            disp(data{1}(:,2))
        else
            for k=1:size(data,2)    %if multiple initial conditions display each with a header
                disp(['Initial Conditions ',num2str(k)])    %header for output
                disp(data{k}(:,2))  %data for current initial conditions
            end
        end
    end
case 6  %Type of data:  Pieces hit  (column 4 of data file)
    if get(handles.radio1,'Value')==1   %save data
        data=data(:,4)
        save(uiputfile,'data','table')  %save prompt
    end
    if get(handles.radio2,'Value')==1   %export data to command window
        if size(data,2)==1  %if single initial conditions just display data
            disp(data{1}(:,4))
        else
            for k=1:size(data,2)    %if multiple initial conditions display each with a header
                disp(['Initial Conditions ',num2str(k)])    %header for output
                disp(data{k}(:,4))  %data for current initial conditions
            end
        end
    end
case 8  %Type of data:  Distance between bounces
    %calculate distance between each bounce
    for k=1:size(data,2)
        temp{k}=zeros(size(data{k},1)-1,1);
        for n=1:size(data{k},1)-1
            temp{k}(n,1)=sqrt((table{data{k}(n,4),1}(data{k}(n,1))-table{data{k}(n+1,4),1}(data{k}(n+1,1))).^2+(table{data{k}(n,4),2}(data{k}(n,1))-table{data{k}(n+1,4),2}(data{k}(n+1,1))).^2);   %Distance formula between successive bounces
        end
    end
        data=temp;
    if get(handles.radio1,'Value')==1   %save data
        save(uiputfile,'data','table')  %save prompt
    end
    if get(handles.radio2,'Value')==1   %export data to command window
        if size(data,2)==1  %if single initial conditions just display data
            disp(data{1})
        else
            for k=1:size(data,2)    %if multiple initial conditions display each with a header
                disp(['Initial Conditions ',num2str(k)])    %header for output
                disp(data{k})  %data for current initial conditions
            end
        end
    end
end


% --------------------------------------------------------------------
function varargout = initial_Callback(h, eventdata, handles, varargin)
%Enter new initial conditions for same table
set(handles.stop,'Visible','off')
set(handles.stopl,'Visible','off')
set(handles.initphase,'Enable','on')
set(handles.frame1,'Visible','off')
set(handles.tablepopup,'Visible','off') 
set(handles.param1l,'Visible','off')
set(handles.param1e,'Visible','off')
set(handles.param1e2,'Visible','off')
set(handles.param2l,'Visible','off')
set(handles.param2e,'Visible','off')
set(handles.param3l,'Visible','off')
set(handles.param3e,'Visible','off')
set(handles.param4l,'Visible','off')
set(handles.param4e,'Visible','off')
set(handles.param4e2,'Visible','off')
set(handles.param3e2,'Visible','off')
set(handles.param2e2,'Visible','off')
set(handles.extraoptions,'Visible','off')
set(handles.extraoptions2,'Visible','off')
set(handles.center,'Visible','off')
set(handles.cxl,'Visible','off')
set(handles.cyl,'Visible','off')
set(handles.cx,'Visible','off')
set(handles.cy,'Visible','off')
set(handles.add,'Visible','off')
set(handles.analysisl,'Visible','off')
set(handles.datal,'Visible','off')
set(handles.moviel,'Visible','off')
set(handles.movie1,'Visible','off')
set(handles.movie2,'Visible','off')
set(handles.movieview,'Visible','off')
set(handles.moviesave1,'Visible','off')
set(handles.moviesave2,'Visible','off')
set(handles.moviebutton,'Visible','off')
set(handles.databox,'Visible','off')
set(handles.radio1,'Visible','off')
set(handles.radio2,'Visible','off')
set(handles.databutton,'Visible','off')
set(handles.plotsl,'Visible','off')
set(handles.analysis,'Visible','off')
set(handles.analysisbutton,'Visible','off')
set(handles.newtable,'Visible','off')
set(handles.initial,'Visible','off')
set(handles.more,'Visible','off')
set(handles.nmore,'Visible','off')
set(handles.frame3,'Visible','off')
set(handles.frame4,'Visible','off')
set(handles.frame5,'Visible','off')
set(handles.frame6,'Visible','off')
set(handles.frame2,'Visible','on')
set(handles.frame9,'Visible','on')
set(handles.nmax,'String','')
set(handles.nmax,'Visible','on')
set(handles.nmaxl,'Visible','on')
set(handles.run,'Visible','on')
set(handles.init,'Visible','on')
set(handles.initradio1,'Visible','on')
set(handles.initradio2,'Visible','on')
%set(handles.radiobutton9,'Visible','on')
set(handles.text21,'Visible','off') %TEST
if get(handles.initradio1,'Value')+get(handles.initradio2,'Value')==1   %if either x,y or t coordinates are selected for entering initial conditions
    set(handles.inite3,'String','')
    set(handles.inite3,'Visible','on')
    set(handles.inite2,'String','')
    set(handles.initl3,'Visible','on')
    set(handles.inite1,'String','')
    set(handles.inite1,'Visible','on')
    set(handles.initl1,'Visible','on')
    % TODO: something here
    if get(handles.initradio2,'Value')==1   %if t method is selected
        set(handles.inite2,'Visible','off') %turn off 2nd parameter since it is not needed
        set(handles.initl2,'Visible','off')
        set(handles.initphase,'Visible','on')   %turn on selection from phase space button
    else    %if x/y method is selected
        set(handles.inite2,'Visible','on')  %turn on 2nd parameter
        set(handles.initl2,'Visible','on')
        set(handles.initphase,'Visible','off')  %turn off selection from phase space button
    end
end
%Generate table preview
for n=1:size(handles.table,1)
    ezplot(handles.table{n,1},handles.table{n,2},[handles.table{n,3},handles.table{n,4}])   %plot each segment of the table
    hold on
    if handles.table{n,5}==1  %check if piece is horizontal or vertical line
        line([handles.table{n,1}(handles.table{n,3}),handles.table{n,1}(handles.table{n,4})],[handles.table{n,2}(handles.table{n,3}),handles.table{n,2}(handles.table{n,4})])   %darken horizontal and vertical lines
    end
end
title('Preview')
hold off
set(handles.preview,'Visible','on')


% --------------------------------------------------------------------
function varargout = more_Callback(h, eventdata, handles, varargin)
%Perform more iterations for same table and initial conditions
set(handles.analysisl,'Visible','off')
set(handles.datal,'Visible','off')
set(handles.moviel,'Visible','off')
set(handles.movie1,'Visible','off')
set(handles.movie2,'Visible','off')
set(handles.movieview,'Visible','off')
set(handles.moviesave1,'Visible','off')
set(handles.moviesave2,'Visible','off')
set(handles.moviebutton,'Visible','off')
set(handles.databox,'Visible','off')
set(handles.radio1,'Visible','off')
set(handles.radio2,'Visible','off')
set(handles.databutton,'Visible','off')
set(handles.plotsl,'Visible','off')
set(handles.analysis,'Visible','off')
set(handles.analysisbutton,'Visible','off')
set(handles.newtable,'Visible','off')
set(handles.initial,'Visible','off')
set(handles.more,'Visible','off')
set(handles.nmore,'Visible','off')
set(handles.frame3,'Visible','off')
set(handles.frame4,'Visible','off')
set(handles.frame5,'Visible','off')
set(handles.frame6,'Visible','off')
set(handles.stop,'Visible','on')

global table
global t
global nmax
global xo
global yo
global ao
syms t  %makes t a symbolic variable
table=handles.table;
data=handles.data{end}; %load data for last initial conditions
n=size(data,1); %n is number of iterations already calculated (starts at last calculated iteration)
nmax=n+str2num(get(handles.nmore,'String'))-1;  %maximum number of iterations
data=[data;zeros(nmax-n,4)]; %allocate space for all data
%d is initl3 of tangent line for each piece (d is a vector of functions of t)
deriv=sym(zeros(size(table,1),1));
for m=1:size(table,1)
    x=eval(char(table{m,1}));   %symbolic function for x(t)
    y=eval(char(table{m,2}));   %symbolic function for y(t)
    deriv(m,1)=atan(diff(y,t)/diff(x,t));
end

%all of the following code is identical to code in run
set(handles.stopl,'String',[num2str(n),'/',num2str(nmax),' iterations completed'])    %label for number of iterations completed
set(handles.stopl,'Visible','on')   %display cancel label
drawnow
handles.done=0; %whether the calculations are done or not, changed by the cancel button to 1
guidata(gcbo,handles);
global derivComp    %table of components needed for derivative of the billiard map
while n<=nmax && ~handles.done   %while we have not completed enough iterations and still not done
    derivComp(n,1)=xo;    %x, y, pieces and angular components used in the derivative function
    derivComp(n,2)=yo;
    derivComp(n,3)=data(n,3);
    derivComp(n,4)=data(n,4);
    set(handles.stopl,'String',[num2str(n),'/',num2str(nmax),' iterations completed'])  %update display with number of iterations completed
    n=n+1;
    drawnow %force Matlab to update the GUI display
    handles=guidata(gcbo);
    xo=table{data(n-1,4),1}(data(n-1,1));  %x-value of last intersection
    yo=table{data(n-1,4),2}(data(n-1,1));  %y-value of last intersection
    ao=data(n-1,2); %horizontal angle of last intersection
    try
        iterate %find the location and angle of the next collision
    catch   %if error in iterate then run the following:
        'iterate error' %error message
        n=nmax+1;   %prevents further calculations due to error
    end    
end
data=data(1:n,:);   %delete the rows of data that were not calculated
handles.data{end}=data;   %add data that was just calculated to new cell array element at end of handles.data
guidata(gcbo,handles);
set(handles.stop,'Visible','off')
set(handles.stopl,'Visible','off')
set(handles.frame3,'Visible','on')
set(handles.frame4,'Visible','on')
set(handles.frame5,'Visible','on')
set(handles.frame6,'Visible','on')
set(handles.saved,'Enable','on')
set(handles.analysisl,'Visible','on')
set(handles.datal,'Visible','on')
set(handles.moviel,'Visible','on')
set(handles.movie1,'Visible','on')
set(handles.movie2,'Visible','on')
set(handles.movieview,'Visible','on')
set(handles.moviesave1,'Visible','on')
set(handles.moviesave2,'Visible','on')
set(handles.moviebutton,'Visible','on')
set(handles.radio1,'Visible','on')
set(handles.radio2,'Visible','on')
set(handles.databutton,'Visible','on')
set(handles.plotsl,'Visible','on')
set(handles.analysisbutton,'Visible','on')
set(handles.newtable,'Visible','on')
set(handles.initial,'Visible','on')
set(handles.more,'Visible','on')
set(handles.nmore,'Visible','on')
set(handles.analysis,'Visible','on')
set(handles.databox,'Visible','on')
% --------------------------------------------------------------------
function movieview_Callback(hObject, eventdata, handles)
%turn off other radio buttons if view button is pressed
set(handles.moviesave1,'Value',0)
set(handles.moviesave2,'Value',0)
% --------------------------------------------------------------------
function moviesave1_Callback(hObject, eventdata, handles)
%turn off other radio buttons if save button is pressed
set(handles.movieview,'Value',0)
set(handles.moviesave2,'Value',0)
% --------------------------------------------------------------------
function moviesave2_Callback(hObject, eventdata, handles)
%turn off other radio buttons if save as avi button is pressed
set(handles.movieview,'Value',0)
set(handles.moviesave1,'Value',0)
% --------------------------------------------------------------------
function moviebutton_Callback(hObject, eventdata, handles)
%Creates movie output when button is pressed
%Generating the movie (same whether you are viewing or saving the movie)
figure  %make new window to create move in
clear M %delete M file, M will be the movie file
%Configuration space movie  (when lines are drawn for the first time they
%   are red for emphasis and then drawn as black in the next frame)
if get(handles.movie1,'Value')==1 & get(handles.movie2,'Value')==0
    %draw table
    for n=1:size(handles.table,1)
        ezplot(handles.table{n,1},handles.table{n,2},[handles.table{n,3},handles.table{n,4}])   %plot each piece of the table
        hold on
        if handles.table{n,5}==1  %check if each piece is a horizontal or vertical line
            line([handles.table{n,1}(handles.table{n,3}),handles.table{n,1}(handles.table{n,4})],[handles.table{n,2}(handles.table{n,3}),handles.table{n,2}(handles.table{n,4})])   %darken horizontal and vertical lines
        end
    end
    title('Configuration Space')
    text(handles.table{1,1}(handles.table{1,3}),handles.table{1,2}(handles.table{1,3}),['t=',num2str(handles.table{1,3})],'VerticalAlignment','top')  %label for lowest t value
    for n=1:size(handles.table,1)
        text(handles.table{n,1}(handles.table{n,4}),handles.table{n,2}(handles.table{n,4}),['t=',num2str(handles.table{n,4})],'VerticalAlignment','bottom')   %labels for t values between pieces
    end
    k=size(handles.data,2); %set of last initial conditions, which will be the only set the movie will show
    data=handles.data{k};
    line([handles.initcond{k}(1),handles.table{data(1,4),1}(data(1,1))],[handles.initcond{k}(2),handles.table{data(1,4),2}(data(1,1))],'color','r')   %line from initial conditions to 1st collision
    M(1)=getframe;  %save 1st frame
    line([handles.initcond{k}(1),handles.table{data(1,4),1}(data(1,1))],[handles.initcond{k}(2),handles.table{data(1,4),2}(data(1,1))],'color','k')   %draw initial condition line in  black
    line([handles.table{data(1,4),1}(data(1,1)),handles.table{data(2,4),1}(data(2,1))],[handles.table{data(1,4),2}(data(1,1)),handles.table{data(2,4),2}(data(2,1))],'color','r')   %draw new line from 1st collision to 2nd in red
    M(2)=getframe;  %save 2nd frame
    for n=2:size(data,1)-1
        line([handles.table{data(n-1,4),1}(data(n-1,1)),handles.table{data(n,4),1}(data(n,1))],[handles.table{data(n-1,4),2}(data(n-1,1)),handles.table{data(n,4),2}(data(n,1))],'color','k')   %darken previous segment so it is red
        line([handles.table{data(n,4),1}(data(n,1)),handles.table{data(n+1,4),1}(data(n+1,1))],[handles.table{data(n,4),2}(data(n,1)),handles.table{data(n+1,4),2}(data(n+1,1))],'color','r')   %draw new line segment in red from previous collision to new collision
        M(n+1) = getframe;  %save frame
    end
end
%Phase space movie (when points are drawn for the first time they
%   are red for emphasis and then drawn as black in the next frame)
if get(handles.movie1,'Value')==0 & get(handles.movie2,'Value')==1
    xlabel('t')
    ylabel('incident angle')
    title('Phase Space:  t vs incident angle')
    axis([handles.table{1,3},handles.table{size(handles.table,1),4},-pi/2,pi/2])    %set axis to show phase space
    %draw vertical lines to divide space into each piece
    for n=1:size(handles.table,1)-1
        line([handles.table{n,4},handles.table{n,4}],[-pi/2,pi/2])  %draw vertical line between each piece
        hold on
    end
    data=handles.data{size(handles.data,2)};    %set of last initial conditions, which will be the only set the movie will show
    plot(data(1,1),data(1,3),['.','r']) %draw first collision in red
    M(1)=getframe;  %save 1st frame
    for n=2:size(data,1)
        plot(data(n-1,1),data(n-1,3),['.','k']) %draw previous collision in black
        hold on
        plot(data(n,1),data(n,3),['.','r']) %draw new collision in red
        M(n)=getframe;  %save frame
    end
end
%Configuration and phase space movie
if get(handles.movie1,'Value')==1 & get(handles.movie2,'Value')==1
    subplot('position',[.05,.1,.4,.7])  %divide window in 2 and work on left plot currently
    %draw table on left
    for n=1:size(handles.table,1)
        ezplot(handles.table{n,1},handles.table{n,2},[handles.table{n,3},handles.table{n,4}])   %plot each piece of the table
        hold on
        if handles.table{n,5}==1  %check if each piece is a horizontal or vertical line
            line([handles.table{n,1}(handles.table{n,3}),handles.table{n,1}(handles.table{n,4})],[handles.table{n,2}(handles.table{n,3}),handles.table{n,2}(handles.table{n,4})])   %darken vertical and horizontal lines
        end
    end
    title('Configuration Space')
    text(handles.table{1,1}(handles.table{1,3}),handles.table{1,2}(handles.table{1,3}),['t=',num2str(handles.table{1,3})],'VerticalAlignment','top')    %label for lowest t value
    for n=1:size(handles.table,1)
        text(handles.table{n,1}(handles.table{n,4}),handles.table{n,2}(handles.table{n,4}),['t=',num2str(handles.table{n,4})],'VerticalAlignment','bottom')   %labels for t values between pieces
    end
    k=size(handles.data,2); %set of last initial conditions, which will be the only set the movie will show
    data=handles.data{k};
    line([handles.initcond{k}(1),handles.table{data(1,4),1}(data(1,1))],[handles.initcond{k}(2),handles.table{data(1,4),2}(data(1,1))],'color','r')   %line from initial conditions to 1st collision
    subplot('position',[.55,.1,.4,.7])  %work on right plot now
    xlabel('t')
    ylabel('incident angle')
    title('Phase Space:  t vs incident angle')
    axis([handles.table{1,3},handles.table{size(handles.table,1),4},-pi/2,pi/2])    %set axis to show phase space
    for n=1:size(handles.table,1)-1
        line([handles.table{n,4},handles.table{n,4}],[-pi/2,pi/2])  %draw vertical line between each piece
        hold on
    end    
    plot(data(1,1),data(1,3),['.','r']) %draw first collision in red
    hold on
    M(1)=getframe(gcf); %save 1st frame
    subplot('position',[.05,.1,.4,.7])  %work on left plot now
    line([handles.initcond{k}(1),handles.table{data(1,4),1}(data(1,1))],[handles.initcond{k}(2),handles.table{data(1,4),2}(data(1,1))],'color','k')   %draw initial condition line in black
    line([handles.table{data(1,4),1}(data(1,1)),handles.table{data(2,4),1}(data(2,1))],[handles.table{data(1,4),2}(data(1,1)),handles.table{data(2,4),2}(data(2,1))],'color','r')   %draw new line from 1st collision to 2nd in red
    subplot('position',[.55,.1,.4,.7])  %work on right plot now
    plot(data(1,1),data(1,3),['.','k'])  %draw previous collision in black
    plot(data(2,1),data(2,3),['.','r'])  %draw new collision in red
    M(2)=getframe(gcf); %save 2nd frame
    for n=3:size(data,1)
        subplot('position',[.05,.1,.4,.7])  %work on left plot now
        line([handles.table{data(n-2,4),1}(data(n-2,1)),handles.table{data(n-1,4),1}(data(n-1,1))],[handles.table{data(n-2,4),2}(data(n-2,1)),handles.table{data(n-1,4),2}(data(n-1,1))],'color','k')   %draw previous line in black
        line([handles.table{data(n-1,4),1}(data(n-1,1)),handles.table{data(n,4),1}(data(n,1))],[handles.table{data(n-1,4),2}(data(n-1,1)),handles.table{data(n,4),2}(data(n,1))],'color','r')   %draw new line in red
        
%         %gui table to print number of iterations
%         f= figure('Position',[100 100 400 150]);
%         ColumnName={'iterations'};
%         ColumnFormat={'numeric'};
%         d = {n};
%         t= uitable('Data', d, 'columnname', ColumnName,...
%             'columnformat', ColumnFormat, 'ColumnEditable',...
%             false, 'RowName',[]);
%         t.Position(3) = t.Extent(3);
%         t.Position(4) = t.Extent(4); 
%         
        
        subplot('position',[.55,.1,.4,.7])  %work on right plot now
        plot(data(n-1,1),data(n-1,3),['.','k'])  %draw previous collision in black
        plot(data(n,1),data(n,3),['.','r'])  %draw new collision in red
        M(n) = getframe(gcf);    %save frame
    end
    subplot('position',[.05,.1,.4,.7])
end
%view movie 20 times if selected (at frame rate in options)
if get(handles.movieview,'Value')==1           
    movie(M,20,handles.fps)
end
%save movie in matlab format if selected
if get(handles.moviesave1,'Value')==1
    save(uiputfile,'M')
end
%save movie in avi format if seleted (at frame rate in options)
%fps: frames per second
if get(handles.moviesave2,'Value')==1
    %movie2avi(M,uiputfile,'fps',handles.fps)
    vidObject = VideoWriter('newfile.avi'); 
    %vidObject.FrameRate = fps;
    open(vidObject); 
    for n=1:size(data,1)
        subplot('position',[.05,.1,.4,.7])  %work on left plot now
        line([handles.table{data(n-2,4),1}(data(n-2,1)),handles.table{data(n-1,4),1}(data(n-1,1))],[handles.table{data(n-2,4),2}(data(n-2,1)),handles.table{data(n-1,4),2}(data(n-1,1))],'color','k')   %draw previous line in black
        line([handles.table{data(n-1,4),1}(data(n-1,1)),handles.table{data(n,4),1}(data(n,1))],[handles.table{data(n-1,4),2}(data(n-1,1)),handles.table{data(n,4),2}(data(n,1))],'color','r')   %draw new line in red
        subplot('position',[.55,.1,.4,.7])  %work on right plot now
        plot(data(n-1,1),data(n-1,3),['.','k'])  %draw previous collision in black
        plot(data(n,1),data(n,3),['.','r'])  %draw new collision in red
        M(n) = getframe(gcf);    %save frame
        writeVideo(vidObject, M(n));
    end
     
    close(vidObject);
    
end

% --------------------------------------------------------------------
function initphase_Callback(hObject, eventdata, handles)
%Select initial conditions from phase space
color='rkbgymcrkbgymcrkbgymcrkbgymc'; %order of colors used for drawing previous data points
if handles.tables   %if a saved table is present
    handles.table=[handles.stable;handles.table];   %combined saved and new table
end
table=handles.table;
syms t; %make t a symbolic variable
figure  %open a new window
for k=1:size(handles.data,2)
    plot(handles.data{k}(:,1),handles.data{k}(:,3),['.',color(k)])  %plot all of the calculated data in phase space (using a different color for each set of initial conditions)
    hold on
end
% here are the phase space bounds
axis([handles.table{1,3},handles.table{size(handles.table,1),4},-pi/2,pi/2])    %set axis for phase space
for n=1:size(handles.table,1)-1
    line([handles.table{n,4},handles.table{n,4}],[-pi/2,pi/2])  %draw vertical lines to divide up phase space into pieces
end
xlabel('t')
ylabel('incident angle')
title('Phase Space:  t vs incident angle')
initc=ginput(1);    %allow the user to use cross-hairs to select a point on the graph
set(handles.inite1,'String',num2str(initc(1)))  %enter t coordinate into edit fields
set(handles.inite3,'String',num2str(initc(2)))  %enter angle into edit fields
% --------------------------------------------------------------------
function initradio1_Callback(hObject, eventdata, handles)
set(handles.initradio1,'Value',1)
set(handles.initradio2,'Value',0)
%set(handles.radiobutton9,'Value',0)
set(handles.inite1,'Visible','on')
set(handles.inite2,'Visible','on')
set(handles.inite3,'Visible','on')
set(handles.initl1,'Visible','on')
set(handles.initl2,'Visible','on')
set(handles.initl3,'Visible','on')
set(handles.initl1,'String','x')
set(handles.initl2,'String','y')
set(handles.initl3,'String','Horizontal Angle')
set(handles.initphase,'Visible','off')
% --------------------------------------------------------------------
function initradio2_Callback(hObject, eventdata, handles)
set(handles.initradio2,'Value',1)
set(handles.initradio1,'Value',0)
%set(handles.radiobutton9,'Value',0)
set(handles.inite1,'Visible','on')
set(handles.inite2,'Visible','off')
set(handles.inite3,'Visible','on')
set(handles.initl1,'Visible','on')
set(handles.initl2,'Visible','of')
set(handles.initl3,'Visible','on')
set(handles.initl1,'String','t')
set(handles.initl3,'String','Incident Angle')
set(handles.initl3,'String','Incident Angle')
set(handles.initphase,'Visible','on')

% --- Executes on mouse press over axes background.
function preview_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text20.
function text20_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over databox.
function databox_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to databox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over param2l.
function param2l_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to param2l (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text21.
function text21_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
