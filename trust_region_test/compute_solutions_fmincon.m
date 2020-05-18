function solutions_fmincon = compute_solutions_fmincon(selected_problems)

    directory = '~/code/my_problems/';
    n_problems = numel(selected_problems);
    for k = 1:n_problems
        problem_name = selected_problems(k).name;
        [~, prob_interface] = setup_cutest_problem(problem_name, directory);
        constraints = setup_linear_constraints(prob_interface);
        
        f = @(x) prob_interface.evaluate_objective(x);
        x0 = prob_interface.x0;
        Aineq = constraints.Aineq;
        bineq = constraints.bineq;
        Aeq = constraints.Aeq;
        beq = constraints.beq;
        lb = constraints.lb;
        ub = constraints.ub;
        
        fmincon_options = optimoptions(@fmincon, 'Display', 'off', ...
                                       'Algorithm', 'interior-point', ...
                                       'SpecifyObjectiveGradient', true);
        try
        [x_fmincon, fval_fmincon, exitflag_fmincon] = ...
            fmincon(f, x0, Aineq, bineq, Aeq, beq, lb, ub, [], fmincon_options);
        catch erro
            'pass'
            %rethrow(erro);
            x_fmincon = nan*x0;
            fval_fmincon = nan;
            exitflag_fmincon = -inf;
        end
        bound_violation = norm(max(0, lb - x_fmincon) + max(0, x_fmincon - ub), 1);
        eqs_violation = norm(Aeq*x_fmincon - beq, 1);
        ineqs_violation = norm(max(0, Aineq*x_fmincon - bineq), 1);
        terminate_cutest_problem(problem_name, directory);
        solutions_fmincon(k).name = problem_name;
        solutions_fmincon(k).fval = fval_fmincon;
        solutions_fmincon(k).bound_violation = bound_violation;
        solutions_fmincon(k).linear_violation = eqs_violation + ineqs_violation;
        solutions_fmincon(k).status = exitflag_fmincon;
    end

end