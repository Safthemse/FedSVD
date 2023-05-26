%defining FedSVD parameters
iris = readtable("iris.csv");
X = table2array(iris(:,1:end))';

[m, n] = size(X);

num_partitions = 3;
size_partitions = floor(n/num_partitions);

%step 1, FedSVD: generation of the removable random masks
%step 1, FedSVD: P is distributed to all, Qi is distributed to user i
mu = 1;
sigma = 1;

A_1 = normrnd(mu,sigma, m, m);
[P, ~] = qr(A_1);

A_2 = normrnd(mu, sigma, n, n);
[Q, ~] = qr(A_2);

Qi = {};
for i = 1:num_partitions
    Qi{i} = Q((1+(i-1)*size_partitions):(i*size_partitions),:);
end

Xi = {};
for i = 1:num_partitions
    Xi{i} = X(:, (1+(i-1)*size_partitions):(i*size_partitions));
end

%step 2, FedSVD: all users compute X_i by adding the masks P and Qi to X
X_i = {};
for i = 1:num_partitions
    X_i{i} = P*Xi{i}*Qi{i};
end

%step 2, FedSVD: X_ is aggregated from all X_i, see eq. (4)
for i = 1:num_partitions
    if i == 1
        X_ = X_i{i};
    else
        X_ = X_ + X_i{i};
    end
end

%step 3, FedSVD: factorize X_ into U_SV_
[U_,S,V_] = svd(X_);

%step 4: each user downloads U_, S and recover U by P'U_.
%step 4: V_i' is recovered under the protection of each user's random mask
U = P'*U_;
V_i = {};
Vi = {};

for i = 1:num_partitions
    Vi{i} = Qi{i}*V_;
end

%defining PCA parameters
r = 2; %amount of principal components kept

%step 1, PCA: keep the r largest principal components
Ur = U(:,1:r);
Sr = S(1:r,1:r);
Vir = {};

for i = 1:num_partitions
    Vir{i} = Vi{i}(:,1:r);
end

%step 2, PCA: compute Xir
Xir = {};

for i = 1:num_partitions
    Xir{i} = Ur*Sr*Vir{i}';
end

%step 3, PCA: compute the PCA results Ur'*Xi for each user
%why is this the PCA result? what does it mean? check Chai et. al.
PCA_results = {};
for i = 1:num_partitions
    PCA_results{i} = Ur'*Xi{i};
end

%CHECK THE DIFFERENCE BETWEEN Xi and Xir
%They are quite similar, even with r=2
"Difference Xi and Xir, Frobenius norm"
for i = 1:num_partitions
    norm(Xi{i} - Xir{i}, "fro")
end