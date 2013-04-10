lambdas = [10 100 500];

in_dir = './frames-3drot/';

frameFiles = dir(in_dir);
for lambda = lambdas
    % 12 nodes
    xMax = 465;
    xMin = 305;
    xStep = (xMax - xMin) / 3;
    yMax = 280;
    yMin = 188;
    yStep = (yMin - yMax) / 2;

    [nodeX, nodeY] = meshgrid(xMin:xStep:xMax, yMax:yStep:yMin);
    thetas = zeros(size(nodeX));
    sigmaX = repmat(abs(xStep / 2.6), size(nodeX));
    sigmaY = repmat(abs(yStep / 2), size(nodeX));
    alphas = ones(size(nodeX));

    cosSQtheta = cos(thetas).^2;
    sinSQtheta = sin(thetas).^2;
    sin2theta = 2 * sin(thetas);

    sigmaX2 = 2 * (sigmaX .^ 2);
    sigmaY2 = 2 * (sigmaY .^ 2);

    a = (cosSQtheta ./ sigmaX2) + (sinSQtheta ./ sigmaY2);
    b = (-sin2theta ./ (2 * sigmaX2)) + (sin2theta ./ (2 * sigmaY2));
    c = (sinSQtheta ./ sigmaX2) + (cosSQtheta ./ sigmaY2);
    
    test_video( nodeX, nodeY, a, b, c, alphas, lambda, in_dir, sprintf('./3d-four-%d/', lambda) )

    % 35 nodes
    xMax = 487;
    xMin = 287;
    xStep = (xMax - xMin) / 6;
    yMax = 296;
    yMin = 164;
    yStep = (yMin - yMax) / 4;

    [nodeX, nodeY] = meshgrid(xMin:xStep:xMax, yMax:yStep:yMin);
    thetas = zeros(size(nodeX));
    sigmaX = repmat(abs(xStep / 2.6), size(nodeX));
    sigmaY = repmat(abs(yStep / 2), size(nodeX));
    alphas = ones(size(nodeX));

    cosSQtheta = cos(thetas).^2;
    sinSQtheta = sin(thetas).^2;
    sin2theta = 2 * sin(thetas);

    sigmaX2 = 2 * (sigmaX .^ 2);
    sigmaY2 = 2 * (sigmaY .^ 2);

    a = (cosSQtheta ./ sigmaX2) + (sinSQtheta ./ sigmaY2);
    b = (-sin2theta ./ (2 * sigmaX2)) + (sin2theta ./ (2 * sigmaY2));
    c = (sinSQtheta ./ sigmaX2) + (cosSQtheta ./ sigmaY2);
    
    test_video( nodeX, nodeY, a, b, c, alphas, lambda, in_dir, sprintf('./3d-seven-%d/', lambda) )
end