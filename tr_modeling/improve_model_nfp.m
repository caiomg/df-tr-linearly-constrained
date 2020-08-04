function [model, success] = improve_model_nfp(model, funcs, constraints, options)
    
    rel_pivot_threshold = options.pivot_threshold;
    tol_radius = options.tol_radius;
    radius_factor = options.radius_factor;
    
    radius = model.radius;
    pivot_threshold = rel_pivot_threshold*min(1, radius);
    points_shifted = model.points_shifted;
    [dim, p_ini] = size(points_shifted);
    true_dim = degrees_of_freedom(constraints, model.points_abs(:, 1), pivot_threshold);

    shift_center = model.points_abs(:, 1);
    tr_center = model.tr_center;
    tr_center_abs = model.points_abs(:, tr_center);

    pivot_polynomials = model.pivot_polynomials;
    polynomials_num = length(pivot_polynomials);

    if p_ini == 0 || is_complete(model)
       error('cmg:model_empty_full', ...
             ['Model either empty or full. ' ...
              'Should not be calling improve_model_nfp']);
    end
    if is_old(model, options) && is_lambda_poised(model, constraints, options)
       error('cmg:model_old', ...
             'Model too old. Should be calling rebuild model');
    end

    % Test if the model is already FL but old
    % Distance measured in inf norm
    tr_center_pt = points_shifted(:, tr_center);

    if p_ini < dim + 1
        % The model is not yet fully linear
        block_beginning = 2;
        block_end = dim + 1;
    else
        % We can add a point to the quadratic block
        block_beginning = dim + 2;
        block_end = (dim + 1)*(dim + 2)/2;
        block_end = min(block_end, p_ini + dim); % practical override
    end
    next_position = p_ini + 1;
    radius_used = radius;
    % Possibly try with smaller radii
    for attempts = 1:3
        % Iterate through available polynomials
        for poly_i = next_position:block_end % not really iterating
            polynomial = ...
                orthogonalize_to_other_polynomials(pivot_polynomials, poly_i, ...
                                                   points_shifted, p_ini);

            [new_points_shifted, new_pivots, new_points_unshifted] = ...
                compute_new_point(polynomial, shift_center, tr_center_abs, ...
                                  radius, constraints);
            point_found = false;
            for found_i = 1:size(new_points_shifted, 2)
                new_pivot_value = new_pivots(found_i);
                if abs(new_pivot_value) < pivot_threshold
                    continue
                else
                    point_found = true;
                end
                new_point_shifted = new_points_shifted(:, found_i);
                new_point_abs = new_points_unshifted(:, found_i);
                [new_fvalues, f_succeeded] = ...
                    evaluate_new_fvalues(funcs, new_point_abs);
                if f_succeeded
                    break
                else
                    true;
                end
            end
            if point_found && f_succeeded
                % Update this polynomial in the set
                pivot_polynomials(poly_i) = polynomial;
                % Swap polynomials
                pivot_polynomials([next_position, poly_i]) = ...
                    pivot_polynomials([poly_i, next_position]);
                % Add point
                points_shifted(:, next_position) = new_point_shifted;
                % Stop trying pivot polynomials
                break %(for poly_i)
            end
            % Attempt another polynomial if didn't break
        end
        if point_found && f_succeeded
            break %(for attempts)
        elseif point_found && radius_used > tol_radius
            % Reduce radius if it didn't break
            radius_used = 0.5*radius_used;
        else
            break
        end
    end
    success = point_found && f_succeeded;
    if success
        % Normalize polynomial value
        pivot_polynomials(next_position) = ...
            normalize_polynomial(pivot_polynomials(next_position), ...
                                 new_point_shifted);
        % Re-orthogonalize
        pivot_polynomials(next_position) = ...
            orthogonalize_to_other_polynomials(pivot_polynomials, ...
                                               next_position, points_shifted, ...
                                               p_ini);

        % Orthogonalize polynomials on present block (deffering
        % subsequent ones)
        pivot_polynomials = orthogonalize_block(pivot_polynomials, ...
                                                new_point_shifted, ...
                                                next_position, ...
                                                block_beginning, ...
                                                p_ini);

        % Update model and recompute polynomials
        model.points_abs(:, next_position) = new_point_abs;
        model.points_shifted = points_shifted;
        model.fvalues(:, next_position) = new_fvalues;
        model.pivot_polynomials = pivot_polynomials;
        model.pivot_values(:, next_position) = new_pivot_value;
        model.modeling_polynomials = {};
    end
    
end

    