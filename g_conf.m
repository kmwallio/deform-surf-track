function [ gc ] = g_conf( X, Y, nodeX, nodeY, a, b, c, alphas )
%G_CONF Summary of this function goes here
%   Detailed explanation goes here
    
    gc = 0;

    sizeY = size(nodeX, 1);
    sizeX = size(nodeX, 2);
    
    for curX = 1:sizeX
        for curY = 1:sizeY
            x0 = nodeX(curY, curX);
            y0 = nodeY(curY, curX);
            A = alphas(curY, curX);
            a0 = a(curY, curX);
            b0 = b(curY, curX);
            c0 = c(curY, curX);
            
            gc = gc + (A * exp( - (a0*(X-x0).^2 + 2*b0*(X-x0).*(Y-y0) + c0*(Y-y0).^2)));
        end
    end

end

