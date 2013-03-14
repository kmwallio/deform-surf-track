function [ affineMatrix ] = affine_deformation( nodeX, nodeY, a, b, c, alphas, iX, iY, iT )
%AFFINE_DEFORMATION Calculate the affine transformation for the data
%   Calculates a global affine transformation

    [points, grad] = extract_global_data(nodeX, nodeY, a, b, c, alphas, iX, iY, iT);
    
    guess = rand(1, 6) - 0.5;
    
    options = optimset('MaxFunEvals', 5000, 'MaxIter', 5000);
    a = lsqnonlin(@affineTrans, guess, [], [], options);
    
    affineMatrix = [a(1) a(2) a(3); a(4) a(5) a(6); 0 0 1];

    function [sse] = affineTrans( a )
        A = [(a(1)-1) a(2) a(3); a(4) (a(5)-1) a(6); 0 0 1];
        displaced = (A * points')';
        sse = sum(displaced .* grad, 2);
        %sse = sum(abs(sse));
    end

end

