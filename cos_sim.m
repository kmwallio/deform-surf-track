function [ coss ] = cos_sim( affMats )

    coss = 0;
    c = size(affMats, 3);
    for i = 1:c
        coss = coss + (1 - (trace(affMats(:,:,i)) / (sqrt(3) * norm(affMats(:,:,i), 'fro'))));
    end

end

