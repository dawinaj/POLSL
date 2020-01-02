clear all
clc

A = [
    3 2 1 0
    1 2 0 1
    ]

Q = [
     2  0  0  0
     0  0  0  0
     0  0  0  0
     0  0  0  0
    ]

c = [-2 3 0 0].'

X = [0 0 6 4].'


% END OF INPUTTING %

b  = X(X~=0)
Xb = X(X~=0)
Xn = X(X==0)

nX = length(X);
nE = length(b);

if ~issymmetric(Q)
    return;
end
for i = 1:nX
    determ = det(Q(1:i, 1:i))
   if determ < 0
       return;
   end
end

Qb = Q(:, X~=0)
Qn = Q(:, X==0)

Dlt = zeros(nX);
for i = 1:nX
    if c(i)+Qb(i, :)*Xb <= 0
        Dlt(i, i) = 1;
    else
        Dlt(i, i) = -1;
    end
end
Dlt

smplx = zeros(nX+nE, 3*nX+2*nE);

smplx(1:nE,1:nX) = A;

smplx((nE+1):(nX+nE), 1:nX) = Q;
smplx((nE+1):(nX+nE), (nX+1):(nX+nE)) = A.';
smplx((nE+1):(nX+nE), (nX+nE+1):(nX+2*nE)) = -A.';
smplx((nE+1):(nX+nE), (nX+2*nE+1):(2*nX+2*nE)) = -eye(nX);
smplx((nE+1):(nX+nE), (2*nX+2*nE+1):(3*nX+2*nE)) = Dlt;

values = zeros(nX+nE, 1);
values(1:nE) = b;
values((nE+1):(nX+nE)) = -c;

mltpl = 1-2*(values < 0);
smplx = smplx.*mltpl;
values = values.*mltpl;

coeffs = zeros(1, 3*nX+2*nE);

found = zeros(nX+nE, 1);
for i = (3*nX+2*nE):-1:1
    if sum(smplx(:, i)) == 1 && min(smplx(:, i)) == 0 && max(smplx(:, i)) == 1 && found(smplx(:, i)==1) == 0
        found(smplx(:, i)==1) = 1;
    else
        coeffs(i) = sum(smplx(:, i));
    end
end

fVal = sum(values);

fprintf('\tSimplex prev(%i, %i);\n\t{\n', size(smplx, 1), size(smplx, 2))
for y = 1:size(smplx, 1)
    fprintf('\t\t')
    for x = 1:size(smplx, 2)
        fprintf('prev.elem(%i, %i, %f);   \t', y, x, smplx(y, x))
    end
    fprintf('prev.val(%i, %f);\n', y, values(y))
end
fprintf('\t\t')
for x = 1:size(smplx, 2)
    fprintf('prev.coeff(%i, %f);\t\t', x, coeffs(x))
end
fprintf('prev.fVal(%f);\n\t}\n\n\n', fVal)


for y = 1:size(smplx, 1)
    for x = 1:size(smplx, 2)
        fprintf('%f\t', smplx(y, x))
    end
    fprintf('|| %f\n', values(y))
end
for x = 1:size(smplx, 2)
    fprintf('-------------')
end
fprintf('\n')
for x = 1:size(smplx, 2)
    fprintf('%f\t', coeffs(x))
end
fprintf('|| %f\n\n', fVal)

