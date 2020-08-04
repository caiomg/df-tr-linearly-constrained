function best_i = find_best_point(model, constraints, tolerances, f)
%FIND_BEST_POINT Searches for the best among model interpolation points
%   f (optional) is a function for comparison of points. It receives a
%   vector with the function values of each point in the model and returns
%   a corresponding numeric value

    points = model.points_abs;
    fvalues = model.fvalues;
    [dim, points_num] = size(points);

    if nargin < 4 || isempty(f)
        % The first value from the vector
        f = @(v) v(1);
    end    
        
    min_f = inf;
    best_i = 0;
    for k = 1:points_num
        if is_feasible_wrt_linear_constraints(points(:, k), constraints, tolerances)
            val = f(fvalues(:, k));
            if val < min_f
                min_f = val;
                best_i = k;
            end
        end
    end
    
end