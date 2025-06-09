ratios=10;
inits=10;
nmax=3000;

alldata=[];
allinitcond=[];
alltable=[];

rx=2;
ry=1;
h=1;
w1=.5;
w2=1.5;
r=linspace(1.5,0,ratios);
wr=(-r+2*rx-w)./r;

syms t
global table
for p=9:ratios
    p
    moredata=[];
    moreinitcond=[];

    inversecone(rx,ry,h,w1,w2,wr(p),0);
    alltable{end+1}=table;
    
    d=sym(zeros(size(table,1),1));
    for m=1:size(table,1)
        x=eval(char(table{m,1}));   %symbolic function for x(t)
        y=eval(char(table{m,2}));   %symbolic function for y(t)
        d(m,1)=atan(diff(y,t)/diff(x,t));
    end
    
    initcond=[];
    anglecond=linspace(-.1,-pi/2-.1,inits);
    
    for q=1:inits
        pause(.1)
        q
        data=zeros(nmax,4);
        xo=0;
        yo=1;
        ao=anglecond(q);
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
                n
                n=nmax+1;
                'iterate error' %error message
            end    
        end
        moredata{end+1}=data;
    end
    alldata{end+1}=moredata;
    allinitcond{end+1}=initcond;
end