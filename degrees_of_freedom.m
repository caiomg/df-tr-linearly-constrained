function n = degrees_of_freedom(constraints, x, tol)
% DEGREES_OF_FREEDOM - 
%   
    % dimension 
    dim = size(x, 1);
    
    if ~isempty(constraints.Aeq)
        Aext = constraints.Aeq;
        % bext = constraints.beq;
    else
        Aext = zeros(0, dim);
        % bext = [];
    end
    if ~isempty(constraints.lb) && ~isempty(constraints.ub)
        fixed_variables = constraints.ub - constraints.lb <= tol;
        B = diag(fixed_variables);
        Aext = [Aext;
                B(fixed_variables, :)];
    end
    n = dim - rank(Aext);
end
