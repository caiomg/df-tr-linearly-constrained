function [result, barely_linear] = is_lambda_poised(model, constraints, options)
    % IS_LAMBDA_POISED tests wether a model is lambda-poised for the
    % given options
    %
    % Important: it assumes there is a finite radius_max defined.

    % pivot_threshold defines how well-poised we demmand a model to be
    relative_pivot_threshold = options.pivot_threshold;
    radius = model.radius;
    points_num = model.number_of_points();
    x_center = model.center_point();
    dim = size(x_center, 1); %dimension

    tolerance = min(1, radius)*relative_pivot_threshold;

    result = strcmp(options.basis, 'dummy') || points_num >= dim + 1;
    
    if ~result
        true_dim = degrees_of_freedom(constraints, x_center, tolerance);
        barely_linear = points_num >= true_dim + 1;
        result = result || barely_linear;
    else
        barely_linear = false;
    end
    
end
