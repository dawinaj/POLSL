clear all
clc

Payoff = [
    12  -8  10  10  -7
    -15 10  -11 -8  6
    14  -10 -14 6   -13
    -24 8   -15 -14 5
    10  -9  11  -2  12
]

%{
Payoff = [
    -10 3
    12  -4
]
Payoff = [
    0   10 10
    10   0  -10
    -10 -10  0
]
Payoff = [
    20  -50 -18
    -30 60  29
]

Payoff = [
    12  -8  10  10  -7
    -15 10  -11 -8  6
    14  -10 -14 6   -13
    -24 8   -15 -14 5
    10  -9  11  -2  12
]

Payoff = [
    -2  6   8   -6
    44  -8  -4  8
]
%}


% =====================================
bonus = 2;

PayoffD1 = -Payoff.';
MinEl = min(PayoffD1(:));
if MinEl <= bonus
    k = -MinEl + bonus;
else
    k = 0;
end
PayoffD1 = bsxfun(@plus, PayoffD1, k);
smplx = zeros(size(PayoffD1, 1), size(PayoffD1, 2)+size(PayoffD1, 1));
smplx(1:size(PayoffD1, 1), 1:size(PayoffD1, 2)) = PayoffD1;
smplx(1:size(PayoffD1, 1), (size(PayoffD1, 2)+1):(size(PayoffD1, 1)+size(PayoffD1, 2))) = eye(size(PayoffD1, 1))
values = ones(size(PayoffD1, 1), 1);
coeffs = zeros(1, size(PayoffD1, 1)+size(PayoffD1, 2));
coeffs(1:size(PayoffD1, 2)) = ones(1, size(PayoffD1, 2));
fVal = 0;

fprintf('\tSimplex D1(%i, %i);\n\t{\n', size(smplx, 1), size(smplx, 2))
for y = 1:size(smplx, 1)
    fprintf('\t\t')
    for x = 1:size(smplx, 2)
        fprintf('D1.elem(%i, %i, %f);\t', y, x, smplx(y, x))
    end
    fprintf('D1.val(%i, %f);\n', y, values(y))
end
fprintf('\t\t')
for x = 1:size(smplx, 2)
    fprintf('D1.coeff(%i, %f);\t\t', x, coeffs(x))
end
fprintf('D1.fVal(%f);\n\t\tD1.kVal(%f);\n\t}\n', fVal, k)


PayoffD2 = Payoff;
MinEl = min(PayoffD2(:));
if MinEl <= bonus
    k = -MinEl + bonus;
else
    k = 0;
end
PayoffD2 = bsxfun(@plus, PayoffD2, k);
smplx = zeros(size(PayoffD2, 1), size(PayoffD2, 2)+size(PayoffD2, 1));
smplx(1:size(PayoffD2, 1), 1:size(PayoffD2, 2)) = PayoffD2;
smplx(1:size(PayoffD2, 1), (size(PayoffD2, 2)+1):(size(PayoffD2, 1)+size(PayoffD2, 2))) = eye(size(PayoffD2, 1));
values = ones(size(PayoffD2, 1), 1);
coeffs = zeros(1, size(PayoffD2, 1)+size(PayoffD2, 2));
coeffs(1:size(PayoffD2, 2)) = ones(1, size(PayoffD2, 2));
fVal = 0;

fprintf('\tSimplex D2(%i, %i);\n\t{\n', size(smplx, 1), size(smplx, 2))
for y = 1:size(smplx, 1)
    fprintf('\t\t')
    for x = 1:size(smplx, 2)
        fprintf('D2.elem(%i, %i, %f);\t', y, x, smplx(y, x))
    end
    fprintf('D2.val(%i, %f);\n', y, values(y))
end
fprintf('\t\t')
for x = 1:size(smplx, 2)
    fprintf('D2.coeff(%i, %f);\t\t', x, coeffs(x))
end
fprintf('D2.fVal(%f);\n\t\tD2.kVal(%f);\n\t}\n\n\n', fVal, k)
