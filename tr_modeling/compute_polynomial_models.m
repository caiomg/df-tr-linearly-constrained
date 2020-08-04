function polynomials = compute_polynomial_models(model)
    
    
    dim = size(model.center_point(), 1);
    points_num = model.number_of_points();
    functions_num = size(model.fvalues, 1);
    pivot_values = model.pivot_values;
    actual_points = ~isinf(pivot_values) & pivot_values ~= 0;
    
    linear_terms = dim+1;
    full_q_terms = (dim + 1)*(dim + 2)/2;
    if linear_terms < points_num && points_num < full_q_terms
        if model.tr_center > linear_terms
            tr_center = model.tr_center - sum(isinf(pivot_values));
        else
            tr_center = model.tr_center;
        end
        % Compute quadratic model
        if find(isinf(model.fvalues(:, actual_points)), 1)
            'debug';
        end
        [polynomials, accuracy] = ...
            compute_quadratic_mn_polynomials(model.points_abs(:, actual_points), ...
                                             tr_center, model.fvalues(:, actual_points));
    end

    if points_num <= linear_terms || points_num == full_q_terms || ...
            accuracy < 1e4*eps(1)
        % Compute model with incomplete (complete) basis
        l_alpha = nfp_finite_differences(model.points_shifted(:, actual_points), ...
                                         model.fvalues(:, actual_points), ...
                                         model.pivot_polynomials(actual_points));
        for k = functions_num:-1:1
            polynomials{k}  = ...
                combine_polynomials(model.pivot_polynomials(actual_points), ...
                                    l_alpha(k, :));
            polynomials{k} = shift_polynomial(polynomials{k}, ...
                                              model.points_shifted(:, ...
                                                              model.tr_center));
        end
    end
end
