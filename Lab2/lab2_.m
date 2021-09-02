n = 15;
A = zeros(n, n);
X = [-1 -1 -1 -1 1 -1 1 -1 -1 1 -1 1 1 1 -1];
for i = 1: n
    for j = 1: n
        A(i, j) = X(1, j);
    end
    X = circshift(X, -1);
end

X = X';

Y = (1 / n) * (A * X);

Z1 = [-1 -1 -1 -1 1 1 1 -1 -1 1 -1 1 1 1 -1];
Z1 = Z1';
Y1 = (1 / n) * (A * Z1);
max1 = find(Y1 == max(Y1));
E1 = mod((Z1' - A(max1, :)) / 2, 2); 

Z2 = [1 -1 -1 -1 1 -1 1 -1 -1 1 1 1 1 1 -1];
Z2 = Z2';
Y2 = (1 / n) * (A * Z2);
max2 = find(Y2 == max(Y2));
E2 = mod((Z2' - A(max2, :)) / 2, 2); 

E1 = [0,0,0,0,0,1,0,0,0,0,0,0,0,0,0]
E2 = [1,0,0,0,0,0,0,0,0,0,1,0,0,0,0]