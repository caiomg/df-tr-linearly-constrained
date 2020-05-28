function [ineqs_viol, eqs_viol, bounds_viol] = linear_constraints_violation(x, constraints)
% LINEAR_CONSTRAINTS_VIOLATION - 
%   
    if isempty(constraints.Aineq)
        ineqs_viol = 0;
    else
        ineqs_viol = norm(max(0, constraints.Aineq*x - constraints.bineq), inf);
    end
    if isempty(constraints.Aeq)
        eqs_viol = 0;
    else
        eqs_viol = norm(constraints.Aeq*x - constraints.beq, inf);
    end
    if isempty(constraints.lb)
        bounds_viol = 0;
    else
        bounds_viol = norm(max(0, constraints.lb - x), inf);
    end
    if ~isempty(constraints.ub)
        bounds_viol = bounds_viol + norm(max(0, x - constraints.ub), inf);
    end
end
