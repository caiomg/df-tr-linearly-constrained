function result = is_complete(model)
%IS_COMPLETE True if there are no more places to include points

    result = isempty(find(model.pivot_values == 0, 1));

end

