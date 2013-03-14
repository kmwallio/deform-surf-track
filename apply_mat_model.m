function [ nX, nY, nA, nB, nC ] = apply_mat_model( nodeX, nodeY, a, b, c, alphas, affMat )
%APPLY_MAT_MODEL Applies an affine matrix transformation on the model
%   Applies an affine trasformation
    
    nX = zeros(size(nodeX));
    nY = zeros(size(nodeY));
    nA = zeros(size(a));
    nB = zeros(size(b));
    nC = zeros(size(c));
    nAlpha = alphas;
    
    capH = size(nodeY, 1);
    capW = size(nodeY, 2);
    
    halfMat = affMat(1:2, 1:2);
    
    for h = 1:capH
        for w = 1:capW
            covMat = [a(h, w) b(h, w); b(h, w) c(h, w)];
            resMat = halfMat * covMat * halfMat';
            
            nA(h, w) = resMat(1, 1);
            nB(h, w) = resMat(1, 2);
            nC(h, w) = resMat(2, 2);
            
            nXY = (affMat * [nodeX(h, w), nodeY(h, w) 1]')';
            nX(h, w) = nXY(1) / nXY(3);
            nY(h, w) = nXY(2) / nXY(3);
        end
    end

end

