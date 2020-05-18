function print_results_title()
    sep = '|';
    name_str = '    name    ';
    f_error_str = '  f error  ';
    f_evals_str = '  f evals  ';
    violation_str = ' violation ';

    title_line = [sep, name_str, ...
                  sep, f_error_str, ...
                  sep, f_evals_str, ...
                  sep, violation_str, ...
                  sep, newline];

    fprintf(1, '%s', title_line);

end