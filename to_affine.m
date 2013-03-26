function [ is_aff, is_aff_dis ] = to_affine( not_affine )
    is_aff = zeros(3, 3, size(not_affine, 2) / 3);
    is_aff_dis = zeros(3, 3, size(not_affine, 2) / 3);
    lim = size(is_aff, 3);
    
    for i = 1:lim
        is_aff(:,:,i) = zeros(3, 3);
        is_aff(3, 3, i) = 1;
        a_to = ((i - 1) * 3) + 1;
        a_till = a_to + 2;
        is_aff(1:2, 1:3, i) = not_affine(1:2, a_to:a_till);
        is_aff_dis(:,:,i) = is_aff(:,:,i);
        is_aff_dis(1, 1, i) = is_aff_dis(1, 1, i) - 1;
        is_aff_dis(2, 2, i) = is_aff_dis(2, 2, i) - 1;
    end
end
