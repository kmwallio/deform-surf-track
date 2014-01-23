% Read in the video frames
frameFiles = dir('./frames-min');
outfolder = './output';

numFrames = length(frameFiles);

vidWidth = 640;
vidHeight = 480;

fullFrames = zeros(vidHeight, vidWidth, numFrames);
halfFrames = zeros(vidHeight / 2, vidWidth / 2, numFrames);
quarterFrames = zeros(vidHeight / 4, vidWidth / 4, numFrames);
eighthFrames = zeros(vidHeight / 8, vidWidth / 8, numFrames);

disp('Loading Images');

for idx = 3:length(frameFiles)
    rgbimg = imread(strcat('./frames-min/', frameFiles(idx).name), 'PNG');
    
    % Convert to black and white
    gray = (sum(rgbimg, 3) / 3) / 255;
    
    fullFrames(:,:,idx - 2) = gray;
    halfFrames(:,:,idx - 2) = (sum(imresize_old(rgbimg, 0.5), 3) / 3) / 255;
    quarterFrames(:,:,idx - 2) = (sum(imresize_old(rgbimg, 0.25), 3) / 3) / 255;
    eighthFrames(:,:,idx - 2) = (sum(imresize_old(rgbimg, 0.125), 3) / 3) / 255;
end

disp('Calculating Spatial Derivatives');

[iX, iY, iT] = compute_spatial_derivative(fullFrames);
[i2X, i2Y, i2T] = compute_spatial_derivative(halfFrames);
[i4X, i4Y, i4T] = compute_spatial_derivative(quarterFrames);
[i8X, i8Y, i8T] = compute_spatial_derivative(eighthFrames);

figure;
disp('Processing video...');
%mm = VideoWriter('mesh_deformation.avi');
%open(mm);

%Create the inital placement for the model
% xMax = 430;
% xMin = 180;
% xStep = (xMax - xMin) / 6;
% yMax = 330;
% yMin = 218;
% yStep = (yMin - yMax) / 4;

xMax = 410;
xMin = 200;
xStep = (xMax - xMin) / 3;
yMax = 310;
yMin = 228;
yStep = (yMin - yMax) / 2;

% Meshgrid returns a set of points, we use these points as the
% center of our nodes
[nodeX, nodeY] = meshgrid(xMin:xStep:xMax, yMax:yStep:yMin);
thetas = zeros(size(nodeX));
sigmaX = repmat(abs(xStep / 2.6), size(nodeX));
sigmaY = repmat(abs(yStep / 2), size(nodeX));
alphas = ones(size(nodeX));

cosSQtheta = cos(thetas).^2;
sinSQtheta = sin(thetas).^2;
sin2theta = 2 * sin(thetas);

sigmaX2 = 2 * (sigmaX .^ 2);
sigmaY2 = 2 * (sigmaY .^ 2);

a = (cosSQtheta ./ sigmaX2) + (sinSQtheta ./ sigmaY2);
b = (-sin2theta ./ (2 * sigmaX2)) + (sin2theta ./ (2 * sigmaY2));
c = (sinSQtheta ./ sigmaX2) + (cosSQtheta ./ sigmaY2);
affMat = 0;
affMats = 0;
dX = 0;
dY = 0;

warpedImageFull = fullFrames(:,:,1);
% Track the deformation
for curFrame = 1:numFrames-2
    warpedImage = imresize_old(warpedImageFull, 0.5);
    warpedImageMicro = imresize_old(warpedImageFull, 0.25);
    [i4X(:,:,curFrame), i4Y(:,:,curFrame), i4T(:,:,curFrame)] = compute_spatial_derivative_two(warpedImageMicro, quarterFrames(:,:,curFrame + 1));
    
    disp(strcat('On frame: ', num2str(curFrame)));
    display_model(nodeX, nodeY, a, b, c, alphas, fullFrames(:,:,curFrame));%imread(strcat('./frames-min/',frameFiles(2 + curFrame).name)));
    imwrite(fullFrames(:,:,curFrame), strcat(outfolder,'/',sprintf('orig_%05d.png', curFrame)), 'png');
    drawnow;
    %writeVideo(mm, getframe);
    save(strcat(outfolder,'/',sprintf('frame_%05d.mat', curFrame)), 'nodeX','nodeY','a','b','c','alphas','affMats','affMat','dX','dY');
    F = getframe;
    imwrite(F.cdata, strcat(outfolder,'/',sprintf('frame_%05d.png', curFrame)), 'png');
    imwrite(warpedImageFull, strcat(outfolder,'/',sprintf('prog_warp_%05d.png', curFrame)), 'png');
    
    % Store "original"
    nodeXO = nodeX;
    nodeYO = nodeY;
    aO = a;
    bO = b;
    cO = c;
    alphasO = alphas;
    
    % Calculate the Global Deformation
    disp('  Global Deformation');
    [nodeX, nodeY, a, b, c, alphas] = resize_model(nodeX, nodeY, a, b, c, alphas, 1/4);
    [dX, dY] = global_deformation(nodeX, nodeY, a, b, c, alphas, i4X(:,:,curFrame), i4Y(:,:,curFrame), i4T(:,:,curFrame));
    nodeX = nodeX + dX;
    nodeY = nodeY + dY;
    
    % Compute Warped image and new spatial derivative
    warpedImage = imtransform(warpedImage, maketform('affine', [1 0 (2*dX); 0 1 (2*dY); 0 0 1]'), 'XData', [1 size(halfFrames, 2)], 'YData', [1 size(halfFrames, 1)]);
    warpedImageFull = imtransform(warpedImageFull, maketform('affine', [1 0 (4*dX); 0 1 (4*dY); 0 0 1]'), 'XData', [1 size(fullFrames, 2)], 'YData', [1 size(fullFrames, 1)]);
    [i2X(:,:,curFrame), i2Y(:,:,curFrame), i2T(:,:,curFrame)] = compute_spatial_derivative_two(warpedImage, halfFrames(:,:,curFrame + 1));
    imshow(warpedImageFull);
    drawnow;
    imwrite(warpedImageFull, strcat(outfolder,'/',sprintf('warp_displ_%05d.png', curFrame)), 'png');

    
    % Calculate the Affine Deformation
    disp('  Affine Deformation');
    [nodeX, nodeY, a, b, c, alphas] = resize_model(nodeX, nodeY, a, b, c, alphas, 2);
    affMat = affine_deformation(nodeX, nodeY, a, b, c, alphas, i2X(:,:,curFrame), i2Y(:,:,curFrame), i2T(:,:,curFrame));
    [nodeX, nodeY, a, b, c] = apply_mat_model(nodeX, nodeY, a, b, c, alphas, affMat);
    
    % Compute Warped image and new spatial derivative
    affMat(1, 3) = 2 * affMat(1, 3);
    affMat(2, 3) = 2 * affMat(2, 3);
    warpedImageFull = imtransform(warpedImageFull, maketform('affine', affMat'), 'XData', [1 size(fullFrames, 2)], 'YData', [1 size(fullFrames, 1)]);
    [iX(:,:,curFrame), iY(:,:,curFrame), iT(:,:,curFrame)] = compute_spatial_derivative_two(warpedImageFull, fullFrames(:,:,curFrame + 1));
    imshow(warpedImageFull);
    drawnow;
    imwrite(warpedImageFull, strcat(outfolder,'/',sprintf('warp_aff_%05d.png', curFrame)), 'png');
    
    % Calculate the Elastic Deformation
    [nodeX, nodeY, a, b, c, alphas] = resize_model(nodeX, nodeY, a, b, c, alphas, 2);
    disp('  Elastic Deformation');
    affMats = elastic_deformation(nodeX, nodeY, a, b, c, alphas, iX(:,:,curFrame), iY(:,:,curFrame), iT(:,:,curFrame), 1);
    nodes = size(nodeX, 1) * size(nodeX, 2);
    width = size(nodeX, 2);
    height = size(nodeX, 1);
    for h = 1:height
        for w = 1:height
            idx = ((h - 1) * width) + w;
            affMat = affMats(:,:,idx);
            [nodeX(h, w), nodeY(h, w), a(h, w), b(h, w), c(h, w)] = apply_mat_model(nodeX(h, w), nodeY(h, w), a(h, w), b(h, w), c(h, w), alphas(h, w), affMat);
        end
    end
    
    warpedImageFull = warp_image(warpedImageFull, fullFrames(:,:,curFrame + 1), nodeXO, nodeYO, aO, bO, cO, alphasO, nodeX, nodeY, a, b, c, alphas, affMats, true);
end
%close(mm);