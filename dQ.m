function length = dQ(w, delta, r, rho)
    % function to get the length of the squircle cell boundary
    side_squircle = integral(@(s)sqrt(delta^2+(2*delta*cos(s/rho)*(1-delta))+(1-delta)^2), -pi*rho/4, pi*rho/4);
    length = 4*(pi*r/2) + 4*(w-2*r)+4*(side_squircle);
    
    %tau_bar = pi*area/length;
end