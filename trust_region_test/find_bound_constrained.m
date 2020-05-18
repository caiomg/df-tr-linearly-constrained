directory = '../my_problems';
tentative_problems = dir(directory);
tentative_problems = tentative_problems([tentative_problems.isdir]);
all_problems = {tentative_problems.name};


n_problems = numel(all_problems);
problem_data = struct('name', {}, ...
                      'variables', {}, ...
                      'bounds', {}, ...
                      'constraints', {}, ...
                      'has_equalities', {}, ...
                      'has_inequalities', {}, ...
                      'bound_constrained', {});
BIG_M = 1e18;                  
prob_counter = 0;
for k = 1:n_problems
    problem_name = all_problems{k};
    executable = fullfile(directory, problem_name, 'mcutest.mexa64');
    if exist(executable, 'file') > 0
        terminate_cutest_problem();
        [prob, prob_interface] = setup_cutest_problem(problem_name, directory);
        prob_counter = prob_counter + 1;
        problem_data(prob_counter).name = problem_name;
        problem_data(prob_counter).variables = prob.n;
        
        problem_data(prob_counter).constraints = sum(prob.cl > -BIG_M) ...
                                                 + sum(prob.cu < BIG_M);
        problem_data(prob_counter).bounds = sum(prob.bl > -BIG_M) ...
                                                 + sum(prob.bu < BIG_M);

        if problem_data(prob_counter).constraints == 0 ...
                && problem_data(prob_counter).bounds > 1
            problem_data(prob_counter).bound_constrained = true;
        else
            problem_data(prob_counter).bound_constrained = false;
        end
        terminate_cutest_problem(problem_name, directory);
    else
        warning('cmg:prob_not_found', 'ABSENT %s\n', problem_name);
    end
end