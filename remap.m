source_image = 'source.png';

% Source Image should be the first frame with the overlayed image
% present.

target_dir = './frames/';
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

for idx = 3:length(inputFiles)
    myBar = waitbar(0, 'Processing');
    disp(strcat('On frame: ', num2str(idx - 2)));
    targetImg = imread(strcat(target_dir, frameFiles(idx).name), 'PNG');
    load(strcat(target_data, inputFiles(idx).name));
    width = size(targetImg, 2);
    height = size(targetImg, 1);
    for h = 1:height
        for w = 1:width
            donep = ((h-1) * width + w) / (width * height);
            waitbar(donep, myBar, sprintf('%0.04f%%', donep * 100));
            [tX, tY] = blend_map( w, h, nodeXO, nodeYO, aO, bO, cO, alphasO, nodeX, nodeY, a, b, c, alphas );
            tX = round(tX);
            tY = round(tY);
            if tX > 0 && tX < width && tY > 0 && tY < height
                sourceCol = sourceImg(tY,tX,:);
                if sourceCol(:,:,2) ~= 255
                    targetImg(h, w, :) = sourceCol;
                end
            end
        end
    end
    close(myBar);
    imshow(targetImg);
    drawnow;
    imwrite(targetImg, strcat(output_dir,sprintf('frame_%05d.png', idx - 2)), 'png');
end