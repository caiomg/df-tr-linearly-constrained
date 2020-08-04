function result = is_complete(model)
%IS_COMPLETE True if there are no more places to include points

    dim = size(model.points_abs, 1);
    degrees_lost = sum(isinf(model.pivot_values));
    true_dimension = dim - degrees_lost;
    
    maximum_number_of_points = (true_dimension + 1)*(true_dimension + 2)/2;
    maximum_number_of_nonzero_pivots = maximum_number_of_points + degrees_lost;
    
    n_nonzero_pivots = sum(model.pivot_values ~= 0);
    
    result = n_nonzero_pivots >= maximum_number_of_nonzero_pivots;
    if n_nonzero_pivots > maximum_number_of_nonzero_pivots
        warning('cmg:too_many_nonzero_pivots', ...
                'Number of pivots above maximum');
    end

end
