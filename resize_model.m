function [ nX, nY, nA, nB, nC, nAlpha ] = resize_model( nodeX, nodeY, a, b, c, alphas, scale )
%HALF_MODEL Resizes model by scale
%   Given the model, applies a transformation to change the size of the
%   model by scale for use in the tracking hierarchy.

    nX = zeros(size(nodeX));
    nY = zeros(size(nodeY));
    nA = zeros(size(a));
    nB = zeros(size(b));
    nC = zeros(size(c));
    nAlpha = alphas;
    
    capH = size(nodeY, 1);
    capW = size(nodeY, 2);
    
    halfMat = [scale 0; 0 scale];
    
    for h = 1:capH
        for w = 1:capW
            covMat = [a(h, w) b(h, w); b(h, w) c(h, w)];
            resMat = halfMat * covMat * halfMat';
            
            nA(h, w) = resMat(1, 1);
            nB(h, w) = resMat(1, 2);
            nC(h, w) = resMat(2, 2);
            
            nXY = (halfMat * [nodeX(h, w), nodeY(h, w)]')';
            nX(h, w) = nXY(1);
            nY(h, w) = nXY(2);
        end
    end

end

