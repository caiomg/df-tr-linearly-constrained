function [x, fval, status] = solve_quadratic_problem_matlab(H, g, ...
                                                      c, Aineq, ...
                                                      bineq, Aeq, ...
                                                      beq, lb, ub, x0)
    % SOLVE_QUADRATIC_PROBLEM_MATLAB - 
    %   
    if nargin <  10 || isempty(x0)
        x0 = zeros(size(g));
        lm = 0.5*(lb + ub);
        fin = isfinite(lm);
        x0(fin) = lm(fin);
        x0 = min(ub, max(lb, x0));
    end
    
    normH = norm(H, inf);
    
    if normH > 0
        f = @(x) quadratic(H, g, c, x);

        fmincon_options = optimoptions(@fmincon, 'Display', 'off', ...
                                       'Algorithm', 'interior-point', ...
                                       'SpecifyObjectiveGradient', true);
        [x, fval, exitflag] = fmincon(f, x0, Aineq, bineq, Aeq, beq, lb, ...
                                      ub, [], fmincon_options);
        if exitflag > 0 && exitflag ~= 3
            status = 0;
        else
            status = -200;
        end
    end
    if normH == 0 || status < 0 && normH <= 10*eps(norm(g))
        [x, fval, status] = ...
            solve_linear_problem_matlab(g, c, Aineq, bineq, Aeq, beq, lb, ub, x0);
    end
end