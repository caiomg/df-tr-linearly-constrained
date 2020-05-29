
problem_name = 'HEART8LS';
% problem_name = 'MGH10LS';
problem_name = 'ROSENBR';
% problem_name = 'WEEDS';
% problem_name = 'HS38';
% problem_name = 'HEART6LS';
% problem_name = 'STRATEC';
problem_name = 'HS4';
% problem_name = 'HS1';
% problem_name = 'HS45';
problem_name = 'HS35MOD';
% problem_name = 'OSBORNEB';
% problem_name = 'MDHOLE';

fminunc_options = optimoptions('fminunc', 'Display', 'off', ...
                               'SpecifyObjectiveGradient', false);
fmincon_options = optimoptions('fmincon', 'Display', 'off', ...
                               'Algorithm', 'sqp', ...
                               'SpecifyObjectiveGradient', false);
                         

[prob, prob_interface] = setup_cutest_problem(problem_name, '../my_problems/');

% Objective
f_obj = @(x) prob_interface.evaluate_objective(x);
counter = evaluation_counter(f_obj);
f = @(x) counter.evaluate(x);

x0 = prob.x;
bl = prob.bl;
bu = prob.bu;
% [x_fmin, fvalue_fmin] = fminunc(f, x0, fminunc_options)
[x_fmin, fvalue_fmin, exitflag] = fmincon(f, x0, [], [], [], [], ...
                                          bl, bu, [], ...
                                          fmincon_options)

f_count_fmincon = counter.get_count()
counter.reset_count()

                    
tr_options = struct('tol_radius', 1e-4, 'tol_f', 1e-5, ...
                    'eps_c', 1e-4, 'eta_0', 0, 'eta_1', 0.05, ...
                    'pivot_threshold', 0.001, 'add_threshold', 100, ...
                    'exchange_threshold', 1000,  ...
                    'initial_radius', 1, 'radius_max', 1e3, ...
                    'radius_factor', 6, ...
                    'gamma_inc', 2, 'gamma_dec', 0.5, ...
                    'criticality_mu', 100, 'criticality_beta', 10, ...
                    'criticality_omega', 0.5, 'basis', 'diagonal hessian', ...
                    'iter_max', 10000, 'print_level', 1);
tr_options = []
tr_options.print_level = 1;
tr_options.debug = true;
% tr_options.tol_radius = 1e-6;
tr_options.inspect_iteration = 25;
%tr_options.pivot_threshold = 0.05;

constraints = setup_linear_constraints(prob_interface);



x1 = [-0.66018183231354; 1.7615504264832];                
x_tr = x0;  %x_tr = [x0, x1]; 
fx = f(x0); %fx = [f(x0), f(x1)];
[x_trust, fvalue_trust] = trust_region({f}, x_tr, [], constraints, tr_options)

f_count_trust = counter.get_count()
counter.reset_count()

terminate_cutest_problem(problem_name, '../my_problems/')


