function [ affMats ] = elastic_deformation( nodeX, nodeY, a, b, c, alphas, iX, iY, iT )
%ELASTIC_DEFORMATION Calculates the elastic deformaion for the model from
%the data
%   Calculates an affine transformation for each node and smooths the
%   results by comparing each transformation to its neighbors (overlapping
%   nodes)

    nodes = size(nodeX, 1) * size(nodeX, 2);
    affMats = zeros(3, 3, nodes);
    
    width = size(nodeX, 2);
    height = size(nodeX, 1);
    
    for h = 1:height
        for w = 1:height
            idx = ((h - 1) * width) + w;
            affMats(:,:,idx) = affine_deformation(nodeX(h, w), nodeY(h, w), a(h, w), b(h, w), c(h, w), alphas(h, w), iX, iY, iT);
        end
    end

end

