function display_model( nodeX, nodeY, a, b, c, alphas, frame)
%DISPLAY_MODEL Given a model, draw it on the image
%   Given the descriptors of our gaussian model, we draw the resulting
%   model on top of the current frame.
    
    [X, Y] = meshgrid(1:size(frame, 2), 1:size(frame, 1));
    result = zeros(size(frame, 1), size(frame, 2));
    
    sizeY = size(nodeX, 1);
    sizeX = size(nodeX, 2);
    
    for curX = 1:sizeX
        for curY = 1:sizeY
            x0 = nodeX(curY, curX);
            y0 = nodeY(curY, curX);
            A = alphas(curY, curX);
            a0 = a(curY, curX);
            b0 = b(curY, curX);
            c0 = c(curY, curX);
            
            Z = A * exp( - (a0*(X-x0).^2 + 2*b0*(X-x0).*(Y-y0) + c0*(Y-y0).^2));
            result = result + ((Z > 0.04) .* (Z < 0.06));
        end
    end
    
    
    
    thresh = (result > 0) * .7;
    imshow(frame);
    hold on;
    highlighter = cat(3, ones(size(thresh)), zeros(size(thresh)), zeros(size(thresh)));
    h = imshow(highlighter);
    %surf(X,Y,result);
    %shading interp;
    %view(0, 90);
    
    set(h, 'AlphaData', thresh);
    hold off;
end

