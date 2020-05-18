function formatting_results(name, error, evals, violation)

    values_line = [sep, sprintf('% 11s ', name)];
    values_line = [values_line, sep, sprintf('% +10.3g ', error)];
    values_line = [values_line, sep, sprintf('% 10d ', evals)];
    values_line = [values_line, sep, sprintf('% 10.3g ', violation)];

    values_line = [values_line, sep, newline];
    fprintf(1, '%s', values_line);

end
