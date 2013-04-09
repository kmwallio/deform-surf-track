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
jdx = 1;
for idx = 4:length(inputFiles)
    imshow(sourceImg);
    drawnow;
    imwrite(sourceImg, strcat(output_dir,sprintf('frame_%05d.png', idx - 3)), 'png');
    jdx = idx - 2;
    
    disp(strcat('On frame: ', num2str(idx - 3)));
    targetImg = imread(strcat(target_dir, frameFiles(idx).name), 'PNG');
    load(strcat(target_data, inputFiles(idx).name));
    
    sourceImg = imtransform(sourceImg, maketform('affine', [1 0 (4*dX); 0 1 (4*dY); 0 0 1]'), 'XData', [1 size(sourceImg, 2)], 'YData', [1 size(sourceImg, 1)]);
    sourceImg = imtransform(sourceImg, maketform('affine', affMat'), 'XData', [1 size(sourceImg, 2)], 'YData', [1 size(sourceImg, 1)]);
    
    sourceImg = warp_image(sourceImg, targetImg, nodeXO, nodeYO, aO, bO, cO, alphasO, nodeX, nodeY, a, b, c, alphas, affMats);
    
    nodeXO = nodeX;
    nodeYO = nodeY;
    aO = a;
    bO = b;
    cO = c;
    alphasO = alphas;
end
imwrite(sourceImg, strcat(output_dir,sprintf('frame_%05d.png', jdx)), 'png');