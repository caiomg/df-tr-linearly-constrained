problems_per_variables = {};

lcon_ind = [problem_data(:).linearly_constrained];
lincon_problems = problem_data(lcon_ind);

max_vars = 15

for k = 1:max_vars
    selected_indices = [lincon_problems.variables] == k;
    selected_linear_problems = lincon_problems(selected_indices);
    n_constraints = [selected_linear_problems.constraints];
    [~, indices_problems] = sort(n_constraints);
    problems_per_variables{k} = selected_linear_problems(indices_problems);
end
selected_problems = [problems_per_variables{:}];