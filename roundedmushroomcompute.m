heights=3;
angles=8;
nmax=1000;

alldata=[];
allinitcond=[];
alltable=[];

syms t
global table
h=[0,.1,.2,.3];
for p=1:heights
    p
    moredata=[];
    moreinitcond=[];
    roundedmushroom(1,1,1,.5,1,h(p),0);
    alltable{end+1}=table;
    
    d=sym(zeros(size(table,1),1));
    for m=1:size(table,1)
        x=eval(char(table{m,1}));   %symbolic function for x(t)
        y=eval(char(table{m,2}));   %symbolic function for y(t)
        d(m,1)=atan(diff(y,t)/diff(x,t));
    end
    
    initcond=[];
    angle=linspace(1-pi/2,-pi/2,angles+1);
    
    for q=1:angles
        data=zeros(nmax,4);
        xo=.2;
        yo=.995;
        ao=angle(q);
        initcond{end+1}=[xo,yo,ao];
        n=1;
        iterate
        
        while n<=nmax
            n=n+1;
            xo=table{data(n-1,4),1}(data(n-1,1));
            yo=table{data(n-1,4),2}(data(n-1,1));
            ao=data(n-1,2);
            try
                iterate %find the location and angle of the next collision
            catch   %if error in iterate then run the following:
                'iterate error' %error message
            end    
        end
        moredata{end+1}=data;
    end
    alldata{end+1}=moredata;
    allinitcond{end+1}=initcond;
end