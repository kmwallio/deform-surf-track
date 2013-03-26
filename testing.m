function [est] = testing( )
    
    xP = rand(100, 1);
    yP = f(xP);
    
    guess = randn(2, 2, 2);
    
    options = optimset('MaxFunEvals', 5000, 'MaxIter', 5000);
    est = lsqnonlin(@fitf, guess, [], [], options);
    
    function [sse] = fitf(guess)
        a = guess(1, 1);
        b = guess(1, 2);
        c = guess(2, 1);
        d = guess(2, 2);
        a2 = guess(1, 3);
        b2 = guess(1, 4);
        c2 = guess(2, 3);
        d2 = guess(2, 4);
        
        yG = (a * xP) + (b * (xP .^ 2)) + (c * (xP .^ 3)) + (d * (xP .^ 4));
        yG2 = (d2 * xP) + (b2 * (xP .^ 2)) + (c2 * (xP .^ 3)) + (a2 * (xP .^ 4));
        sse = [(yG - yP) (yG2 - yP)];
    end
    
    function [y] = f(x)
        y = (2 * x) + (5 * (x .^ 2)) + (3 * (x .^ 3)) + (1 * (x .^ 4));
    end

end

