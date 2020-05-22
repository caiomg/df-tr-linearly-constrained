function [x, fval, status] = solve_linear_problem_matlab(f, c, Aineq, bineq, Aeq, beq, lb, ub, x0)
    
    
    linprog_problem.solver = 'linprog';
    linprog_problem.f = f;
    linprog_problem.lb = lb;
    linprog_problem.ub = ub;
    linprog_problem.Aineq = Aineq;
    linprog_problem.bineq = bineq;
    linprog_problem.Aeq = Aeq;
    linprog_problem.beq = beq;
    linprog_problem.options = optimoptions('linprog', ...
                                           'Display', 'off', ...
                                           'Algorithm', 'dual-simplex');
    try
        [x, ~, exitflag] = linprog(linprog_problem);
        fval = f'*x + c;
    catch linprog_error
        if strcmp(linprog_error.identifier, 'optim:linprog:CoefficientsTooLarge')
            exitflag = -1;
            linprog_problem.f = 0*f;
            % Just trying to return a feasible point
            x = linprog(linprog_problem);
            fval = f'*x + c;
        else
            rethrow(linprog_error);
        end
    end
    if exitflag >= 0
        status = 0;
    else
        status = -1;
    end
end
