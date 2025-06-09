global table
syms t
syms partition1
syms partition2

d=sym(zeros(size(table,1),1));
for m=1:size(table,1)
    d(m,1)=atan(diff(table(m,2),t)/diff(table(m,1),t));
end

color='rkbgymcrkbgymc';
points=[];
for n=1:size(table,1)
    points=[points;[double(subs(table(n,1),table(n,3))),double(subs(table(n,2),table(n,3)))]];
end
for n=1:size(table,1)
    for j=1:size(points,1)
        partition1(n,j)=points(j,2)-table(n,2);
        partition2(n,j)=points(j,1)-table(n,1);
    end
end
tt=linspace(double(table(1,3)),double(table(end,4)),300);
figure
axis([0,double(table(end,4)),-pi/2,pi/2])
for n=1:size(table,1)-1
    line([double(table(n,4)),double(table(n,4))],[-pi,pi])
    hold on
end

%insert lines that bound the region that keeps the particle inside the
%table (particle is in interior/exterior of table)
upper=zeros(size(tt));
for k=1:length(tt)
    p=piece(tt(k));
    upper(k)=subs(d(p),tt(k));
    if subs(diff(table(p,1),t),tt(k))<0  %fix angle in case atan gives wrong quadrant
        if upper(k)>0
            upper(k)=upper(k)-pi;
        else
            upper(k)=upper(k)+pi;
        end
    end
end
% plot(tt,upper,['y'])
lower=mod(upper+pi,2*pi);
for n=1:length(lower)
    if lower(n)>pi
        lower(n)=lower(n)-2*pi;
    end
end
% plot(tt,lower,['y'])

y=zeros(length(tt),size(points,1));
for k=1:length(tt)
    p=piece(tt(k));
    for j=1:size(points,1)
        y(k,j)=atan2(subs(partition1(p,j),tt(k)),subs(partition2(p,j),tt(k)));
%         y(k)=mod(atan2(subs(partition1(p,j),tt(k)),subs(partition2(p,j),tt(k)))-subs(d(p),tt(k))+pi/2,pi);
%         if y(k)>pi/2
%             y(k)=y(k)-pi;
%         end
    end
end
% for j=1:size(points,1)
%      plot(tt,y(:,j),[color(j)])
% end



marky=[];
for n=1:size(table,2)
    markt=find(double(table(n,3))<=tt & tt<double(table(n,4)));
    marky(:,1)=y(markt,n)-lower(markt)'-pi/2;
    for j=1:size(table,2)-1
        m=mod(n-j,size(table,2));
        if m~=0
            marky(:,j+1)=y(markt,m)-y(markt,m+1);
        else
            marky(:,j+1)=y(markt,size(table,2))-y(markt,1);
        end
    end
    marky(:,j+2)=upper(markt)'-y(markt,m);
    area(markt,marky,-pi/2)
end

        







for j=1:size(points,1)
    y=[];
    for k=1:length(tt)
        p=piece(tt(k));
        y(k)=atan2(subs(partition1(p,j),tt(k)),subs(partition2(p,j),tt(k)));
%         y(k)=mod(atan2(subs(partition1(p,j),tt(k)),subs(partition2(p,j),tt(k)))-subs(d(p),tt(k))+pi/2,pi);
%         if y(k)>pi/2
%             y(k)=y(k)-pi;
%         end
    end
    plot(tt,y,[color(j)])
end
