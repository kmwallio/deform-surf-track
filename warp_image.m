function [ warped ] = warp_image( source, target, nodeXO, nodeYO, aO, bO, cO, alphasO, nodeX, nodeY, a, b, c, alphas, affMats )
%WARP_IMAGE Warps an image
    
    warped = source;
    disp('  Finding weights');
    [~, weights] = get_coverage_matrices( nodeXO, nodeYO, aO, bO, cO, alphasO, warped, warped, warped );
    [coverageT, ~] = get_coverage_matrices( nodeX, nodeY, a, b, c, alphas, warped, warped, warped );
    coverageT = sum(coverageT, 3) >= 1;
    
    disp('  Finding weighted transform');
    [nX, nY] = warp_aff(source, affMats, weights);
    
    [vX, vY] = meshgrid(1:size(source,2), 1:size(source,1));
    disp('  Moving things into place');
    warped(vY, vX, :) = source(nY, nX, :);
    disp('  Placing onto target');
    warped = (warped .* coverageT) + (target .* (coverageT == 0));
end