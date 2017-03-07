function I2 = getMaxCC(I)
    CC = bwconncomp(I);
    numPixels = cellfun(@numel,CC.PixelIdxList);    
    [biggest,idx] = max(numPixels);
    I(:) = 0;
    I(CC.PixelIdxList{idx}) = 255;
    I2 = I;
end