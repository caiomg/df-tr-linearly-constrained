function x = project_to_bounds(x, lb, ub)

    if isempty(lb)
        lb = -inf(size(x));
    end
    if isempty(ub)
        ub = inf(size(x));
    end
    
    x = min(ub, max(lb, x));

end