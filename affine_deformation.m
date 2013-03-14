function [ affineMatrix ] = affine_deformation( nodeX, nodeY, a, b, c, alphas, iX, iY, iT )
%AFFINE_DEFORMATION Calculate the affine transformation for the data
%   Calculates a global affine transformation

    [points, grad] = extract_global_data(nodeX, nodeY, a, b, c, alphas, iX, iY, iT);
    
    guess = rand(1, 6) - 0.5;
    
    options = optimset('MaxFunEvals', 5000, 'MaxIter', 5000);
    %ag = lsqnonlin(@affineTrans, guess, [], [], options);
    ag = fminsearch(@affineTrans, guess, options);
    
    affineMatrix = [ag(1) ag(2) ag(3); ag(4) ag(5) ag(6); 0 0 1];

    function [sse] = affineTrans( agg )
        A = [(agg(1)-1) agg(2) agg(3); agg(4) (agg(5)-1) agg(6); 0 0 1];
        displaced = (A * points')';
        sse = sum(displaced .* grad, 2);
        sse = sum(abs(sse));
    end

end

