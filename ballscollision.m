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
for n=1:size(collision,1)
    plot(collision(n,1),collision(n,2),'*r')
    hold on
end
title('Collisions in Configuration Space')
