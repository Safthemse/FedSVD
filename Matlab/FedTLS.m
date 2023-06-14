function [x] = FedTLS(Ai)

    Xi = {};
    num_partitions = length(Ai);
    for i = 1:num_partitions
        Xi{i} = Ai{i}';
    end

    [U, S, Vi] = FedSVD(Xi);

    x = U(:,end);

end
