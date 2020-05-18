function model = move_to_best_point(model, constraints, f)
%MOVE_TO_BEST_POINT Changes TR center pointer to best point
%   bl, bu (optional) are lower and upper bounds on variables
%   f (optional) is a function for comparison of points. It receives a
%   vector with the function values of each point in the model and returns
%   a corresponding numeric value

    if nargin < 3
        f = [];
    end  

    best_i = find_best_point(model, constraints, f);
    if best_i ~= model.tr_center
        model.tr_center = best_i;
    end
    % Here should rebuild polynomials!!!
    

end

