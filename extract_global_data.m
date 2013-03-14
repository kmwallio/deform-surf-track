function [ data, iData ] = extract_global_data( nodeX, nodeY, a, b, c, alphas , iX, iY, iT )
%EXTRACT_GLOBAL_DATA Extracts contributing data from the model
%   Given the model, extracts contributing data.  That is data where the
%   spatial derivative is non-zero and the point is contained in the model.
    
    contribute = zeros(size(iX, 1), size(iX, 2));
    
    startY = 1;
    startX = 1;
    endY = size(iX, 1);
    endX = size(iX, 2);
    
    for y = startY:endY
        for x = startX:endX
            if (iX(y, x) + iY(y, x) + iT(y,x) ~= 0) && (in_model(x, y, nodeX, nodeY, a, b, c, alphas))
                contribute(y,x) = 1;
            end
        end
    end
    
    contributing = sum(sum(contribute));
    data = zeros(contributing, 3);
    iData = zeros(contributing, 3);
    
    j = 1;
    for y = startY:endY
        for x = startX:endX
            if contribute(y, x)
                data(j,:) = [x y 1];
                iData(j,:) = [iX(y, x) iY(y,x) iT(y,x)];
                j = j + 1;
            end
        end
    end

end

