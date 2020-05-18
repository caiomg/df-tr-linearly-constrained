function best_i = find_best_point(model, constraints, f)
%FIND_BEST_POINT Searches for the best among model interpolation points
%   f (optional) is a function for comparison of points. It receives a
%   vector with the function values of each point in the model and returns
%   a corresponding numeric value

    points = model.points_abs;
    fvalues = model.fvalues;
    [dim, points_num] = size(points);

    if isfield(constraints, 'lb')
        lb = constraints.lb;
    else
        lb = -inf(dim, 1);
    end
    if isfield(constraints, 'ub')
        ub = constraints.ub;
    else
        ub = inf(dim, 1);
    end
    if nargin < 3 || isempty(f)
        % The first value from the vector
        f = @(v) v(1);
    end    
        
    min_f = inf;
    best_i = 0;
    for k = 1:points_num
        if isempty(find(points(:, k) < lb | points(:, k) > ub, 1))
            val = f(fvalues(:, k));
            if val < min_f
                min_f = val;
                best_i = k;
            end
        end
    end
    
end