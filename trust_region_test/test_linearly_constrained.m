warning('off', 'cmg:ill_conditioned_system')
warning('off', 'cmg:trial_not_decrease');
warning('off', 'cmg:geometry_degenerating');

results_linearly_constrained(n_problems).fval_matlab = [];
results_linearly_constrained(n_problems).fval_trust = [];
results_linearly_constrained(n_problems).fcount_matlab = [];
results_linearly_constrained(n_problems).fcount_trust = [];
results_linearly_constrained(n_problems).name = '';

print_results_title()
for n = 1:63
    
    terminate_cutest_problem()

    problem_name = solutions_linearly_constrained(n).name;
    solution = solutions_linearly_constrained.fval;
    results_linearly_constrained(n).name = problem_name;
    
    [prob, prob_interface] = setup_cutest_problem(problem_name, '../my_problems/');

    % Objective
    f_obj = @(x) prob_interface.evaluate_objective(x);
    counter = evaluation_counter(f_obj);
    counter.set_max_count(10000);
    f = @(x) counter.evaluate(x);

    x0 = prob_interface.x0;
    
    constraints = setup_linear_constraints(prob_interface);
    Aineq = constraints.Aineq;
    bineq = constraints.bineq;
    Aeq = constraints.Aeq;
    beq = constraints.beq;
    lb = constraints.lb;
    ub = constraints.ub;

    

    options = [];
    options.iter_max = 1000; % just not to hang. REMOVE
    try
        [x_trust, fvalue_trust] = trust_region({f}, x0, [], constraints, options);
        results_linearly_constrained(n).fx = fvalue_trust;
        [ineqs_violation, eqs_violation, bounds_violation] = ...
            linear_constraints_violation(x_trust, constraints);
        total_violation = bounds_violation + eqs_violation + ineqs_violation;
        total_violation = bound_violation + eqs_violation + ineqs_violation;
        results_linearly_constrained(n).viol = total_violation;
        results_linearly_constrained(n).exception = [];
    catch this_exception
        results_linearly_constrained(n).fx = inf;
        results_linearly_constrained(n).exception = this_exception;
        results_linearly_constrained(n).viol = nan;
    end
    results_linearly_constrained(n).count = counter.get_count();

    counter.reset_count();
    terminate_cutest_problem(problem_name, directory);
    
    

    print_results_only(problem_name, solution - results_linearly_constrained(n).fx, results_linearly_constrained(n).count,  results_linearly_constrained(n).viol)


end