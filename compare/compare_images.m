source_dir = './source/';
sourceFiles = dir(source_dir);
pre_dir = './predicted/';
predictedFiles = dir(pre_dir);
mat_dir = './mat/';
matFiles = dir(mat_dir);
outfolder = './output/';

figure;
hold on;
for idx = 3:length(sourceFiles)
    load(strcat(mat_dir, matFiles(idx).name));
    source = imread(strcat(source_dir, sourceFiles(idx).name), 'PNG');
    predicted = imread(strcat(pre_dir, predictedFiles(idx).name), 'PNG');
    s_edge = uint8(edge(source, 'canny') * 255);
    p_edge = uint8(edge(predicted, 'canny') * 255);
    res = uint8(cat(3, p_edge, s_edge, s_edge));
    sX = floor((nodeX(1,1) - 60));
    sY = floor(nodeY(size(nodeY,1),1) - 60);
    res = res(sY:(sY+215), sX:(sX+348),:);
    imshow(res);
    drawnow;
    pause(2);
    imwrite(res, strcat(outfolder, sprintf('frame_%05d.png', idx-2)), 'PNG');
end