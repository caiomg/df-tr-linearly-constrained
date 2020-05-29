function result = is_lambda_poised(model, constraints, options)
    % IS_LAMBDA_POISED tests wether a model is lambda-poised for the
    % given options
    %
    % Important: it assumes there is a finite radius_max defined.

    % pivot_threshold defines how well-poised we demmand a model to be
    relative_pivot_threshold = options.pivot_threshold;
    radius = model.radius;
    points_num = model.number_of_points();
    x_center = model.center_point();

    tolerance = min(1, radius)*relative_pivot_threshold;
    true_dim = degrees_of_freedom(constraints, x_center, tolerance);

    if strcmp(options.basis, 'dummy')
        % If not modeling...
        result = true;
    else
        if points_num >= true_dim + 1
            % Fully linear, already
            result = true;
        else
            result = false;
        end
    end
end
