function [ warped ] = warp_image( source, target, nodeXO, nodeYO, aO, bO, cO, alphasO, nodeX, nodeY, a, b, c, alphas, affMats )
%WARP_IMAGE Warps an image
    
    warped = source;
    disp('  Finding weights');
    [~, weights] = get_coverage_matrices( nodeXO, nodeYO, aO, bO, cO, alphasO, warped, warped, warped );
    [coverageT, ~] = get_coverage_matrices( nodeX, nodeY, a, b, c, alphas, warped, warped, warped );
    coverageT = sum(coverageT, 3) >= 1;
    
    disp('  Finding weighted transform');
    [nX, nY] = warp_aff(source, affMats, weights);
    
%    [vX, vY] = meshgrid(1:size(source,2), 1:size(source,1));
    disp('  Moving things into place');
    
    width = size(source, 2);
    height = size(source, 1);
    
    for h = 1:height
        for w = 1:width
            warped(h, w, :) = source(nY(h, w), nX(h, w), :);
%             if coverageT(h, w) == 0
%                 warped(h, w) = target(h, w);
%             end
        end
    end
    disp('  Placing onto target');
end