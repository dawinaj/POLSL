clear all
clc

vls = [0, 1, 2, 3, 4, 5]*50
xs  = [0, 1, 2, 3, 4, 5, 6]*50

prfts = transpose([0 0 0 0; 17 25 20 30; 38 40 35 45; 50 48 52 50; 55 56 60 55; 60 62 68 68])

x4 = 0;

tableX3 = zeros(length(vls), 3);
for x3 = 1:length(xs)
    tableX3(x3,1) = xs(x3);
    index = find(vls == xs(x3), 1);
    if ~isempty(index)
        tableX3(x3,2) = prfts(4, x3);
        tableX3(x3,3) = vls(index);
    else
        tableX3(x3,2) = NaN;
        tableX3(x3,3) = NaN;
    end
end
disp('    X3    S3    U3s')
disp(' ------------------')
disp(tableX3)


tableX2big = zeros(length(vls)*length(xs), 6);
tableX2 = zeros(length(xs), 2);
for X2 = 1:length(xs)
    for U2 = 1:length(vls)
        tableX2big((X2-1)*length(vls)+U2, 1) = xs(X2);
        tableX2big((X2-1)*length(vls)+U2, 2) = vls(length(xs)-U2);
        tableX2big((X2-1)*length(vls)+U2, 3) = prfts(3, length(xs)-U2);
        tempval = tableX2big((X2-1)*length(vls)+U2, 1) - tableX2big((X2-1)*length(vls)+U2, 2);
        tableX2big((X2-1)*length(vls)+U2, 4) = tempval;
        index = find(xs == tableX2big((X2-1)*length(vls)+U2, 4), 1);
        if ~isempty(index)
            tableX2big((X2-1)*length(vls)+U2, 5) = tableX3(index, 2);
        else
            tableX2big((X2-1)*length(vls)+U2, 5) = NaN;
        end
        tableX2big((X2-1)*length(vls)+U2, 6) = tableX2big((X2-1)*length(vls)+U2, 3) + tableX2big((X2-1)*length(vls)+U2, 5);
    end
    tableX2(X2, 1) = tableX2big((X2-1)*length(vls)+1, 1);
    maxV = nanmax(tableX2big((X2-1)*length(vls)+1:(X2)*length(vls), 6));
    tableX2(X2, 2) = maxV;
    [xposes, yposes] = find(tableX2big((X2-1)*length(vls)+1:(X2)*length(vls), 6) == maxV);
    for i = 1:length(xposes)
        if i > size(tableX2,2)-2
            tableX2(1:length(xs), 2+i) = NaN;
        end
        tableX2(X2, 2+i) = tableX2big((X2-1)*length(vls)+xposes(i), 2);
    end
end
disp('    X2    U2    L2    X3    S3    G2 ')
disp(' ------------------------------------')
disp(tableX2big)
disp('    X2    S2    U2s')
disp(' ------------------')
disp(tableX2)


tableX1big = zeros(length(vls)*length(xs), 6);
tableX1 = zeros(length(xs), 2);
for X1 = 1:length(xs)
    for U1 = 1:length(vls)
        tableX1big((X1-1)*length(vls)+U1, 1) = xs(X1);
        tableX1big((X1-1)*length(vls)+U1, 2) = vls(length(xs)-U1);
        tableX1big((X1-1)*length(vls)+U1, 3) = prfts(2, length(xs)-U1);
        tempval = tableX1big((X1-1)*length(vls)+U1, 1) - tableX1big((X1-1)*length(vls)+U1, 2);
        tableX1big((X1-1)*length(vls)+U1, 4) = tempval;
        index = find(xs == tableX1big((X1-1)*length(vls)+U1, 4), 1);
        if ~isempty(index)
            tableX1big((X1-1)*length(vls)+U1, 5) = tableX2(index, 2);
        else
            tableX1big((X1-1)*length(vls)+U1, 5) = NaN;
        end
        tableX1big((X1-1)*length(vls)+U1, 6) = tableX1big((X1-1)*length(vls)+U1, 3) + tableX1big((X1-1)*length(vls)+U1, 5);
    end
    tableX1(X1, 1) = tableX1big((X1-1)*length(vls)+1, 1);
    maxV = nanmax(tableX1big((X1-1)*length(vls)+1:(X1)*length(vls), 6));
    tableX1(X1, 2) = maxV;
    [xposes, yposes] = find(tableX1big((X1-1)*length(vls)+1:(X1)*length(vls), 6) == maxV);
    for i = 1:length(xposes)
        if i > size(tableX1,2)-2
            tableX1(1:length(xs), 2+i) = NaN;
        end
        tableX1(X1, 2+i) = tableX1big((X1-1)*length(vls)+xposes(i), 2);
    end
end
disp('    X1    U1    L1    X2    S2    G1 ')
disp(' ------------------------------------')
disp(tableX1big)
disp('    X1    S1    U1s')
disp(' ------------------')
disp(tableX1)


tableX0big = zeros(length(vls)*length(xs), 6);
tableX0 = zeros(length(xs), 2);
for X0 = 1:length(xs)
    for U0 = 1:length(vls)
        tableX0big((X0-1)*length(vls)+U0, 1) = xs(X0);
        tableX0big((X0-1)*length(vls)+U0, 2) = vls(length(xs)-U0);
        tableX0big((X0-1)*length(vls)+U0, 3) = prfts(1, length(xs)-U0);
        tempval = tableX0big((X0-1)*length(vls)+U0, 1) - tableX0big((X0-1)*length(vls)+U0, 2);
        tableX0big((X0-1)*length(vls)+U0, 4) = tempval;
        index = find(xs == tableX0big((X0-1)*length(vls)+U0, 4), 1);
        if ~isempty(index)
            tableX0big((X0-1)*length(vls)+U0, 5) = tableX1(index, 2);
        else
            tableX0big((X0-1)*length(vls)+U0, 5) = NaN;
        end
        tableX0big((X0-1)*length(vls)+U0, 6) = tableX0big((X0-1)*length(vls)+U0, 3) + tableX0big((X0-1)*length(vls)+U0, 5);
    end
    tableX0(X0, 1) = tableX0big((X0-1)*length(vls)+1, 1);
    maxV = nanmax(tableX0big((X0-1)*length(vls)+1:(X0)*length(vls), 6));
    tableX0(X0, 2) = maxV;
    [xposes, yposes] = find(tableX0big((X0-1)*length(vls)+1:(X0)*length(vls), 6) == maxV);
    for i = 1:length(xposes)
        if i > size(tableX0,2)-2
            tableX0(1:length(xs), 2+i) = NaN;
        end
        tableX0(X0, 2+i) = tableX0big((X0-1)*length(vls)+xposes(i), 2);
    end
end
disp('    X0    U0    L1    X1    S2    G1 ')
disp(' ------------------------------------')
disp(tableX0big)
disp('    X0    S0    U0s')
disp(' ------------------')
disp(tableX0)

disp(' ====================================')
disp(' ')

X0 = 300;
X0r = find(tableX0(1:size(tableX0, 1), 1) == X0);
U0s = rmmissing(tableX0(X0r, 3:size(tableX0, 2)));
Zfinal = tableX0(X0r,2);
Z0 = Zfinal - tableX0(X0r,2);
for U0 = U0s
    X1 = X0 - U0;
    X1r = find(tableX1(1:size(tableX1, 1), 1) == X1);
    U1s = rmmissing(tableX1(X1r, 3:size(tableX1, 2)));
    Z1 = Zfinal - tableX1(X1r,2);
    for U1 = U1s
        X2 = X1 - U1;
        X2r = find(tableX2(1:size(tableX2, 1), 1) == X2);
        U2s = rmmissing(tableX2(X2r, 3:size(tableX2, 2)));
        Z2 = Zfinal - tableX2(X2r,2);
        for U2 = U2s
            X3 = X2 - U2;
            X3r = find(tableX3(1:size(tableX3, 1), 1) == X3);
            U3s = rmmissing(tableX3(X3r, 3:size(tableX3, 2)));
            Z3 = Zfinal - tableX3(X3r,2);
            for U3 = U3s
                X4 = X3 - U3;
                fprintf('Us:      %i      %i      %i      %i\n', U0, U1, U2, U3)
                fprintf('Xs: %i----->%i----->%i----->%i----->%i\n', X0, X1, X2, X3, X4)
                fprintf('Ps:  %i       %i       %i       %i       %i\n\n', Z0, Z1, Z2, Z3, Zfinal)
            end
        end
    end
end

disp(' ')
