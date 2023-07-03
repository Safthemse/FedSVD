The code in this repository is related to the article "Practical Lossless Federated Singular Vector Decomposition over
Billion-Scale Data" by Chai et al. 

The repository contains four .m-files:
FedSVD.m
FedTLS.m
FedRankAndSubspaces.m
testFunctions.m

The repository also includes the files iris.data and iris.names which is the data used for testing the algorithms. This data is converted into iris.csv, which is then used by the .m-files. The data set is retrieved from the UC Irvine Machine Learning Repository: https://archive.ics.uci.edu/dataset/53/iris

Some important variables:
Ai: the data of user i
A: the total data matrix consisting of the data of all users i.
Xi: the input matrix for each user i
X: the whole data matrix, composed like X = [X1 ... Xi ... Xk]
P: the left hand masking matrix
Qi: the right masking matrix for user i
Q: the whole right masking matrix, composed like Q' = [Q1' ... Qi' ... Qk']
X_i: the masked input matrix for user i, X_i = P*X_i*Q_i
X_: the whole masked data matrix, composed like X_ = P*[X1 ... Xi ... Xk]*[Q1' ... Qi' ... Qk']

FedSVD.m:
The linear algebra aspects of the FedSVD algorithm by Chai et al. Takes the cell structure Xi as input, and returns the matrices U and S, as well as the cell structure Vi.

FedTLS:
The Federated Total Least Squares Minimization algorithm, as described in the paper "Additional Use Cases for the Federated SVD Algorithm". Takes the cell structure Ai as input, and returns the vector x.

FedRankAndSubspaces.m:
A method for extracting information about the rank and some of the fundamental subspaces of the data matrix. Takes the cell structure Ai as input, and returns the matrices orthogonal_basis_A and orthogonal_basis_left_nullspace, as well as the numbers p (the number of singular values of A) and r (the number of nonzero singular values of A).

testFunctions.m:
A script showcasing the three above-mentioned functions.
