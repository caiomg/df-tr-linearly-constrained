function model = move_to_best_point(model, constraints, tolerances, f)
%MOVE_TO_BEST_POINT Changes TR center pointer to best point
%   f (optional) is a function for comparison of points. It receives a
%   vector with the function values of each point in the model and returns
%   a corresponding numeric value

    if nargin < 4
        f = [];
    end  

    best_i = find_best_point(model, constraints, tolerances, f);
    if best_i ~= model.tr_center && best_i ~= 0
        model.tr_center = best_i;
    elseif best_i == 0
        'debug';
    end
    % Here should rebuild polynomials!!!
    

end

