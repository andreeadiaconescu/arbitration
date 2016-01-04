matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'Behavioral Onset File';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {'<UNDEFINED>'};
matlabbatch{2}.cfg_basicio.run_ops.call_matlab.inputs{1}.anyfile(1) = cfg_dep('Named File Selector: Behavioral Onset File(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{2}.cfg_basicio.run_ops.call_matlab.inputs{2}.string = 'multiple_conditions.mat';
matlabbatch{2}.cfg_basicio.run_ops.call_matlab.outputs{1}.filter.mat = true;
matlabbatch{2}.cfg_basicio.run_ops.call_matlab.fun = 'get_multiple_conditions_ioio';
