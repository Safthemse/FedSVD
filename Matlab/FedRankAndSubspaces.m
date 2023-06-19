function [orthogonal_basis_A, orthogonal_basis_left_nullspace_A, r, p] = FedRankAndSubspaces(Ai)
    Xi = {};
    num_partitions = length(Ai);
    for i = 1:num_partitions
        Xi{i} = Ai{i};
    end

    [U, S, Vi] = FedSVD(Xi);

    [m,n] = size(S);

    p = min(m,n);
    r = nnz(S);
    
    orthogonal_basis_A = U(:,1:r);
    orthogonal_basis_left_nullspace_A = U(:,r+1:m);
end