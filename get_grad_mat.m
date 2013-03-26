function [ grad_mat ] = get_grad_mat( avgmat, iX, iY, iT )
    contrib = sum(sum(avgmat > 0.5));
    grad_mat = zeros(contrib + 1, 3);
    i = 1;
    
    width = size(iX, 2);
    height = size(iY, 1);
    for h = 1:height
        for w = 1:width
            if contrib(h, w) > 0.5
                grad_mat(i, :) = [iX(h, w) iY(h, w) iT(h, w)];
                i = i + 1;
            end
        end
    end
end

