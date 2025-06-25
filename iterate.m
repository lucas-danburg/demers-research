%iterate finds the location and angle of the next collision

%n is current iteration
%z is collection of possible values of t for the next iteration
%xo is x-value of last intersection
%yo is y-value of last intersection
%ao is horizontal angle of last intersection
%told is found value of t for current intersection
%newpiece is the number of the piece that is hit for current intersection
%data has 4 columns:  t, horizontal angle, incident angle, piece

%for example:  data(n-1,1) is t value for last intersection

%find all possible values for t
global torus
isTorus = false; % Default: not a torus
% Example: set to true for a specific table or initial condition
if exist('torus','var') && strcmp(torus,'torus')
    isTorus = true;
end
z=[];

for j=1:size(table,1)
    %fun is tan(ao)*(x(t)-xo)-y(t)+yo
    fun=inline([num2str(tan(ao)),'*(',char(table{j,1}),'-',num2str(xo),')-(',char(table{j,2}),')+',num2str(yo)]);
    %disp('got fun')
    a=table{j,3};   %lower bound of t for piece
    b=table{j,4};   %upper bound of t for piece
    %disp('got bounds')
    
    %for pieces that are line segments
    if table{j,5}==1
        %disp('line segment')
        root=fzero(fun,(a+b)/2); %use average of a and b as starting point for fzero
        if root>=a & root<=b   %check if root is inside the interval
            z=[z,root];  %add root to z
        end

       
    %for pieces that are circular/elliptical arcs
    %xx1,xx2,yy1,yy2 are the x and y coordinates of the intersection of the line and arc with the
    %circle except the center of the circle is mapped to the origin
    elseif table{j,5}==2
        %disp('arc')
        [cx,cy,rx,ry]=ellipseparam(table{j,1},table{j,2},table{j,3},table{j,4});  %finds x and y coordinates of center and radius of circle
        hit=0;  %indicates if the trajectory hits the arc or not
        if abs(mod(ao,pi)-pi/2)<10^-2 %deals specifically with vertical lines
            %disp('vertical trajectory (10^-2 precision)')
            if cx-rx<=xo & xo<=cx+rx
                hit=1;
                xx1=xo - cx;
                xx2=xo - cx;
                %disp('yy1 becomes imaginary here: (?)')
                yy1=-sqrt(rx^2*(1-xx1^2/ry^2));
                yy2=sqrt(rx^2*(1-xx2^2/ry^2));
            end
        else
            m=tan(ao);  %slope of trajectory
            b0=-m*xo+m*cx+yo-cy;    %y-intercept of trajectory      y-(yo-cy)=m(x-(xo-cx))
            aq=rx^2*m^2+ry^2;   %a in the quadratic formula for roots
            bq=2*m*b0*rx^2;     %b in the quadratic formula for roots
            cq=b0^2*rx^2-rx^2*ry^2; %c in the quadratic formula for roots
            if bq^2-4*aq*cq>=0  %checks determinant to see if it hits
                hit=1;  %trajectory hits arc
                xx1=(-bq-sqrt(bq^2-4*aq*cq))/2/aq;   %x-coordinate of intersection 1 (in circle's coordinate system)
                xx2=(-bq+sqrt(bq^2-4*aq*cq))/2/aq;   %x-coordinate of intersection 2
                yy1=m*xx1+b0; %y-coordinate of intersection 1
                yy2=m*xx2+b0; %y-coordinate of intersection 2
            end
        end
        if hit  %if trajectory hits arc
            %disp('hit detected')
            %taking in line function, evaluating at t inital and final
            lt=mod(atan2((table{j,2}(table{j,3})-cy)/ry,(table{j,1}(table{j,3})-cx)/rx),2*pi);   %angle from center to lower bound point
            ut=mod(atan2((table{j,2}(table{j,4})-cy)/ry,(table{j,1}(table{j,4})-cx)/rx),2*pi);   %angle from center to upper bound point
            %disp('got past first atan2s')
            %if lt or ut are 0 or 2pi then you must pick either 0 or 2pi
            %depending on if it leaves the positive x-axis going up or down
            if abs(lt)<.001 | abs(lt-2*pi)<.001
                if table{j,2}((b-a)/4+a)>table{j,2}(a)  %if complete circle/ellipse is traced counterclockwise
                    lt=0;
                else    %table is traced clockwise
                    lt=2*pi;
                end
            end
            if abs(ut)<.001 | abs(ut-2*pi)<.001
                if table{j,2}((a-b)/4+b)>table{j,2}(b)  %if complete circle/ellipse is traced counterclockwise
                    ut=0;
                else    %table is traced clockwise
                    ut=2*pi;
                end
            end
            
            %special case:  if the arc is a semicircle where the endpoints lie on a
            %vertical line and the arc is to the right of the circle's
            %center
            if abs(table{j,1}(a)-table{j,1}(b))<.001 & abs(cx+rx - table{j,1}((a+b)/2))<.001 %x-coordinate of arc endpoints are same and midpoint of arc has x-coordinate a distance of 1 radius to the right
                if lt>pi    %convert lt angle to -pi/2 if it is 3pi/2
                    lt=lt-2*pi;
                end
                
                %disp('finding alpha')
                alpha=atan2(yy1/ry,xx1/rx);
                if abs(alpha)<pi/2      %gives intersection if alpha is in right half plane
                    z=[z,abs(alpha-lt)/pi*(b-a)+a];    %add root that is the same percent from lower to upper arc bounds as t
                end
                alpha=atan2(yy2/ry,xx2/rx);
                if abs(alpha)<pi/2      %gives intersection if alpha is in right half plane
                    z=[z,abs(alpha-lt)/pi*(b-a)+a];    %add root that is the same percent from lower to upper arc bounds as t
                end
                %disp('found')
                
            %find value of z for all regular cases (except above special
            %one)
            else
                %disp('finding beta')
                % checking if drawm arc spans a jump in the argument
                xmid = table{j,1}((table{j,3} + table{j,4})/2);
                ymid = table{j,2}((table{j,3} + table{j,4})/2);
                beta = mod((atan2((ymid-cy)/ry ,(xmid-cx)/rx)),2*pi); %beta is angle of midpoint, measured from the center of the arc
                %disp('first beta atan2')
                uswitch = 0;
                lswitch = 0;
                if lt < ut
                    if (lt >= beta || beta >= ut)
                        ut = ut - 2*pi;  %reassigns ut a negative value in order to make angular values in drawn arc continuous
                        uswitch = 1;
                    end
                end
                if ut < lt
                    if (ut >= beta || beta >= lt)
                        lt = lt - 2*pi;   %reassigns lt a negative value in order to make angular values in drawn arc continuous
                        lswitch = 1;
                    end
                end
                %alpha is one of the 2 angles to the intersection point
                %measured from the center of the arc
                %disp('attempting second beta atan2')
                alpha=mod(atan2(yy1/ry,xx1/rx),2*pi);
                %disp('second beta atan2')
                
                %if switched ut or lt need to adjust alpha the same way
                if uswitch == 1
                    if alpha > ut + 2*pi
                        alpha = alpha - 2*pi;
                    end
                end
                if lswitch == 1
                    if alpha > lt + 2*pi
                        alpha = alpha - 2*pi;
                    end
                end
                
                if lt<=ut & lt<=alpha & alpha<=ut   %if alpha is between the lower and upper bounds for arcs (with lower less than upper)
                    %linear interpretation
                    z=[z,(alpha-lt)/(ut-lt)*(b-a)+a];    %add root that is the same percent from lower to upper arc bounds as t
                end
                if lt>=ut & lt>=alpha & alpha>=ut   %if alpha is between the lower and upper bounds for arcs (with upper less than lower)
                    z=[z,(alpha-ut)/(lt-ut)*(a-b)+b];    %add root that is the same percent from lower to upper arc bounds as t
                end
                %2nd root will be found corresponding to the other intersection
                %point
                %disp('attempting third beta atan2')
                alpha=mod(atan2(yy2/ry,xx2/rx),2*pi);
                %disp('third beta atan2')
                %if switched ut or lt need to adjust alpha the same way
                if uswitch == 1
                    if alpha > ut + 2*pi
                        alpha = alpha - 2*pi;
                    end
                end
                if lswitch == 1
                    if alpha > lt + 2*pi
                        alpha = alpha - 2*pi;
                    end
                end
                
                if lt<=ut & lt<=alpha & alpha<=ut   %if alpha is between the lower and upper bounds for arcs (with lower less than upper)
                    z=[z,(alpha-lt)/(ut-lt)*(b-a)+a];    %add root that is the same percent from lower to upper arc bounds as t
                end
                if lt>=ut & lt>=alpha & alpha>=ut   %if alpha is between the lower and upper bounds for arcs (with upper less than lower)
                    z=[z,(alpha-ut)/(lt-ut)*(a-b)+b];    %add root that is the same percent from lower to upper arc bounds as t
                end
            end
        end

    %for pieces that are not segments or arcs
    else
        %disp('not segment or arc')
        root=fzero(fun,a);  %use fzero starting at lower bound
        if root>a & root<b  %if root is between lower and upper bounds
            z=[z,root]; %add root to list
        end
        root=fzero(fun,b);  %use fzero starting at upper bound
        if root>a & root<b  %if root is between lower and upper bounds
            z=[z,root]; %add root to list
        end
        if fun(a)*fun(b)<0  %if endpoints have different signs
            root=fzero(fun,[a,b]);  %use fzero on interval
        else    %if endpoints have same sign
            root=fzero(fun,(a+b)/2);    %use fzero starting at midpoint
        end
        if root>a & root<b  %if root is between lower and upper bounds
            z=[z,root]; %add root to list
            if fun(root-(b-a)/100)*fun(a)<0 %check if sign is different at the lower bound and just to the left of the root
                root=fzero(fun,[a,root-(b-a)/20]);  %use fzero on this interval
                z=[z,root]; %add root to list
            end
            if fun(root+(b-a)/100)*fun(b)<0 %check if sign is different at the upper bound and just to the right of the root
                root=fzero(fun,[root+(b-a)/20,b]);  %use fzero on this interval
                z=[z,root]; %add root to list
            end
        end
    end
end
%disp('found z (?)')
%disp(z)
zzz=z;   %backup of z for debugging

% lucas's fix:
% it seems like repeated roots are screwing things up, so add
% a line to remove repeats from the z array

% sort z (in ascending order), find the difference between each value
% and build a truth array of which differences are greater than 1e-4
zsort = sort(z);
diffs = [true, abs(diff(zsort)) > 1e-4];
z = zsort(diffs);

%disp('removed repeated roots:')
%disp(z)

remove=[];  %index values of z for bad roots
%remove roots that correspond to the particle going the wrong direction
%from the collision (passing through the barrier)
if abs(mod(ao,pi)-pi/2)<10^-2  %deals specially with vertical trajectories
    %disp('vertical trajectory (10^-2 precision)')
    for k=1:size(z,2)
        if (table{piece(z(k)),2}(z(k))-yo)*sin(ao)<0    %if root corresponds to opposite direction
            %disp('opposite direction for root:')
            %disp(z(k))
            remove=[remove,k];
        end
    end
else
    %disp('not vertical trajectory (10^-2 precision)')
    for k=1:size(z,2)   %deals with all non-vertical trajectories
        if (table{piece(z(k)),1}(z(k))-xo)*cos(ao)<-5*10^-6    %if root corresponds to opposite direction
            %disp('opposite direction for root:')
            %disp(z(k))
            remove=[remove,k]; 
        end
    end
end
z(remove)=[];   %disp('removed bad roots (?)')
%disp(z)

zz=z;   %backup of z (in case all roots are removed in next step)
    
if n~=1 & size(z, 2) > 1
    %disp('removing current position roots')
    z=z(find(abs(z-data(n-1,1))>2*10^-4));  %remove root that corresponds to the particle's current position
    %disp('removed current position root')
    %disp(z)
end

%if no root is found increase tolerance on removal of root that corresponds
%to no movement
if size(z,2)==0
    %disp('size(z, 2) was not equal to zero')
    z=zz;
    z=z(find(abs(z-data(n-1,1))>10^-8));  %remove root that corresponds to the particle's current position
    %disp('no root was found and tolerance was incresed')
    %disp(z)
end

%find the value of possible values of t that has minimum distance from
%last point


if size(z,2)~=1
    %size(z, 2)
    %disp('size(z, 2) was not equal to 1')
    distance=zeros(1,size(z,2));
    for k=1:size(z,2)
        %disp('calculating distances of root to current point')
        i=piece(z(k));
        distance(1,k)=(xo-table{i,1}(z(k))).^2+(yo-table{i,2}(z(k))).^2;
    end
    distance(find(distance<10^-6))=inf;   %remove any values corresponding to no movement
    if length(find(distance==min(distance)))~=1 %if there is more than 1 closest point just pick the 1st one
        k=find(distance==min(distance));
        data(n,1)=z(k(1));
    else
       try
           data(n,1)=z(find(distance==min(distance)));  %store z value with minimum distance as t for this iteration
       catch
           'did not find all of the roots'
           handles.done=1;
       end
   end
else
    data(n,1)=z;  %store z value as correct t value for this iteration
end
%disp('sucessful in finding root, z = ')
%disp(data(n, 1))
told=data(n,1);   %told is t location of this collision
data(n,4)=piece(told); %which piecewise function of the table t is located in
newpiece=data(n,4);  %newpiece is the number of the piecewise function that is hit

%determines if it hit a corner or not by checking if t is near the
%bounds of the piece it is on and then making sure the piece does not
%loop back onto itself there
if (told-table{newpiece,3}<2*10^-4 | table{newpiece,4}-told<2*10^-4) & (abs(table{newpiece,1}(table{newpiece,3})-table{newpiece,1}(table{newpiece,4}))>10^-8 | abs(table{newpiece,2}(table{newpiece,3})-table{newpiece,2}(table{newpiece,4}))>10^-8)
    %collision with corner detected
    %disp('corner detected')
    j=1;    %index of other piece that makes up the corner
    x=inline(char(diff(eval(char(table{newpiece,1})),t)));   %x'(t) for new piece
    y=inline(char(diff(eval(char(table{newpiece,2})),t)));   %y'(t) for new piece
        
    if told-table{newpiece,3}<2*10^-4   %if hit the corner corresponding lower values of t for the piece
        %disp('lower end of segment')
        while abs(table{j,1}(table{j,4})-table{newpiece,1}(told))>5*10^-4  | abs(table{j,2}(table{j,4})-table{newpiece,2}(told))>5*10^-4  %checks if x and y distances from upper endpoint of piece to point are large
            j=j+1;  %trying to find piece that is the other side of the corner
        end

        xj=inline(char(diff(eval(char(table{j,1})),t)));        %x'(t) for j piece 
        yj=inline(char(diff(eval(char(table{j,2})),t)));        %y'(t) for j piece 
            
        %calculates the reflection angle for bouncing off the corner
        %disp('found other piece')
        data(n,2)=atan2(y(table{newpiece,3}),x(table{newpiece,3}))+atan2(yj(table{j,4}),xj(table{j,4}))-ao;
        %disp('assigned data')
    else
        %disp('upper end of segment')
        while abs(table{j,1}(table{j,3})-table{newpiece,1}(told))>5*10^-4 | abs(table{j,2}(table{j,3})-table{newpiece,2}(told))>5*10^-4  %checks if x and y distances from upper endpoint of piece to point are large
            j=j+1;  %trying to find piece that is the other side of the corner
        end
        
        xj=inline(char(diff(eval(char(table{j,1})),t)));        %x'(t) for j piece 
        yj=inline(char(diff(eval(char(table{j,2})),t)));        %y'(t) for j piece 
 
        %calculates the reflection angle for bouncing off the corner
        %disp('found other piece')
        data(n,2)=atan2(y(table{newpiece,4}),x(table{newpiece,4}))+atan2(yj(table{j,3}),xj(table{j,3}))-ao;
        %disp('assigned data')
    end
    data(n,2)=mod(data(n,2),2*pi); %move reflection angle to the principel value
    %disp('moved reflection angle')
    data(n,3)=NaN;  %store incident angle as non-existing for corners
    %disp('stored inc = NaN')
else
    %non-corner collision
    derivMat = matlabFunction(deriv(newpiece));
    if nargin(derivMat) == 0
        at = derivMat();  % constant
    else
        at = derivMat(told);  % symbolic function of t
    end
    %derivMat = matlabFunction(deriv(newpiece)); % convert symbolic function to matlab function so it can handle Inf
    %at=derivMat(told);  %angle of tangent line to table at point of collision
    %at=subs(deriv(newpiece),told);
    data(n,2)=mod(-ao+2*at,2*pi); %exiting horizontal angle
    data(n,3)=mod(-ao+pi/2+at,pi);  %incident angle
    if data(n,3)>pi/2
        data(n,3)=data(n,3)-pi;  %incident angle in correct interval
    end
end
if data(n,2)>pi
    %disp('data(n, 2) > pi')
    data(n,2)=data(n,2)-2*pi;  %correcting horizontal angle if not principle value
    %disp('corrected horiz angel to be principle (2pi)')
end
xo = table{data(n,4),1}(data(n,1));
%disp('got xo')
yo = table{data(n,4),2}(data(n,1));
%disp('got yo');
ao = data(n,2);
%disp('got ao');

if isTorus
    if xo > w/2, xo = xo - w; elseif xo < -w/2, xo = xo + w; end
    if yo > l/2, yo = yo - l; elseif yo < -l/2, yo = yo + l; end
end
