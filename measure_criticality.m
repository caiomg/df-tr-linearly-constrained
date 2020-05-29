function m = measure_criticality(model, constraints)
    % MEASURE_CRITICALITY gives the gradient of the model, calculated
    % in absolute coordinates in the current point.
    %

    % Just the gradient, measured on the tr_center
    [~, grad] = get_model_matrices(model, 0);
    
    % Projected gradient
    x_center = model.center_point();

    m = project_to_feasible_polytope(x_center - grad, constraints) ...
        - x_center;

end
