% s = t - pi*rho/4 - table{8,3};
% (delta*rho + (1-delta)*rho*pi/4 > 1 - r && delta*rho*sqrt(2)/2 + (1-delta)*pi*rho/4 < 1 - r/sqrt(2)),   w/2 - r = 1-r
% -pi*rho/4 <= s <= pi*rho/4
% 1/sqrt(2) < r < 1
% delta = 1, 0.5, 0.3, 0.2, 0.1, 0.05, 0.01
w = 2;
iterations = 100;
d = [1 0.5 0.3 0.2 0.1 0.05 0.01 0];

for delta = d
    for r = linspace(1/sqrt(2), 1, iterations)
        for rho = linspace((1-r)/(delta+(1-delta)*pi/4), (1-r/sqrt(2))/(delta*sqrt(2)/2+(1-delta)*pi/4), iterations)
            partTWO = (delta^2*rho/2)*((pi*rho/4)+(rho/2))+delta*(1-delta)*rho^2*(1+pi/4)*(sqrt(2)/2)+(1-delta)^2*(pi^2*rho^2/16);
            partTHREE = -0.5*(delta*rho*(sqrt(2)/2) + (1-delta)*(pi*rho/4))^2;
            squircle = 8*(partTWO + partTHREE);
            area = (w^2)-(pi*r^2)-squircle;
            
            side_squircle = integral(@(s)sqrt(delta^2+(2*delta*cos(s/rho)*(1-delta))+(1-delta)^2), -pi*rho/4, pi*rho/4);
            length = 4*(pi*r/2) + 4*(w-2*r)+4*(side_squircle);
            
            tau_bar = pi*area/length;
            
            %disp("Delta = " + delta);
            %disp("R = " + r);
            %disp("Rho = " + rho);
            %disp("partTWO = " + partTWO);
            %disp("partTHREE = " + partTHREE);
            %disp("Squircle = " + squircle);
            %disp("Area = " + area);
            %disp("Length = " + length);
            disp("Tau_Bar = " + tau_bar);
            disp(' ');
        end
    end
end