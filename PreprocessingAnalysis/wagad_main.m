function wagad_main

%% Performs all analysis steps at the single-subject and group level
% Important: you need to have access to the raw data; the path should be specified
% analysis options are defined in get_paths_wagad;

% First-level analysis
fprintf('\n===\n\t Running the first level analysis:\n\n');
wagad_first_level_analysis;

fprintf('\n===\n\t Running group-level analysis and printing tables:\n\n');
wagad_second_level_analysis;

fprintf('\n===\n\t Done!\n\n');
end