% Read in the video frames
frameFiles = dir('./frames-min');
outfolder = './output';

numberOfFrames = length(frameFiles);

vidWidth = 640;
vidHeight = 480;

fullFrames = zeros(vidHeight, vidWidth, numberOfFrames);
halfFrames = zeros(vidHeight / 2, vidWidth / 2, numberOfFrames);
quarterFrames = zeros(vidHeight / 4, vidWidth / 4, numberOfFrames);
eighthFrames = zeros(vidHeight / 8, vidWidth / 8, numberOfFrames);

disp('Loading Images');

for idx = 3:length(frameFiles)
    rgbimg = imread(strcat('./frames-min/', frameFiles(idx).name), 'PNG');
    
    % Convert to black and white
    gray = (sum(rgbimg, 3) / 3);
    
    fullFrames(:,:,idx - 2) = gray;
    halfFrames(:,:,idx - 2) = (sum(imresize_old(rgbimg, 0.5), 3) / 3);
    quarterFrames(:,:,idx - 2) = (sum(imresize_old(rgbimg, 0.25), 3) / 3);
    eighthFrames(:,:,idx - 2) = (sum(imresize_old(rgbimg, 0.125), 3) / 3);
end

disp('Calculating Spatial Derivatives');

[iX, iY, iT] = compute_spatial_derivative(fullFrames);
[i2X, i2Y, i2T] = compute_spatial_derivative(halfFrames);
[i4X, i4Y, i4T] = compute_spatial_derivative(quarterFrames);
[i8X, i8Y, i8T] = compute_spatial_derivative(eighthFrames);

figure;
disp('Processing video...');
mm = VideoWriter('mesh_deformation.avi');
open(mm);

% Create the inital placement for the model
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
sigmaX = repmat(abs(xStep / 3.4), size(nodeX));
sigmaY = repmat(abs(yStep / 2.4), size(nodeX));
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

% Track the deformation
for curFrame = 1:(numberOfFrames - 2)
    disp(strcat('On frame: ', num2str(curFrame)));
    display_model(nodeX, nodeY, a, b, c, alphas, imread(strcat('./frames-min/',frameFiles(2 + curFrame).name)));
    drawnow;
    writeVideo(mm, getframe);
    save(strcat(outfolder,'/',sprintf('frame_%05d.mat', curFrame)), 'nodeX','nodeY','a','b','c','alphas','affMats','affMat','dX','dY');
    F = getframe;
    imwrite(F.cdata, strcat(outfolder,'/',sprintf('frame_%05d.png', curFrame)), 'png');
    
    % Calculate the Global Deformation
    disp('  Global Deformation');
    [nodeX, nodeY, a, b, c, alphas] = resize_model(nodeX, nodeY, a, b, c, alphas, 1/4);
    [dX, dY] = global_deformation(nodeX, nodeY, a, b, c, alphas, i4X(:,:,curFrame), i4Y(:,:,curFrame), i4T(:,:,curFrame));
    nodeX = nodeX + dX;
    nodeY = nodeY + dY;

    
    % Calculate the Affine Deformation
    disp('  Affine Deformation');
    [nodeX, nodeY, a, b, c, alphas] = resize_model(nodeX, nodeY, a, b, c, alphas, 2);
    affMat = affine_deformation(nodeX, nodeY, a, b, c, alphas, i2X(:,:,curFrame), i2Y(:,:,curFrame), i2T(:,:,curFrame));
    [nodeX, nodeY, a, b, c] = apply_mat_model(nodeX, nodeY, a, b, c, alphas, affMat);

    
    % Calculate the Elastic Deformation
    [nodeX, nodeY, a, b, c, alphas] = resize_model(nodeX, nodeY, a, b, c, alphas, 2);
    disp('  Elastic Deformation');
    affMats = elastic_deformation(nodeX, nodeY, a, b, c, alphas, iX(:,:,curFrame), iY(:,:,curFrame), iT(:,:,curFrame));
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
end
close(mm);