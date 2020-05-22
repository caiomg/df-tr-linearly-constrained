function [x, fval] = trust_region(funcs, initial_points, initial_fvalues, ...
                                  constraints, options)
% TRUST_REGION - Derivative-free trust-region algorithm
%   


defaultoptions = struct('tol_radius', 1e-5, 'tol_f', 1e-6, ...
                        'eps_c', 1e-5, 'eta_0', 0, 'eta_1', 0.05, ...
                        'pivot_threshold', 1/16, 'add_threshold', 100, ...
                        'exchange_threshold', 1000,  ...
                        'initial_radius', 1, 'radius_max', 1e3, ...
                        'radius_factor', 6, ...
                        'radius_factor_extra_tol', 2, ...
                        'gamma_inc', 2, 'gamma_dec', 0.5, ...
                        'criticality_mu', 100, 'criticality_beta', 10, ...
                        'criticality_omega', 0.5, 'basis', 'diagonal hessian', ...
                        'iter_max', 10000, 'print_level', 0, ...
                        'debug', false, 'inspect_iteration', nan);

if nargin < 5
    options = [];
end
options = parse_trust_region_inputs(options, defaultoptions);
if nargin < 3
    initial_fvalues = [];
end
if isfield(constraints, 'lb')
    lb = constraints.lb;
else
    lb = [];
end
if isfield(constraints, 'ub')
        ub = constraints.ub;
else
    ub = [];
end

if (~isempty(lb) && ~isempty(find(initial_points(:, 1) < lb, 1))) || ...
        (~isempty(ub) && ~isempty(find(initial_points(:, 1) > ub, 1)))
    % Initial point not satisfying bounds
    warning('cmg:initial_point_infeasible', ...
            'Initial point out of bounds. Point will be replaced');
    if isempty(initial_fvalues)
        % Replace
        initial_points(:, 1) = project_to_bounds(initial_points(:, 1), lb, ub);
    else
        initial_points(:, 1) = project_to_bounds(initial_points(:, 1), lb, ub);
        initial_fvalues(:, 1) = evaluate_new_fvalues(funcs, ...
                                                     initial_points(:, 1));
    end
end

rel_pivot_threshold = options.pivot_threshold;
initial_radius = options.initial_radius;

if min(ub - lb) < initial_radius*rel_pivot_threshold
    error('cmg:not_implemented', 'Bounds too tight. Not yet implemented');
end


n_initial_points = size(initial_points, 2);
if n_initial_points == 1
    % Finding a random second point
    old_seed = rng('default');
    second_point = rand(size(initial_points));
    rng(old_seed);
    while norm(second_point, inf) < rel_pivot_threshold
        % Second point must not be too close
        second_point = 2*second_point;
    end
    second_point = (second_point - 0.5)*initial_radius;
    second_point = initial_points(:, 1) + second_point;
    if ~isempty(ub)
        second_point = min(ub, second_point);
    end
    if ~isempty(lb)
        second_point = max(lb, second_point);
    end
    initial_points(:, 2) = second_point;
    n_initial_points = 2;
end
% Calculating function values for other points of the set
n_initial_fvalues = size(initial_fvalues, 2);
for k = n_initial_fvalues + 1:n_initial_points
    initial_fvalues(:, k) = evaluate_new_fvalues(funcs, initial_points(:, k));
end
% Checking if one of the starting points is unsuited for interpolation
if ~isempty(find(~isfinite(initial_fvalues), 1))
    error('cmg:bad_starting_point', 'Bad starting point');
end

% Initializing model structure
model = tr_model(initial_points, initial_fvalues, initial_radius);
model = rebuild_model(model, options);
model = move_to_best_point(model, constraints);

model.modeling_polynomials = compute_polynomial_models(model);
if model.number_of_points < 2
    [model, exitflag] = ensure_improvement(model, funcs, constraints, options);
end


[x, fval] = trust_region_main_iteration(funcs, model, constraints, options);

end
