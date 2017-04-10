function t = tj(ti, Pi, Pj)
    alpha = 0.5;
    t = sqrt(sum((Pj - Pi).^2))^alpha + ti;    
end