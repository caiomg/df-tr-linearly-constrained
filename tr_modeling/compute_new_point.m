function [new_points_shifted, new_pivot_values, new_points_abs] = ...
        compute_new_point(polynomial, shift_center, tr_center_abs, ...
                          radius, lb, ub)
    
    % Shift to origin
    center_shifted = tr_center_abs - shift_center;
    polynomial_origin = shift_polynomial(polynomial, -center_shifted);

    [new_point_min_abs, ~, exitflag_min] = ...
        minimize_tr(polynomial_origin, tr_center_abs, radius, lb, ub);
    
    new_point_min_shifted = new_point_min_abs - shift_center;
    pivot_min = evaluate_polynomial(polynomial, new_point_min_shifted);
    
    polynomial_max = multiply_p(polynomial_origin, -1);
    [new_point_max_abs, ~, exitflag_max] = ...
        minimize_tr(polynomial_max, tr_center_abs, radius, lb, ub);
    
    new_point_max_shifted = new_point_max_abs - shift_center;
    pivot_max = evaluate_polynomial(polynomial, new_point_max_shifted);

    if exitflag_min >= 0
        if (exitflag_max >= 0) && (abs(pivot_max)  >= abs(pivot_min))
            new_points_shifted = [new_point_max_shifted, new_point_min_shifted];
            new_pivot_values = [pivot_max, pivot_min];
            new_points_abs = [new_point_max_abs, new_point_min_abs];
        elseif exitflag_max >= 0 && (abs(pivot_max)  < abs(pivot_min))
            new_points_shifted = [new_point_min_shifted, new_point_max_shifted];
            new_pivot_values = [pivot_min, pivot_max];
            new_points_abs = [new_point_min_abs, new_point_max_abs];
        else
            new_points_shifted = new_point_min_shifted;
            new_pivot_values = pivot_min;
            new_points_abs = new_point_min_abs;
        end
    elseif exitflag_max >= 0
        new_points_shifted = new_point_max_shifted;
        new_pivot_values = pivot_max;
        new_points_abs = new_point_max_abs;
    else
        new_points_shifted = [];
        new_pivot_values = 0;
        new_points_abs = [];
    end
    if exist('new_points_abs', 'var') ~= 1
        'debug';
    end
end
