function m = measure_criticality(model, constraints)
    % MEASURE_CRITICALITY gives the gradient of the model, calculated
    % in absolute coordinates in the current point.
    %
    %    - In the present work, the polynomial model is being calculated
    %    scaled, inside a ball of radius 1. Thus it has to be rescaled to
    %    absolute coordinates.
    %    
    %    - If one desires handle constraints, other criticality
    %    measures need to be considered

    if isfield(constraints, 'lb') && ~isempty(constraints.lb)
        lb = constraints.lb;
    else
        lb = -inf;
    end
    if isfield(constraints, 'ub') && ~isempty(constraints.ub)
        ub = constraints.ub;
    else
        ub = inf;
    end
    % Just the gradient, measured on the tr_center
    [~, grad] = get_model_matrices(model, 0);
    
    % Projected gradient
    x_center = model.center_point();
    m = min(ub, max(lb, (x_center - grad))) - x_center;

end
