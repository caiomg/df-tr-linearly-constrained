function model = fill_linear_block(model)
% FILL_LINEAR_BLOCK - 
%   

    [dim, num_points] = size(model.points_abs);
    points_remaining = dim - num_points + 1;
    model.points_abs(:, num_points+1:dim+1) = zeros(dim, points_remaining);
    model.points_shifted(:, num_points+1:dim+1) = zeros(dim, points_remaining);
    model.pivot_values(num_points+1:dim+1) = inf(1, points_remaining);
    model.fvalues(:, num_points+1:dim+1) = inf(size(model.fvalues, 1), points_remaining);
    for k = (num_points+1):(dim+1)
        model.pivot_polynomials(k) = polynomial_zero(dim);
    end
        
end

