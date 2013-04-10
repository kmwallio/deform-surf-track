lambdas = [0, 1, 10, 100, 500];
fid = fopen('synres.txt','a+');
for lambda = lambdas
    fprintf(fid,'Lambda = %d', lambda);
    % Create the inital placement for the model
    xMax = 280;
    xMin = 80;
    xStep = (xMax - xMin) / 3;
    yMax = 200;
    yMin = 90;
    yStep = (yMin - yMax) / 1;

    % Meshgrid returns a set of points, we use these points as the
    % center of our nodes
    [nodeX, nodeY] = meshgrid(xMin:xStep:xMax, yMax:yStep:yMin);
    thetas = zeros(size(nodeX));
    sigmaX = repmat(abs(xStep / 2.4), size(nodeX));
    sigmaY = repmat(abs(yStep / 3.4), size(nodeX));
    alphas = ones(size(nodeX));

    cosSQtheta = cos(thetas).^2;
    sinSQtheta = sin(thetas).^2;
    sin2theta = 2 * sin(thetas);

    sigmaX2 = 2 * (sigmaX .^ 2);
    sigmaY2 = 2 * (sigmaY .^ 2);

    a = (cosSQtheta ./ sigmaX2) + (sinSQtheta ./ sigmaY2);
    b = (-sin2theta ./ (2 * sigmaX2)) + (sin2theta ./ (2 * sigmaY2));
    c = (sinSQtheta ./ sigmaX2) + (cosSQtheta ./ sigmaY2);


    trans_mat = [1 0 6; 0 1 0; 0 0 1];
    out_dir = sprintf('./trans-test-%d/', lambda);
    trans_x = test_aff(nodeX, nodeY, a, b, c, alphas, lambda, trans_mat, out_dir);
    fprintf(fid,'  Translation 1-D: %0.6f\n', trans_x);

    % Create the inital placement for the model
    xMax = 280;
    xMin = 80;
    xStep = (xMax - xMin) / 3;
    yMax = 200;
    yMin = 90;
    yStep = (yMin - yMax) / 1;

    % Meshgrid returns a set of points, we use these points as the
    % center of our nodes
    [nodeX, nodeY] = meshgrid(xMin:xStep:xMax, yMax:yStep:yMin);
    thetas = zeros(size(nodeX));
    sigmaX = repmat(abs(xStep / 2.4), size(nodeX));
    sigmaY = repmat(abs(yStep / 3.4), size(nodeX));
    alphas = ones(size(nodeX));

    cosSQtheta = cos(thetas).^2;
    sinSQtheta = sin(thetas).^2;
    sin2theta = 2 * sin(thetas);

    sigmaX2 = 2 * (sigmaX .^ 2);
    sigmaY2 = 2 * (sigmaY .^ 2);

    a = (cosSQtheta ./ sigmaX2) + (sinSQtheta ./ sigmaY2);
    b = (-sin2theta ./ (2 * sigmaX2)) + (sin2theta ./ (2 * sigmaY2));
    c = (sinSQtheta ./ sigmaX2) + (cosSQtheta ./ sigmaY2);


    trans_mat = [1 0 3; 0 1 3; 0 0 1];
    out_dir = sprintf('./trans-test-diag-%d/', lambda);
    trans_diag = test_aff(nodeX, nodeY, a, b, c, alphas, lambda, trans_mat, out_dir);
    fprintf(fid,'  Translation 2-D: %0.6f\n', trans_diag);

    % Create the inital placement for the model
    xMax = 280;
    xMin = 80;
    xStep = (xMax - xMin) / 3;
    yMax = 200;
    yMin = 90;
    yStep = (yMin - yMax) / 1;

    % Meshgrid returns a set of points, we use these points as the
    % center of our nodes
    [nodeX, nodeY] = meshgrid(xMin:xStep:xMax, yMax:yStep:yMin);
    thetas = zeros(size(nodeX));
    sigmaX = repmat(abs(xStep / 2.4), size(nodeX));
    sigmaY = repmat(abs(yStep / 3.4), size(nodeX));
    alphas = ones(size(nodeX));

    cosSQtheta = cos(thetas).^2;
    sinSQtheta = sin(thetas).^2;
    sin2theta = 2 * sin(thetas);

    sigmaX2 = 2 * (sigmaX .^ 2);
    sigmaY2 = 2 * (sigmaY .^ 2);

    a = (cosSQtheta ./ sigmaX2) + (sinSQtheta ./ sigmaY2);
    b = (-sin2theta ./ (2 * sigmaX2)) + (sin2theta ./ (2 * sigmaY2));
    c = (sinSQtheta ./ sigmaX2) + (cosSQtheta ./ sigmaY2);


    cosT = cos((pi / 180) * 0.2);
    sinT = sin((pi / 180) * 0.2);

    trans_mat = [cosT sinT 0; -sinT cosT 0; 0 0 1];
    out_dir = sprintf('./rot-test-%d/', lambda);
    rot_err = test_aff(nodeX, nodeY, a, b, c, alphas, lambda, trans_mat, out_dir);
    fprintf(fid,'  Rotation: %0.6f\n', rot_err);

    % Create the inital placement for the model
    xMax = 280;
    xMin = 80;
    xStep = (xMax - xMin) / 3;
    yMax = 200;
    yMin = 90;
    yStep = (yMin - yMax) / 1;

    % Meshgrid returns a set of points, we use these points as the
    % center of our nodes
    [nodeX, nodeY] = meshgrid(xMin:xStep:xMax, yMax:yStep:yMin);
    thetas = zeros(size(nodeX));
    sigmaX = repmat(abs(xStep / 2.4), size(nodeX));
    sigmaY = repmat(abs(yStep / 3.4), size(nodeX));
    alphas = ones(size(nodeX));

    cosSQtheta = cos(thetas).^2;
    sinSQtheta = sin(thetas).^2;
    sin2theta = 2 * sin(thetas);

    sigmaX2 = 2 * (sigmaX .^ 2);
    sigmaY2 = 2 * (sigmaY .^ 2);

    a = (cosSQtheta ./ sigmaX2) + (sinSQtheta ./ sigmaY2);
    b = (-sin2theta ./ (2 * sigmaX2)) + (sin2theta ./ (2 * sigmaY2));
    c = (sinSQtheta ./ sigmaX2) + (cosSQtheta ./ sigmaY2);


    cosT = cos((pi / 180) * 0.1);
    sinT = sin((pi / 180) * 0.1);

    trans_mat = [1 .05 0; 0 1 0; 0 0 1];
    out_dir = sprintf('./shear-test-%d/', lambda);
    shear_err = test_aff(nodeX, nodeY, a, b, c, alphas, lambda, trans_mat, out_dir);
    fprintf(fid,'  Shearing: %0.6f\n', shear_err);


    % Create the inital placement for the model
    xMax = 280;
    xMin = 80;
    xStep = (xMax - xMin) / 3;
    yMax = 200;
    yMin = 90;
    yStep = (yMin - yMax) / 1;

    % Meshgrid returns a set of points, we use these points as the
    % center of our nodes
    [nodeX, nodeY] = meshgrid(xMin:xStep:xMax, yMax:yStep:yMin);
    thetas = zeros(size(nodeX));
    sigmaX = repmat(abs(xStep / 2.4), size(nodeX));
    sigmaY = repmat(abs(yStep / 3.4), size(nodeX));
    alphas = ones(size(nodeX));

    cosSQtheta = cos(thetas).^2;
    sinSQtheta = sin(thetas).^2;
    sin2theta = 2 * sin(thetas);

    sigmaX2 = 2 * (sigmaX .^ 2);
    sigmaY2 = 2 * (sigmaY .^ 2);

    a = (cosSQtheta ./ sigmaX2) + (sinSQtheta ./ sigmaY2);
    b = (-sin2theta ./ (2 * sigmaX2)) + (sin2theta ./ (2 * sigmaY2));
    c = (sinSQtheta ./ sigmaX2) + (cosSQtheta ./ sigmaY2);


    cosT = cos((pi / 180) * 0.1);
    sinT = sin((pi / 180) * 0.1);

    trans_mat = [.99 0 0; 0 .99 0; 0 0 1];
    out_dir = sprintf('./shrink-test-%d/', lambda);
    shrink_err = test_aff(nodeX, nodeY, a, b, c, alphas, lambda, trans_mat, out_dir);
    fprintf(fid,'  Shrinking: %0.6f\n', shrink_err);

    % Create the inital placement for the model
    xMax = 280;
    xMin = 80;
    xStep = (xMax - xMin) / 3;
    yMax = 200;
    yMin = 90;
    yStep = (yMin - yMax) / 1;

    % Meshgrid returns a set of points, we use these points as the
    % center of our nodes
    [nodeX, nodeY] = meshgrid(xMin:xStep:xMax, yMax:yStep:yMin);
    thetas = zeros(size(nodeX));
    sigmaX = repmat(abs(xStep / 2.4), size(nodeX));
    sigmaY = repmat(abs(yStep / 3.4), size(nodeX));
    alphas = ones(size(nodeX));

    cosSQtheta = cos(thetas).^2;
    sinSQtheta = sin(thetas).^2;
    sin2theta = 2 * sin(thetas);

    sigmaX2 = 2 * (sigmaX .^ 2);
    sigmaY2 = 2 * (sigmaY .^ 2);

    a = (cosSQtheta ./ sigmaX2) + (sinSQtheta ./ sigmaY2);
    b = (-sin2theta ./ (2 * sigmaX2)) + (sin2theta ./ (2 * sigmaY2));
    c = (sinSQtheta ./ sigmaX2) + (cosSQtheta ./ sigmaY2);


    cosT = cos((pi / 180) * 0.1);
    sinT = sin((pi / 180) * 0.1);

    trans_mat = [1.01 0 0; 0 1.01 0; 0 0 1];
    out_dir = sprintf('./growth-test-%d/', lambda);
    growth_err = test_aff(nodeX, nodeY, a, b, c, alphas, lambda, trans_mat, out_dir);
    fprintf(fid,'  Growing: %0.6f\n', growth_err);
end
fclose(fid);