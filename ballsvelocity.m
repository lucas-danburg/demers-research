figure
for n=1:size(collision,1)
    plot(collision(n,5),collision(n,6),'.r')
    hold on
end
xlabel('velocity of ball 1')
ylabel('velocity of ball 2')

figure
subplot(2,1,1)
plot(collision(:,5))
title('Velocity of ball 1')
subplot(2,1,2)
plot(collision(:,6))
title('Velocity of ball 2')

figure
subplot(2,1,1)
hist(collision(:,5))
title('Velocities of ball 1')
subplot(2,1,2)
hist(collision(:,6))
title('Velocities of ball 2')