function [ affMats ] = elastic_deformation( nodeX, nodeY, a, b, c, alphas, iX, iY, iT )
%ELASTIC_DEFORMATION Calculates the elastic deformaion for the model from
%the data
%   Calculates an affine transformation for each node and smooths the
%   results by comparing each transformation to its neighbors (overlapping
%   nodes)

    nodes = size(nodeX, 1) * size(nodeX, 2);
    
    width = size(nodeX, 2);
    height = size(nodeX, 1);
    imwidth = size(iX, 2);
    imheight = size(iY, 1);
    lambda = 10;
    
    coverage = get_coverage_matrices( nodeX, nodeY, a, b, c, alphas, iX, iY, iT );
    avgmat = sum(coverage, 3);
    gradmat = get_grad_mat(avgmat, iX, iY, iT);
    g = randn(2, 3 * nodes);
    
    options = optimset('MaxFunEvals', 5000, 'MaxIter', 5000);
    ag = lsqnonlin(@elasticity, g, [], [], options);
    [affMats, ~] = to_affine(ag);
    
    function [sse] = elasticity(guess)
        [amat, dmat] = to_affine(guess);
        dis_mat = zeros(size(gradmat));
        div_mat = zeros(size(gradmat,1), 1);
        
        for h = 1:imheight
            for w = 1:imwidth
                if contrib(h, w) > 0.5
                    for n = 1:nodes
                        if coverage(h, w, n) > 0.5
                            disvec = dmat(:,:,n) * [w h 1];
                            dis_mat(i, :) = dis_mat(i,:) + disvec';
                            div_mat(i) = div_mat(i) + 1;
                            i = i + 1;
                        end
                    end
                end
            end
        end
        
        dis_mat = dis_mat ./ div_mat;
        
        sse = sum(gradmat .* dis_mat, 2);
        
        reg = sqrt(lambda * frob(amat));
        
        sse(size(sse, 1)) = reg;
    end
    
%     for h = 1:height
%         for w = 1:width
%             idx = ((h - 1) * width) + w;
%             affMats(:,:,idx) = affine_deformation(nodeX(h, w), nodeY(h, w), a(h, w), b(h, w), c(h, w), alphas(h, w), iX, iY, iT);
%         end
%     end

end

