function result = check_nfp_polynomials(model)

    points_shifted = model.points_shifted;
    nfp_polynomials = model.pivot_polynomials;
    pivot_values = model.pivot_values;
    [dim, points_num] = size(points_shifted);
    tol = 1e-6;
    result = 0;
    for point_i = 1:points_num
        if point_i == 1
            block_beginning = 1;
        elseif point_i <= dim+1
            block_beginning = 2;
        else
            block_beginning = dim + 2;
        end
        for poly_i = block_beginning:points_num
            val = evaluate_polynomial(nfp_polynomials(poly_i), points_shifted(:, point_i));
            if point_i == poly_i && ~isinf(pivot_values(poly_i))
                correct_val = 1;
            else
                correct_val = 0;
            end
            val_error = correct_val - val;
            if isinf(pivot_values(poly_i)) && val_error ~= 0
                error('cmg:nonzero_dummy_polynomial', ...
                      'Dummy polynomial should render zero');
            end
            result = result + abs(val_error);
        end
    end
    if result > tol
        warning('cmg:interp_error', 'Interpolation error: %g', result);
    end

end