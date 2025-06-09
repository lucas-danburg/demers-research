%
%asymlemonyap computes the Lyapunov Exponent for Asymmetric lemon
%billiard tables
%

%rx1- larger radius
%rx2- smaller radius
%deriv comp: [__,__,incident angle, piece)
function limArr=asymlemonlyap(rx1,rx2,derivComp,n,raw)

derivTable=zeros(n,4);  %declare the table containing the derivative matrices
vecprod=zeros(n,2);     %table containing the growing vector DT(x)v
vecprod(1,1)=-1/sqrt(2);    %initialize the vector to be in quadrants 2 and 4, or (-1,1)
vecprod(1,2)=1/sqrt(2);

limArr=zeros(n-1,1);
uArr=zeros(n,2);
sum=zeros(n,1);
arr=zeros(n,2);

for x = 1:n-1    
xo=derivComp(x,1);    %initial bounce for derivative calc
yo=derivComp(x,2);
ao=derivComp(x,3);

x1=derivComp(x+1,1);    %second bounce for derivative calc
y1=derivComp(x+1,2);
a1=derivComp(x+1,3);

piece0=derivComp(x,4);  %which boundary piece each bounce is on
piece1=derivComp(x+1,4);

tau=sqrt((x1-xo)^2+(y1-yo)^2); %distance between each bounce

%computes the derivative matrix
if isnan(ao) || isnan(a1) %in case the angle is passed as a NaN
    derivTable(x,1)=derivTable(x-1,1);
    derivTable(x,2)=derivTable(x-1,2);
    derivTable(x,3)=derivTable(x-1,3);
    derivTable(x,4)=derivTable(x-1,4);
else
    %the curvature of the first and second points
    if piece0==1 %if r0 is on the  larger arc
        curvatureo=-1/rx1;
        if piece1==1
            curvature1=-1/rx1;
        else
            curvature1=-1/rx2;
        end
    else %if r0 is on the smaller arc
        curvatureo=-1/rx2;
        if piece1==1
            curvature1=-1/rx1;
        else
            curvature1=-1/rx2;
        end
    end
    derivTable(x,1)=-1/cos(a1)*(tau*curvatureo+cos(ao)); %fill in Derivative Matrix
    derivTable(x,2)=-(tau)/cos(a1);
    derivTable(x,3)=-1/cos(a1)*(tau*curvatureo*curvature1...
        +curvatureo*cos(a1)+curvature1*cos(ao));
    derivTable(x,4)=-1/cos(a1)*(tau*curvature1+cos(a1));
end


%take the magnitude of the vector
magnitude=sqrt(vecprod(x,1)^2+vecprod(x,2)^2);
uArr(x,1)=vecprod(x,1)/magnitude;   %normalize vector
uArr(x,2)=vecprod(x,2)/magnitude;

%product of normalized vector and the derivative matrix
arr(x,1)=derivTable(x,1)*uArr(x,1)+derivTable(x,2)*uArr(x,2);
arr(x,2)=derivTable(x,3)*uArr(x,1)+derivTable(x,4)*uArr(x,2);
mag=sqrt(arr(x,1)^2+arr(x,2)^2);

if x>1  %recursive sum to compute the sum of logs
    sum(x,1)=sum(x-1,1)+log(mag);
else
    sum(x,1)=log(mag);
end

%divide the sum by x to get the lyapunov exponent
lim=sum(x,1)/(x+1);
limArr(x,1)=lim;

vecprod(x+1,1)=arr(x,1);    %change the next vector
vecprod(x+1,2)=arr(x,2);

end

if raw==0
    figure
    plot(limArr)
    title(['Graph of Lyapunov exponent over ' num2str(n) ' iterations'])
end
end



