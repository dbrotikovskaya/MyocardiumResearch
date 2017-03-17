function I2 = getCCbyPoint(I, x, y)
% Get connected component by its inner point.
    bwl = bwlabel(I);
    ccNum = bwl(y, x);
    I2 = bwl == ccNum;
end