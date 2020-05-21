problems_per_variables = {};

bcon_ind = [problem_data_bound_constrained(:).bound_constrained];
bncon_problems = problem_data_bound_constrained(bcon_ind);

max_vars = 15

for k = 1:max_vars
    selected_indices = [bncon_problems.variables] == k;
    selected_linear_problems = bncon_problems(selected_indices);
    n_bounds = [selected_linear_problems.bounds];
    [~, indices_problems] = sort(n_bounds);
    problems_per_variables{k} = selected_linear_problems(indices_problems);
end
selected_bound_constrained_problems = [problems_per_variables{:}];

bound_constrained_solutions = compute_solutions_fmincon(selected_bound_constrained_problems)