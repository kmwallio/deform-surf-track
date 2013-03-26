function [ frobb ] = frob( affMats )
%FROB Summary of this function goes here
%   Detailed explanation goes here
    frobb = 0;
    c = size(affMats, 3);
    for i = 1:c
        frobb = frobb + norm(affMats(:,:,i), 'fro');
    end
end

