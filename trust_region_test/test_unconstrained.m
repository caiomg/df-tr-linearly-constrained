unconstrained_problems = {...
    'AKIVA', 'BEALE', 'BOXBODLS', 'BRKMCC', 'BROWNBS', 'CLIFF', 'CUBE', ...
'DANWOODLS', 'DENSCHNA', 'DENSCHNB', 'DENSCHNC', 'DENSCHNF', 'EXPFIT', ...
'GBRAINLS', 'HAIRY', 'HIMMELBB', 'HIMMELBG', 'HIMMELBH', 'JENSMP', ...
'MARATOSB', 'MEXHAT', 'MISRA1ALS', 'MISRA1BLS', 'MISRA1CLS', ...
'MISRA1DLS', 'POWELLBSLS', 'ROSENBR', 'S308', 'SISSER', 'ZANGWIL2', ...
'BARD', 'BENNETT5LS', 'BOX3', 'CHWIRUT1LS', 'CHWIRUT2LS', 'DENSCHND', ...
'DENSCHNE', 'ECKERLE4LS', 'ENGVAL2', 'GAUSSIAN', 'GROWTHLS', 'GULF', ...
'HATFLDD', 'HATFLDE', 'HELIX', 'HIELOW', 'LSC2LS', 'MEYER3', 'MGH10LS', ...
'RAT42LS', 'ALLINITU', 'BROWNDEN', 'HIMMELBF', 'KOWOSB', 'MGH09LS', ...
'PALMER5D', 'RAT43LS', 'ROSZMAN1LS', 'KIRBY2LS', 'MGH17LS', 'OSBORNEA', ...
'BIGGS6', 'LANCZOS1LS', 'LANCZOS2LS', 'LANCZOS3LS', 'PALMER5C', ...
'HAHN1LS', 'PALMER1D', 'THURBERLS', 'GAUSS1LS', 'GAUSS2LS', 'GAUSS3LS', ...
'PALMER1C', 'PALMER2C', 'PALMER3C', 'PALMER4C', 'PALMER6C', 'PALMER7C', ...
'PALMER8C', 'VIBRBEAM', 'VESUVIALS', 'VESUVIOLS', 'VESUVIOULS', ...
'ENSOLS', 'OSBORNEB', ...
};

n_problems = length(unconstrained_problems);
fminunc_options = optimoptions('fminunc', 'Display', 'off', ...
                               'SpecifyObjectiveGradient', false, ...
                               'Algorithm', 'quasi-newton');


warning('off', 'cmg:ill_conditioned_system')
warning('off', 'cmg:trial_not_decrease');
warning('off', 'cmg:geometry_degenerating');
selected_unconstrained = struct('name', unconstrained_problems);

if exist('solutions_reference_unconstrained', 'var') ~= 1
    solutions_reference_unconstrained = compute_solutions_fmincon(selected_unconstrained);
end

results_unconstrained(n_problems).fval_matlab = [];
results_unconstrained(n_problems).fval_trust = [];
results_unconstrained(n_problems).fcount_matlab = [];
results_unconstrained(n_problems).fcount_trust = [];
results_unconstrained(n_problems).name = '';

for n = 1:n_problems
    
    terminate_cutest_problem()

    problem_name = unconstrained_problems{n};
    results_unconstrained(n).name = problem_name;
    
    solution = solutions_reference_unconstrained(n).fval;

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
    options.iter_max = 1500;

    try
        [x_trust, fvalue_trust] = trust_region({f}, x0, f(x0), constraints, options);
        results_unconstrained(n).exception = [];
    catch this_exception
        x_trust = nan*x0;
        fvalue_trust = nan;
        results_unconstrained(n).test.exception = this_exception;
    end

    f_count_trust = counter.get_count();
    bound_violation = norm(max(0, lb - x_trust) + max(0, x_trust - ub), 1);

    results_unconstrained(n).fx = fvalue_trust;
    results_unconstrained(n).count = f_count_trust;
    results_unconstrained(n).viol = bound_violation;

    counter.reset_count();
    print_results_only(problem_name, solution - fvalue_trust, f_count_trust,  bound_violation)
    
    terminate_cutest_problem(problem_name, '../my_problems/')

end