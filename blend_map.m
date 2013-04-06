function [ x, y ] = blend_map( xS, yS, nodeXO, nodeYO, aO, bO, cO, alphasO, nodeX, nodeY, a, b, c, alphas )
%Given a set of nodes and an X-Y coordinate, find the corresponding pixel
%on the original frames

    nodeH = size(nodeYO, 1);
    nodeW = size(nodeXO, 2);
    
    x = 0;
    y = 0;
    
    divider = g_conf(xS, yS, nodeX, nodeY, a, b, c, alphas);
    
    % A weighted vote for where the point should be
    for h = 1:nodeH
        for w = 1:nodeW
            numer = g_conf(xS, yS, nodeX(h, w), nodeY(h, w), a(h, w), b(h, w), c(h, w), alphas(h, w));
            % We convert the coordinate to the coordinate system
            % of the gaussian distribution
            orgMat = [aO(h, w) bO(h, w); bO(h, w) cO(h, w)];
            covMat = [a(h, w) b(h, w); b(h, w) c(h, w)];
            
            [cEig, cEigg] = eig(covMat);
            mEh = [xS yS] - [nodeX(h, w) nodeY(h, w)];
            mEh = cEig' * mEh';
            
            [oEig, oEigg] = eig(orgMat);
            mEg = (inv(oEig) * mEh) + [nodeXO(h, w) nodeYO(h, w)]';
            
            x = x + (mEg(1) * (numer / divider));
            y = y + (mEg(2) * (numer / divider));
        end
    end

end

