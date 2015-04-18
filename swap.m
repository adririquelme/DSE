function matrix = swap(matrix,dimension,idx_a,idx_b)
% función que intercambia filas o columnas
% tomada de http://stackoverflow.com/questions/4939738/swapping-rows-and-columns
% modificada por Adrián Riquelme, 14 marzo 2015
% matrix = swap(matrix,dimension,idx_a,idx_b)
[n,m]=size(matrix);
if dimension == 1
    if idx_a<=n && idx_b<=n && idx_a>=1 && idx_b>=1
        row_a = matrix(idx_a,:);
        matrix(idx_a,:) = matrix(idx_b,:);
        matrix(idx_b,:) = row_a;
    else
        % no hacemos nada
    end
elseif dimension == 2
    if idx_a<=m && idx_b<=m idx_a>=1 && idx_b>=1
        col_a = matrix(:,idx_a);
        matrix(:,idx_a) = matrix(:,idx_b);
        matrix(:,idx_b) = col_a;        
    else
        % no hacemos nada
    end
end

