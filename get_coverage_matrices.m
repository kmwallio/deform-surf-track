function [ coverage, weights ] = get_coverage_matrices( nodeX, nodeY, a, b, c, alphas, iX, iY, iT )
%GET_COVERAGE_MATRICES Calculates the coverage matrices
%   Coverage matrices highlight which points are covered by a node.  This
%   function returns a H x W x N matrix where H is the height of the image,
%   W is the width, and N is the number of nodes.  It is filled with zeros
%   or ones for each point in covered by the node.

    coverage = zeros(size(iX, 1), size(iX, 2), size(nodeX, 1) * size(nodeX, 2));
    weights = zeros(size(iX, 1), size(iX, 2), size(nodeX, 1) * size(nodeX, 2));
    
    nodeH = size(nodeX, 1);
    nodeW = size(nodeX, 2);
    
    [X, Y] = meshgrid(1:size(iY, 2), 1:size(iT, 1));
    
    for curY = 1:nodeH
        for curX = 1:nodeW
            idx = ((curY - 1) * nodeW) + curX;
            
            x0 = nodeX(curY, curX);
            y0 = nodeY(curY, curX);
            A = alphas(curY, curX);
            a0 = a(curY, curX);
            b0 = b(curY, curX);
            c0 = c(curY, curX);
            
            Z = exp( - (a0*(X-x0).^2 + 2*b0*(X-x0).*(Y-y0) + c0*(Y-y0).^2));
            weights(:,:,idx) = Z;
            coverage(:,:,idx) = (Z > 0.05);
        end
    end
end

