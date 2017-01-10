function pl = getPixs(I, indList)
    pl = [];
    for i =1:size(indList, 1)
        pl = [pl, double(I(indList(i, 2), indList(i, 1)))];
    end
end