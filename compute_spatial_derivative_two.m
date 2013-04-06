function [ iX, iY, iT ] = compute_spatial_derivative_two( image_one, image_two )
%COMPUTE_SPATIAL_DERIVATIVE Computes the spatial derivative on a series of
%frames
%   Computes the spatial derivative using Sobel Filters
    
    % Spatial Derivatives in each direction
    iX = conv2(image_one,0.25* [-1 1; -1 1],'same') + conv2(image_two, 0.25*[-1 1; -1 1],'same');
    iY = conv2(image_one, 0.25*[-1 -1; 1 1], 'same') + conv2(image_two, 0.25*[-1 -1; 1 1], 'same');
    iT = conv2(image_one, 0.25*ones(2),'same') + conv2(image_two, -0.25*ones(2),'same');

end

