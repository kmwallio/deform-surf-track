function [ present ] = in_model( x, y, nodeX, nodeY, a, b, c, alphas )
%IN_MODEL Summary of this function goes here
%   Detailed explanation goes here

    present = 0;
    
    height = size(a,1);
    width = size(a,2);
    
    h = 1;    
    while present == 0 && h <= height
        w = 1;
        while present == 0 && w <= width
            x0 = nodeX(h, w);
            y0 = nodeY(h, w);
            
            A = alphas(h, w);
            a0 = a(h, w);
            b0 = b(h, w);
            c0 = c(h, w);
            
            Z = A * exp( - (a0*(x-x0).^2 + 2*b0*(x-x0).*(y-y0) + c0*(y-y0).^2));
            
            present = Z >= 0.05;
            w = w + 1;
        end
        h = h + 1;
    end

end

