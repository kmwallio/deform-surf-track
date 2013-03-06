% Read in the video frames
frameFiles = dir('./frames');

numFrames = size(frameFiles, 1);

vidWidth = 640;
vidHeight = 480;

fullFrames = zeros(vidHeight, vidWidth, numFrames);
halfFrames = zeros(vidHeight / 2, vidWidth / 2, numFrames);
quarterFrames = zeros(vidHeight / 4, vidWidth / 4, numFrames);
eighthFrames = zeros(vidHeight / 8, vidWidth / 8, numFrames);

disp('Loading Images');

for idx = 3:length(frameFiles)
    rgbimg = imread(strcat('./frames/', frameFiles(idx).name), 'PNG');
    
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
mm = VideoWriter('mesh_deformation.avi');
open(mm);

% Create the inital placement for the model
xMax = 418;
xMin = 103;
xStep = (xMax - xMin) / 20;
yMax = 354;
yMin = 171;
yStep = (yMin - yMax) / 16;

% Meshgrid returns a set of points, we use these points as the
% center of our nodes
[nodeX, nodeY] = meshgrid(xMin:xStep:xMax, yMax:yStep:yMin);
thetas = zeros(size(nodeX));
sigmaX = repmat(abs(xStep / 2), size(nodeX));
sigmaY = repmat(abs(yStep / 2), size(nodeX));
alphas = ones(size(nodeX));

% Track the deformation
for curFrame = 1:1%numFrames-2
    disp(strcat('On frame: ', num2str(curFrame)));
    display_model(nodeX, nodeY, sigmaX, sigmaY, thetas, alphas, imread(strcat('./frames/',frameFiles(2 + curFrame).name)));
    drawnow;
    writeVideo(mm, getframe);
    
    % Calculate the Global Deformation
    disp('  Global Deformation');

    
    % Calculate the Affine Deformation
    disp('  Affine Deformation');

    
    % Calculate the Elastic Deformation
    disp('  Elastic Deformation');
end