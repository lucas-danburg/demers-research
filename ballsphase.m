figure
for n=1:size(data1,1)
    if ~isnan(data1(n,1))
        plot(data1(n,1),data1(n,3),'.r')  %plot '.' at each point with t-value on the horizontal and incident angle on the vertical, using the approrpriate color
        hold on
    end
end
for n=1:size(data2,1)
    if ~isnan(data2(n,1))
        plot(data2(n,1),data2(n,3),'.b')  %plot '.' at each point with t-value on the horizontal and incident angle on the vertical, using the approrpriate color
        hold on
    end
end
axis([table{1,3},table{size(table,1),4},-pi/2,pi/2])    %set window to outline phase space
for n=1:size(table,1)-1
    line([table{n,4},table{n,4}],[-pi/2,pi/2])  %draw vertical lines to distinguish different pieces
end
% xlabel('t')
% ylabel('incident angle')
% title('Phase Space:  t vs incident angle')