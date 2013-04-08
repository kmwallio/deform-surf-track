source_image = 'source.png';

% Source Image should be the first frame with the overlayed image
% present.

target_dir = './frames-min/';
target_data = './input/'; % There should be a 1-to-1 numbering of files
output_dir = './output_mapped/';


% Work the magic?
inputFiles = dir(target_data);
frameFiles = dir(target_dir);

sourceImg = imread(source_image, 'PNG');
load(strcat(target_data, inputFiles(3).name));

nodeXO = nodeX;
nodeYO = nodeY;
aO = a;
bO = b;
cO = c;
alphasO = alphas;
figure;
hold on;
for idx = 3:length(inputFiles)
    myBar = waitbar(0, 'Processing');
    disp(strcat('On frame: ', num2str(idx - 2)));
    targetImg = imread(strcat(target_dir, frameFiles(idx).name), 'PNG');
    load(strcat(target_data, inputFiles(idx).name));
    width = size(targetImg, 2);
    height = size(targetImg, 1);
    
    
    coverage = get_coverage_matrices( nodeX, nodeY, a, b, c, alphas, targetImg, targetImg, targetImg );
    covMat = sum(coverage, 3) >= 1;
    
    [mW, mH] = meshgrid(1:1:width, 1:1:height);
    mW = mW .* covMat;
    mH = mH .* covMat;
    
    endH = max(max(mH));
    mH(mH==0) = endH;
    startH = min(min(mH));
    endW = max(max(mW));
    mW(mW==0) = endW;
    startW = min(min(mW));
    
    
    for h = startH:endH
        for w = startW:endW
            donep = ((h-1) * width + w) / (width * height);
            waitbar(donep, myBar, sprintf('%0.04f%%', donep * 100));
            [tX, tY] = blend_map( w, h, nodeXO, nodeYO, aO, bO, cO, alphasO, nodeX, nodeY, a, b, c, alphas );
            tX = round(tX);
            tY = round(tY);
            if tX > 0 && tX < width && tY > 0 && tY < height
                sourceCol = sourceImg(tY,tX,:);
                if sourceCol(:,:,2) ~= 255
                    targetImg(h, w, :) = sourceCol;
                    imshow(targetImg);
                    drawnow;
                end
            end
        end
    end
    close(myBar);
    imshow(targetImg);
    drawnow;
    imwrite(targetImg, strcat(output_dir,sprintf('frame_%05d.png', idx - 2)), 'png');
end