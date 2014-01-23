function [ x, y ] = blend_map( xS, yS, nodeXO, nodeYO, aO, bO, cO, alphasO, nodeX, nodeY, a, b, c, alphas )
%Given a set of nodes and an X-Y coordinate, find the corresponding pixel
%on the original frames

    nodeH = size(nodeYO, 1);
    nodeW = size(nodeXO, 2);
    nodes = nodeH * nodeW;
    
    avgX = (sum(sum(nodeX)) / nodes) - (sum(sum(nodeXO)) / nodes);
    avgY = (sum(sum(nodeY)) / nodes) - (sum(sum(nodeXO)) / nodes);
    
    guess = [(xS - avgX) (yS - avgY)];
    [f, s] = fminsearch(@to_min, guess);
    disp(s);
    x = f(1);
    y = f(2);
    
    function [sse] = to_min(gss)
        sse = zeros(nodeH * nodeW, 1);
        for h = 1:nodeH
            for w = 1:nodeW
                idx = ((h - 1) * nodeW) + w;
                sse(idx) = abs((500 * g_conf(xS, yS, nodeX(h, w), nodeY(h, w), a(h, w), b(h, w), c(h, w), alphas(h, w))) - (500 * g_conf(gss(1), gss(2), nodeXO(h, w), nodeYO(h, w), aO(h, w), bO(h, w), cO(h, w), alphasO(h, w))));
            end
        end
        sse = sum(sse);
    end
    
%     divider = g_conf(xS, yS, nodeX, nodeY, a, b, c, alphas);
%     
%     % A weighted vote for where the point should be
%     for h = 1:nodeH
%         for w = 1:nodeW
%             numer = g_conf(xS, yS, nodeX(h, w), nodeY(h, w), a(h, w), b(h, w), c(h, w), alphas(h, w));
%             % We convert the coordinate to the coordinate system
%             % of the gaussian distribution
%             orgMat = [aO(h, w) bO(h, w); bO(h, w) cO(h, w)];
%             covMat = [a(h, w) b(h, w); b(h, w) c(h, w)];
%             
%             [cEig, cEigg] = eig(covMat);
%             mEh = [xS yS] - [nodeX(h, w) nodeY(h, w)];
%             mEh = cEig' * mEh';
%             
%             [oEig, oEigg] = eig(orgMat);
%             mEg = (inv(oEig) * mEh) + [nodeXO(h, w) nodeYO(h, w)]';
%             
%             x = x + (mEg(1) * (numer / divider));
%             y = y + (mEg(2) * (numer / divider));
%         end
%     end

end

