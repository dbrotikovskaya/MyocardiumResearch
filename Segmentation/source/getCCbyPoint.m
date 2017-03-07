function I2 = getCCbyPoint(I, cX, cY)
    bwl = bwlabel(I);
    ccNum = bwl(cY, cX);
    I2 = bwl == ccNum;
end