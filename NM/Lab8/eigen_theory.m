clear all
clc

A =[-2  -4  2
    -2  1   2
    4   2   5]

%==============={ SOLVE }===============%
if size(A, 1) ~= size(A, 2)
    error("Gimme square matrix!");
end

dim = size(A, 1);

Lmbdmtrx = @(A, lmbd) A-eye(dim)*lmbd;


syms x
S = solve(det(Lmbdmtrx(A, x)) == 0, x);

eigvect = ones(dim, 1);

for i = 1:dim
    fprintf("L%i = %f\nEigenvector:\n", i, S(i))
    temp = Lmbdmtrx(A, S(i));
    eigvect(2:dim) = linsolve(temp(2:dim, 2:dim), -temp(2:dim, 1)); % 1:(dim-1)
    disp(eigvect.')
end
