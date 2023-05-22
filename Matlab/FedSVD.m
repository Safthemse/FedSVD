%example of naming convention:
%X is the whole matrix, Xi is X partitioned into submatrices

%Prepare and partition the data in X.
iris = readtable("iris.csv");
X = table2array(iris(:,1:end))';

[m, n] = size(X);

num_partitions = 3;
size_partitions = floor(n/num_partitions);

%step 1: generation of the removable random masks
%step 1: P is distributed to all, Qi is distributed to user i
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

%step 2: all users compute X_i by adding the masks P and Qi to X
X_i = {};
for i = 1:num_partitions
    X_i{i} = P*Xi{i}*Qi{i};
end

%step 2: X_ is aggregated from all X_i, see eq. (4)
for i = 1:num_partitions
    if i == 1
        X_ = X_i{i};
    else
        X_ = X_ + X_i{i};
    end
end

%step 3: factorize X_ into U_SV_
[U_,S,V_] = svd(X_);

%step 4: each user downloads U_, S and recover U by P'U_.
%step 4: V_i' is recovered under the protection of each user's random mask
U = P'*U_;
V_i = {};
Vi = {};

%this removal works, but may lead to privacy issues. see ch. 3.3
%THERE MUST BE AN ERROR IN THE RESEARCH PAPER. Yes, but this here works. This
% is my solution.
for i = 1:num_partitions
    Vi{i} = Qi{i}*V_;
end


%ALT SER UT TIL Å STEMME! Dette er til testetuten
%Test that the mask are actually removable by checking that 
%X_ is equal to X when the masks are removed.
% "Check if the reconstructed partitions are equal to the original Xi"
% "diff Xi:"
% for i = 1:num_partitions
%     norm((Xi{i} - U*S*Vi{i}'), "fro")
% end
% Xtest = U*S*[Vi{1}' Vi{2}' Vi{3}'];
% 
% resultat = norm((X-Xtest), "fro")