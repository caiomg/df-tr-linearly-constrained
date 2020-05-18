warning('off', 'cmg:ill_conditioned_system')
warning('off', 'cmg:trial_not_decrease');
warning('off', 'cmg:geometry_degenerating');
warning('off', 'cmg:initial_point_infeasible')

bound_constrained_(n_problems).fval_matlab = [];
results_bound_constrained(n_problems).fval_trust = [];
results_bound_constrained(n_problems).fcount_matlab = [];
results_bound_constrained(n_problems).fcount_trust = [];
results_bound_constrained(n_problems).name = '';

print_results_title()
for n = 1:numel(bound_constrained_solutions)
    
    terminate_cutest_problem()

    problem_name = bound_constrained_solutions(n).name;
    solution = bound_constrained_solutions(n).fval;
    results_bound_constrained(n).name = problem_name;
    
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
        [x_trust, fvalue_trust] = trust_region({f}, x0, f(x0), constraints, options);
        f_count_trust = counter.get_count();
        results_bound_constrained(n).fx = fvalue_trust;
        results_bound_constrained(n).count = f_count_trust;
        bound_violation = norm(max(0, lb - x_trust) + max(0, x_trust - ub), 1);
        eqs_violation = norm(Aeq*x_trust - beq, 1);
        ineqs_violation = norm(max(0, Aineq*x_trust - bineq), 1);
        total_violation = bound_violation + eqs_violation + ineqs_violation;
        results_bound_constrained(n).viol = total_violation;
        results_bound_constrained(n).exception = [];
    catch this_exception
        results_bound_constrained(n).fx = inf; fvalue_trust = nan;
        f_count_trust = counter.get_count();
        results_bound_constrained(n).count = f_count_trust;
        results_bound_constrained(n).exception = this_exception;
        results_bound_constrained(n).viol = nan;
    end

    counter.reset_count();
    terminate_cutest_problem(problem_name, directory);
    
    

    print_results_only(problem_name, solution - fvalue_trust, f_count_trust,  results_bound_constrained(n).viol)
    if ~isempty(results_bound_constrained(n).exception)
        'breakpoint'
    end
    'breakpoint line';

end