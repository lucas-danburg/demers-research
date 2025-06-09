%data1 holds data for ball 1, data2 holds data for ball 2:
%   for collision with table:  [t, horziontal angle, incident angle, piece]
%   for collision with other ball:  [Nan, x-coordinate, y-coordinate,
%   horizontal angle of impact]
%collision:  describes whenever the balls collide, 1 row for each collision
%   [x-coordinate of point of contact, y-coordinate of point of contact,
%   angle in radians of line through centers, time of collision, new velocity 
%   for ball1, new velocity for ball2]
%totaltime:  time passed since start of simulation, where velocity of balls
%            is 1

nmax=10000;
syms t
global table
rectang(8,8,0);
r=1;

deriv=sym(zeros(size(table,1),1));
for m=1:size(table,1)
    x=eval(char(table{m,1}));   %symbolic function for x(t)
    y=eval(char(table{m,2}));   %symbolic function for y(t)
    deriv(m,1)=atan(diff(y,t)/diff(x,t));
end

x1=-3;
y1=0;
a1=1;
v1=1;
x2=0;
y2=2;
a2=-2;
v2=1;
initcond=[x1,y1,a1,v1,x2,y2,a2,v2];

data=zeros(nmax,4);
totaltime=0;
n=1;
nn=0;
data1=[];
data2=[];
collision=[];
flag=0;

%beginning of iteration:
%x1/x2/y1/y2 hold current position of balls
%a1/a2 hold current angle of balls
%v1/v2 hold current velocity of balls
%flag contains:  1 or 2 if ball 1 or 2 has just hit the boundary
%                0 if the balls just collided
%if ball1 just hit the table, t2 contains the time until the ball2
%   hits the table, and vice-versa

while nn<nmax
    nn=nn+1;
    if nn/10==floor(nn/10)
        nn
    end
    if flag==0 | flag==1
        xo=x1;
        yo=y1;
        ao=a1;
        iterate;
        data1(end+1,:)=data(n,:);
        xnew=table{data1(end,4),1}(data1(end,1));
        ynew=table{data1(end,4),2}(data1(end,1));
        t1=norm([xnew-xo,ynew-yo])/v1;
    end
    if flag==0 | flag==2
        xo=x2;
        yo=y2;
        ao=a2;
        iterate;
        data2(end+1,:)=data(n,:);
        xnew=table{data2(end,4),1}(data2(end,1));
        ynew=table{data2(end,4),2}(data2(end,1));
        t2=norm([xnew-xo,ynew-yo])/v2;
    end
    t0=min(t1,t2);
    ans=ballshit(x1,y1,a1,v1,x2,y2,a2,v2,t0,r);
    if ans<10^-8
        totaltime=totaltime+t0;
        if t0==t1
            flag=1;
            t2=t2-t0;
            x1=table{data1(end,4),1}(data1(end,1));
            y1=table{data1(end,4),2}(data1(end,1));
            a1=data1(end,2);
            x2=x2+t0*v2*cos(a2);
            y2=y2+t0*v2*sin(a2);
        else
            flag=2;
            t1=t1-t0;
            x2=table{data2(end,4),1}(data2(end,1));
            y2=table{data2(end,4),2}(data2(end,1));
            a2=data2(end,2);
            x1=x1+t0*v1*cos(a1);
            y1=y1+t0*v1*sin(a1);
        end
    else
        xmom=v1*cos(a1)+v2*cos(a2);
        ymom=v1*sin(a1)+v2*sin(a2);
        vel=v1^2+v2^2;
        
        flag=0;
        totaltime=totaltime+ans;
        x1=x1+ans*v1*cos(a1);
        y1=y1+ans*v1*sin(a1);
        x2=x2+ans*v2*cos(a2);
        y2=y2+ans*v2*sin(a2);
        at=atan((y1-y2)/(x1-x2));  %angle of line passing through the centers
        angle1=mod(a1-at,2*pi);
        if angle1>pi
            angle1=angle1-2*pi;
        end
        angle2=mod(a2-at,2*pi);
        if angle2>pi
            angle2=angle2-2*pi;
        end
        %equations
        %x-momentum: v1*cos(angle1)+v2*cos(angle2)=w1*cos(beta1)+w2*cos(beta2)
        %y-momentum for ball1:  v1*sin(angle1)=w1*sin(beta1)
        %y-momentum for ball2:  v2*sin(angle2)=w2*sin(beta2)
        %kinetic energy:  v1^2+v2^2=w1^2+w2^2
        a=v1*cos(angle1)+v2*cos(angle2);
        b=v1*sin(angle1);
        c=v2*sin(angle2);
        d=v1^2+v2^2;
        if abs(c)<10^-8 %motion of balls is 1 dimensional
            temp=a1;
            a1=a2;      %a1 and a2 swap values
            a2=temp;    %a1 and a2 swap values
            w1=v2;      %v1 and v2 swap values
            w2=v1;      %v1 and v2 swap values
            
        else
            % beta2 must satisfy
            % (d-b^2-a^2)*tan(beta2)^2=c^2/cos(beta2)^2-2ac*tan(beta2)+c^2
            if a*c>0
                beta2=solve([num2str((d-b^2-a^2)),'*tan(beta2)^2-1/cos(beta2)^2*',num2str(c^2),'+tan(beta2)*',num2str(2*a*c),'-',num2str(c^2)],'beta2');
            else
                beta2=solve([num2str((d-b^2-a^2)),'*tan(beta2)^2-1/cos(beta2)^2*',num2str(c^2),'-tan(beta2)*',num2str(abs(2*a*c)),'-',num2str(c^2)],'beta2');
            end
            beta2=double(beta2);
            w2=c./sin(beta2);   %comes from y-momentum of ball2
            indices=find(w2>0);   %w2 must be positive
            beta2=beta2(indices);    %get rid of incorrect values for beta2
            w2=w2(indices);  %get rid of incorrect values for w2
            indices=find(max(abs(beta2-angle2))==abs(beta2-angle2));
            beta2=beta2(indices);    %get rid of incorrect values for beta2
            w2=w2(indices);  %get rid of incorrect values for w2            

            if size(beta2)~=1
                error('unique beta2 not found')
            end

            w1=sqrt(d-w2.^2);   %comes from kinetic energy
            beta1=acos((a-w2.*cos(beta2))./w1);  %comes from x-momentum
            if b./w1<0  %if sin(beta1) is negative (needed since acos may not be in the right quadrant)
                beta1=-beta1;
            end
            a1=mod(real(beta1)+at,2*pi);
            if a1>pi
                a1=a1-2*pi;
            end
            a2=mod(real(beta2)+at,2*pi);
            if a2>pi
                a2=a2-2*pi;
            end
        end        
        v1=real(w1);
        v2=real(w2);      
        collision=[collision;(x1+x2)/2,(y1+y2)/2,at,totaltime,v1,v2];
        data1(end,:)=[];
        data2(end,:)=[];
        data1=[data1;NaN,x1,y1,a1];
        data2=[data2;NaN,x2,y2,a2];
    end
end




%             if abs(mod(angle1,2*pi)-pi)<10^-8
%                 multiplier1=-1;
%             else
%                 multiplier1=1;
%             end
%             if abs(mod(angle2,2*pi)-pi)<10^-8
%                 multiplier2=-1;
%             else
%                 multiplier2=1;
%             end
% 
%             %equations reduce to a=multiplier1*v1+multiplier2*v2 and d=v1^2+v2^2
%             %solving gives v2^2-multiplier2*a*v2+(a^2-d)/2=0
%             if v1>v2    %v2 is in front and should leave with the greater velocity
%                 w1=[(multiplier2*a-sqrt(-a^2+2*d))/2,(multiplier2*a+sqrt(-a^2+2*d))/2];
%                 w1=w1(find(abs(w1-v1)>10^-8 & w1>=0));   %velocity must change and be positive
%                 w2=multiplier1*(a-multiplier2*w1);
%             else        %v1 is in front and should leave with the greater velocity
%                 w1=[(multiplier2*a-sqrt(-a^2+2*d))/2,(multiplier2*a+sqrt(-a^2+2*d))/2];
%                 w1=w1(find(abs(w1-v1)>10^-8) & w1>=0);   %velocity must change and be positive
%                 w2=multiplier1*(a-multiplier2*w1);      
%             end