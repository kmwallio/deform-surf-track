function test_video( nodeX, nodeY, a, b, c, alphas, lambda, in_dir, out_dir )
%TEST_VIDEO Tests algorithm on video with parameters provided

    mkdir(out_dir);
	
    frameFiles = dir(in_dir);
    
    affMats = 0;
    dX = 0;
    dY = 0;
    affMat = [1 0 0; 0 1 0; 0 0 1];
    
    frames = length(frameFiles);
    fullFrame = double(rgb2gray(imread(strcat(in_dir, frameFiles(3).name)))) / 255;
    
	warpedImageFull = fullFrame;
    warpedImageWindow = fullFrame;
	for curFrame = 3:(frames - 2)
		warpedImage = imresize_old(warpedImageFull, 0.5);
		warpedImageMicro = imresize_old(warpedImageFull, 0.25);
		
		disp(strcat('On frame: ', num2str(curFrame)));
		display_model(nodeX, nodeY, a, b, c, alphas, fullFrame);
		imwrite(fullFrame, strcat(out_dir,'/',sprintf('orig_%05d.png', curFrame)), 'png');
		drawnow;
		%writeVideo(mm, getframe);
		save(strcat(out_dir,'/',sprintf('frame_%05d.mat', curFrame)), 'nodeX','nodeY','a','b','c','alphas','affMats','affMat','dX','dY');
		F = getframe;
		imwrite(F.cdata, strcat(out_dir,'/',sprintf('frame_%05d.png', curFrame)), 'png');
		imwrite(warpedImageFull, strcat(out_dir,'/',sprintf('prog_warp_%05d.png', curFrame)), 'png');
        imwrite(warpedImageWindow, strcat(out_dir,'/',sprintf('window_warp_%05d.png', curFrame)), 'png');
		
		% Store "original"
		nodeXO = nodeX;
		nodeYO = nodeY;
		aO = a;
		bO = b;
		cO = c;
		alphasO = alphas;
        
        fullFrame = double(rgb2gray(imread(strcat(in_dir, frameFiles(curFrame + 1).name)))) / 255;
		halfFrame = imresize_old(fullFrame, 0.25);
		quarterFrame = imresize_old(fullFrame, 0.25);
		
		[i4X, i4Y, i4T] = compute_spatial_derivative_two(warpedImageMicro, quarterFrame);
		
		% Calculate the Global Deformation
		disp('  Global Deformation');
		[nodeX, nodeY, a, b, c, alphas] = resize_model(nodeX, nodeY, a, b, c, alphas, 1/4);
		[dX, dY] = global_deformation(nodeX, nodeY, a, b, c, alphas, i4X, i4Y, i4T);
		nodeX = nodeX + dX;
		nodeY = nodeY + dY;
		
		% Compute Warped image and new spatial derivative
		warpedImage = imtransform(warpedImage, maketform('affine', [1 0 (2*dX); 0 1 (2*dY); 0 0 1]'), 'XData', [1 size(halfFrame, 2)], 'YData', [1 size(halfFrame, 1)]);
		warpedImageFull = imtransform(warpedImageFull, maketform('affine', [1 0 (4*dX); 0 1 (4*dY); 0 0 1]'), 'XData', [1 size(fullFrame, 2)], 'YData', [1 size(fullFrame, 1)]);
		[i2X, i2Y, i2T] = compute_spatial_derivative_two(warpedImage, halfFrame);
		imshow(warpedImageFull);
		drawnow;
		imwrite(warpedImageFull, strcat(out_dir,'/',sprintf('warp_displ_%05d.png', curFrame)), 'png');
		
		
		% Calculate the Affine Deformation
		disp('  Affine Deformation');
		[nodeX, nodeY, a, b, c, alphas] = resize_model(nodeX, nodeY, a, b, c, alphas, 2);
		affMat = affine_deformation(nodeX, nodeY, a, b, c, alphas, i2X, i2Y, i2T);
		[nodeX, nodeY, a, b, c] = apply_mat_model(nodeX, nodeY, a, b, c, alphas, affMat);
		
		% Compute Warped image and new spatial derivative
		affMat(1, 3) = 2 * affMat(1, 3);
		affMat(2, 3) = 2 * affMat(2, 3);
		warpedImageFull = imtransform(warpedImageFull, maketform('affine', affMat'), 'XData', [1 size(fullFrame, 2)], 'YData', [1 size(fullFrame, 1)]);
		[iX, iY, iT] = compute_spatial_derivative_two(warpedImageFull, fullFrame);
		imshow(warpedImageFull);
		drawnow;
		imwrite(warpedImageFull, strcat(out_dir,'/',sprintf('warp_aff_%05d.png', curFrame)), 'png');
		
		% Calculate the Elastic Deformation
		[nodeX, nodeY, a, b, c, alphas] = resize_model(nodeX, nodeY, a, b, c, alphas, 2);
		disp('  Elastic Deformation');
		affMats = elastic_deformation(nodeX, nodeY, a, b, c, alphas, iX, iY, iT, lambda);
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
		
		warpedImageFull = warp_image(warpedImageFull, fullFrame, nodeXO, nodeYO, aO, bO, cO, alphasO, nodeX, nodeY, a, b, c, alphas, affMats, false);
        warpedImageWindow =  warp_image(warpedImageFull, fullFrame, nodeXO, nodeYO, aO, bO, cO, alphasO, nodeX, nodeY, a, b, c, alphas, affMats, true);
	end
    
end
