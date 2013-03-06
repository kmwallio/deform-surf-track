function [ iX, iY, iT ] = compute_spatial_derivative( image_sequence )
%COMPUTE_SPATIAL_DERIVATIVE Computes the spatial derivative on a series of
%frames
%   Computes the spatial derivative using Sobel Filters

    % Number of frames
    sizes = size(image_sequence);
    
    % Spatial Derivatives in each direction
    iX = zeros(sizes(1), sizes(2), sizes(3) - 1);
    iY = zeros(sizes(1), sizes(2), sizes(3) - 1);
    iT = zeros(sizes(1), sizes(2), sizes(3) - 1);
    
    for frame = 1:sizes(3)-1
        iX(:,:,frame) = conv2(image_sequence(:, :, frame),0.25* [-1 1; -1 1],'same') + conv2(image_sequence(:, :, frame + 1), 0.25*[-1 1; -1 1],'same');
        iY(:,:,frame) = conv2(image_sequence(:, :, frame), 0.25*[-1 -1; 1 1], 'same') + conv2(image_sequence(:, :, frame + 1), 0.25*[-1 -1; 1 1], 'same');
        iT(:,:,frame) = conv2(image_sequence(:, :, frame), 0.25*ones(2),'same') + conv2(image_sequence(:, :, frame + 1), -0.25*ones(2),'same');
    end
end

