function [ nX, nY ] = warp_aff( source, affMats, weights )
%WARP_AFF Given a set of affine matrices, find the new X Y locations

    possibleX = zeros([size(source, 1) size(source,2) size(affMats, 3)]);
    possibleY = zeros([size(source, 1) size(source,2) size(affMats, 3)]);
    divBy = sum(weights, 3);
    
    [vX, vY] = meshgrid(1:size(source,2), 1:size(source,1));
    
    xdat = [1 size(source, 2)];
    ydat = [1 size(source, 1)];
    
    affMatsS = size(affMats, 3);
    for i = 1:affMatsS
        fprintf('      Contributer %d%n', i);
        t = maketform('affine', affMats(:,:,i)');
        possibleX(:,:,i) = imtransform(vX, t, 'XData', xdat, 'YData', ydat);
        possibleX(:,:,i) = (possibleX(:,:,i) .* weights(:,:,i)) ./ divBy;
        possibleY(:,:,i) = imtransform(vY, t, 'XData', xdat, 'YData', ydat);
        possibleY(:,:,i) = (possibleY(:,:,i) .* weights(:,:,i)) ./ divBy;
    end
    
    nX = round(sum(possibleX, 3));
    nY = round(sum(possibleY, 3));
    
    disp('      Removing bad values');
    nX = nX .* (nX > 0) .* (nX <= size(source, 2));
    nY = nY .* (nY > 0) .* (nY <= size(source, 1));
    nX = nX + ((nX == 0) .* vX);
    nY = nY + ((nY == 0) .* vY);
end