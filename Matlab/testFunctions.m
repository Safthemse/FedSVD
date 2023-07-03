%Prepare and partition the data in A 
iris = readtable("iris.csv");
A = table2array(iris(:,1:end))';

%Use case 0: FedSVD
%preparing the data matrix Ai and input matrix Xi for each user i
%arbitrary number of equal partitions
[m, n] = size(A);
num_partitions = 3;
size_partitions = floor(n/num_partitions);

Ai = {};
for i = 1:num_partitions
    Ai{i} = A(:,(1+(i-1)*size_partitions):(i*size_partitions));
end

Xi = {};
for i = 1:num_partitions
    Xi{i} = Ai{i};
end

[U, S, Vi] = FedSVD(Xi);

%Reconstruct matrices
for i = 1:num_partitions
    norm(Ai{i} - U*S*Vi{i}, 2);
end

%Use case 1: Federated Total Least Squares Minimization
%preparing the data matrix Ai and input matrix Xi for each user i
%arbitrary number of equal partitions
[n,m] = size(A);
num_partitions = 4;
size_partitions = floor(n/num_partitions);

Ai = {};
for i = 1:num_partitions
    Ai{i} = A((1+(i-1)*size_partitions):(i*size_partitions),:);
end

[x] = FedTLS(Ai);

"Test if found solution to the Total Least Squares Minimization Problem"
norm(A*x,2)

%Use case 2: Federated Computation of Rank and Fundamental Subspaces
%preparing the data matrix Ai and input matrix Xi for each user i
%arbitrary number of equal partitions
[m, n] = size(A);
num_partitions = 3;
size_partitions = floor(n/num_partitions);

Ai = {};
for i = 1:num_partitions
    Ai{i} = A(:,(1+(i-1)*size_partitions):(i*size_partitions));
end

[orthogonal_basis_A, orthogonal_basis_left_nullspace_A, r, p] = FedRankAndSubspaces(Ai);