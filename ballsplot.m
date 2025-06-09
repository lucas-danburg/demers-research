    figure    
    hold on
    %draw table
    for n=1:size(table,1)
        ezplot(table{n,1},table{n,2},[table{n,3},table{n,4}])   %draw each piece of the table
        hold on
        if table{n,5}==1  %check for horizontal and vertical pieces
            line([table{n,1}(table{n,3}),table{n,1}(table{n,4})],[table{n,2}(table{n,3}),table{n,2}(table{n,4})])   %darken horizontal and vertical lines
        end
    end

    %place text labels on plot describing value of t at intersection of
    %pieces (t=2 is such a label)
    text(table{1,1}(table{1,3}),table{1,2}(table{1,3}),['t=',num2str(table{1,3})],'VerticalAlignment','top')  %put label for starting point
    for n=1:size(table,1)
        text(table{n,1}(table{n,4}),table{n,2}(table{n,4}),['t=',num2str(table{n,4})],'VerticalAlignment','bottom')   %create text labels for t
    end
    
    if isnan(data1(1,1))
        line([initcond(1),data1(1,2)],[initcond(2),data1(1,3)],'color','g')
    else
        line([initcond(1),table{data1(1,4),1}(data1(1,1))],[initcond(2),table{data1(1,4),2}(data1(1,1))],'color','g')
    end
    if isnan(data2(1,1))
        line([initcond(5),data2(1,2)],[initcond(6),data2(1,3)],'color','r')
    else
        line([initcond(5),table{data2(1,4),1}(data2(1,1))],[initcond(6),table{data2(1,4),2}(data2(1,1))],'color','r')
    end
    
    for n=2:size(data1,1)
        if isnan(data1(n-1,1))
            xold=data1(n-1,2);
            yold=data1(n-1,3);
        else
            xold=table{data1(n-1,4),1}(data1(n-1,1));
            yold=table{data1(n-1,4),2}(data1(n-1,1));
        end
        if isnan(data1(n,1))
            xnew=data1(n,2);
            ynew=data1(n,3);
        else
            xnew=table{data1(n,4),1}(data1(n,1));
            ynew=table{data1(n,4),2}(data1(n,1));
        end
        if isnan(data1(n-1,1)) | isnan(data1(n,1))
            line([xold,xnew],[yold,ynew],'color','b')        
        else
            line([xold,xnew],[yold,ynew],'color','g')              
        end
    end
    
    for n=2:size(data2,1)    
        if isnan(data2(n-1,1))
            xold=data2(n-1,2);
            yold=data2(n-1,3);
        else
            xold=table{data2(n-1,4),1}(data2(n-1,1));
            yold=table{data2(n-1,4),2}(data2(n-1,1));
        end
        if isnan(data2(n,1))
            xnew=data2(n,2);
            ynew=data2(n,3);
        else
            xnew=table{data2(n,4),1}(data2(n,1));
            ynew=table{data2(n,4),2}(data2(n,1));
        end        
        if isnan(data2(n-1,1)) | isnan(data2(n,1))
            line([xold,xnew],[yold,ynew],'color','c')        
        else
            line([xold,xnew],[yold,ynew],'color','r')              
        end
    end
    title('Configuration Space')
    
    for n=1:size(collision,1)
        line([collision(n,1)-3*cos(collision(n,3)),collision(n,1)+3*cos(collision(n,3))],[collision(n,2)-3*sin(collision(n,3)),collision(n,2)+3*sin(collision(n,3))],'color','k')
    end