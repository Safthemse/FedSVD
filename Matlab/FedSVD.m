%Naming conventions:
% Xi: the input matrix for each user i
% X: the whole data matrix, composed like X = [X1 ... Xi ... Xk]
% P: the left hand masking matrix
% Qi: the right masking matrix for user i
% Q: the whole right masking matrix, composed like Q' = [Q1' ... Qi' ... Qk']
% X_i: the masked input matrix for user i, X_i = P*X_i*Q_i
% X_: the whole masked data matrix, composed like X_ = P*[X1 ... Xi ... Xk]*[Q1' ... Qi' ... Qk']

function [U, S, Vi] = FedSVD(Xi)

    [m, ~] = size(Xi{1});
    ni = {};
    n = 0;
    num_partitions = length(Xi);
    for i = 1:num_partitions
        [~,ni{i}] = size(Xi{i});
        n = n + ni{i};
    end
    
    %generation of the removable random masks
    %P is distributed to all, Qi is distributed to user i
    mu = 1;
    sigma = 1;
    
    A_1 = normrnd(mu,sigma, m, m);
    [P, ~] = qr(A_1);
    
    A_2 = normrnd(mu, sigma, n, n);
    [Q, ~] = qr(A_2);
    
    Qi = {};
    accumulated_ni = 0;
    for i = 1:num_partitions
        Qi{i} = Q(accumulated_ni+1:accumulated_ni+ni{i},:);
        accumulated_ni = accumulated_ni + ni{i};
    end
    
    %all users compute X_i by adding the masks P and Qi to X
    X_i = {};
    for i = 1:num_partitions
        X_i{i} = P*Xi{i}*Qi{i};
    end
    
    %X_ is aggregated from all X_i, see eq. (4) in Chai et al.
    for i = 1:num_partitions
        if i == 1
            X_ = X_i{i};
        else
            X_ = X_ + X_i{i};
        end
    end
    
    %factorize X_ into U_SV_
    [U_,S,V_] = svd(X_);
    
    %each user downloads U_, S and recover U by P'U_.
    %V_i' is recovered under the protection of each user's random mask
    U = P'*U_;
    V_i = {};
    Vi = {};

    %the following removal works, but may lead to privacy issues. see
    %ch. 3.3 in Chai et al. The following is my solution, since there
    %were some issues with dimensions in Chai et al.
    for i = 1:num_partitions
        Vi{i} = Qi{i}*V_;
    end
end