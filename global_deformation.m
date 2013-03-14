function [ dX, dY ] = global_deformation( nodeX, nodeY, a, b, c, alphas, iX, iY, iT )
%GLOBAL_DEFORMATION Calculates global deformation
%   Given the data, find the best dX dY that can be applied to all of the
%   nodes centers

    [~, grad] = extract_global_data(nodeX, nodeY, a, b, c, alphas, iX, iY, iT);
    
    guess = rand(1, 2) - 0.5;
    
    options = optimset('MaxFunEvals', 5000, 'MaxIter', 5000);
    %s = lsqnonlin(@globalTrans, guess, [], [], options);
    s = fminsearch(@globalTrans, guess, options);
    
    dX = s(1);
    dY = s(2);
    
    function [sse] = globalTrans(a)
        displaced = [a(1) a(2) 1]';
        sse = sum(grad * displaced, 2);
        sse = sum(abs(sse));
    end

end

