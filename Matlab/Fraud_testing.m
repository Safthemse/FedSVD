X_1 = [1 2 3 4 5]';
X_2 = [6 7 8 9 10;
    11 12 13 14 15]';
X = [X_1 X_2];

[U_1, S_1, V_1] = svd(X_1);
[U_2, S_2, V_2] = svd(X_2);
[U, S, V] = svd(X);

V_T = V';

V_1_test_T = V_T(:,1);
V_2_test_T = V_T(:,2:3);

X_1_test = U*S*V_1_test_T
X_2_test = U*S*V_2_test_T