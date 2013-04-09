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
        disp(sprintf('      Contributer %d', i));
        t = maketform('affine', affMats(:,:,i)');
        possibleX(:,:,i) = imtransform(vX, t, 'XData', xdat, 'YData', ydat);
        possibleX(:,:,i) = (possibleX(:,:,i) .* weights(:,:,i)) ./ divBy;
        possibleY(:,:,i) = imtransform(vY, t, 'XData', xdat, 'YData', ydat);
        possibleY(:,:,i) = (possibleY(:,:,i) .* weights(:,:,i)) ./ divBy;
    end
    
    nX = round(sum(possibleX, 3));
    nY = round(sum(possibleY, 3));
    
    disp('      Removing bad x values');
    badX = (nX > 0);
    goodX = size(source, 2);
    badX = badX .* (nX <= goodX);
    nX = nX .* badX;
    disp('      Removing bad y values');
    badY = (nY > 0);
    goodY = size(source, 1);
    badY = badY .* (nX <= goodY);
    nY = nY .* badY;
    disp('      Cleaning up');
    cleanX = (nX == 0);
    cleanX = cleanX .* vX;
    cleanY = (nY == 0);
    cleanY = cleanY .* vY;
    nX = nX + cleanX;
    nY = nY + cleanY;
    disp('      Done...');
end