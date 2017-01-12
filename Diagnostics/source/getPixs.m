function pl = getPixs(I, sl, in, indList)
    pl = [];
    for i =1:size(indList, 1)
        pval = double(I(indList(i, 2), indList(i, 1)));
        pl = [pl, pval * sl + in];
    end
end