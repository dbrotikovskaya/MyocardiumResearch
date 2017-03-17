function I2 = getMaxCC(I)
% Get biggest connected component on the mask.
    CC = bwconncomp(I);
    numPixels = cellfun(@numel,CC.PixelIdxList);    
    [biggest,idx] = max(numPixels);
    I(:) = 0;
    I(CC.PixelIdxList{idx}) = 255;
    I2 = I;
end