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
    lambda = 100;
    
    coverage = get_coverage_matrices( nodeX, nodeY, a, b, c, alphas, iX, iY, iT );
    goodGrad = ((iX + iY + iT) > 0);
    avgmat = sum(coverage, 3) .* goodGrad;
    gradmat = get_grad_mat(avgmat, iX, iY, iT);
    g = randn(2, 3 * nodes);
    
    options = optimset('MaxFunEvals', 5000, 'MaxIter', 5000);
    ag = lsqnonlin(@elasticity, g, [], [], options);
    [affMats, ~] = to_affine(ag);
    
    function [sse] = elasticity(guess)
        sse = [find_mat(guess); frobbb(guess)];
        
        function [ssee] = find_mat(guesss)
            [~, dmat] = to_affine(guesss);
            dis_mat = zeros(size(gradmat));
            i = 1;
            for h = 1:imheight
                for w = 1:imwidth
                    if avgmat(h, w) > 0.5
                        div_mat = 0;
                        for n = 1:nodes
                            if coverage(h, w, n) > 0.5
                                disvec = dmat(:,:,n) * [w h 1]';
                                dis_mat(i, :) = dis_mat(i,:) + disvec';
                                div_mat = div_mat + 1;
                            end
                        end
                        dis_mat(i, :) = dis_mat(i, :) / div_mat;
                        i = i + 1;
                    end
                end
            end

            ssee = sum(gradmat .* dis_mat, 2);
        end
        
        function [ssee] = frobbb(guesss)
            [amat, ~] = to_affine(guesss);
            alen = size(amat, 3);
            ssee = zeros(alen, 1);
            for i = 1:alen
                ssee(i) = lambda * norm(amat(:,:,i) - eye(3, 3), 'fro');
            end
        end
    end
end

