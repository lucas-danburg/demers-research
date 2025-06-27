function area = Q(w, delta, r, rho)
    % function to get the area of a squircle cell table
    partTWO = (delta^2*rho/2)*((pi*rho/4)+(rho/2))+delta*(1-delta)*rho^2*(1+pi/4)*(sqrt(2)/2)+(1-delta)^2*(pi^2*rho^2/16);
    partTHREE = -0.5*(delta*rho*(sqrt(2)/2) + (1-delta)*(pi*rho/4))^2;
    squircle = 8*(partTWO + partTHREE);
    area = (w^2)-(pi*r^2)-squircle;
end