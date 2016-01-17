matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'Behavioral Onsets File';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {{'/Users/drea/Dropbox/SPMZurich15/PracticalsPreprocessing/Preprocessing_Advanced/001_Upload_SPM15_PracticalsPreprocessing/example_physio_short/logs/onsets.txt'}};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'Physiological Logfile';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {{'/Users/drea/Dropbox/SPMZurich15/PracticalsPreprocessing/Preprocessing_Advanced/001_Upload_SPM15_PracticalsPreprocessing/example_physio_short/logs/phys.log'}};
matlabbatch{3}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'Realignment Parameter File';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {{'/Users/drea/Dropbox/SPMZurich15/PracticalsPreprocessing/Preprocessing_Advanced/001_Upload_SPM15_PracticalsPreprocessing/example_physio_short/fmri/rp_fmri.txt'}};
matlabbatch{4}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {'/Users/drea/Dropbox/SPMZurich15/PracticalsPreprocessing/Preprocessing_Advanced/001_Upload_SPM15_PracticalsPreprocessing/example_physio_short/glm'};
matlabbatch{4}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'first_level_2BF';
matlabbatch{5}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'Functional Images';
matlabbatch{5}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {{'/Users/drea/Dropbox/SPMZurich15/PracticalsPreprocessing/Preprocessing_Advanced/001_Upload_SPM15_PracticalsPreprocessing/example_physio_short/fmri/swufmri.nii'}};
matlabbatch{6}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'Structural Image (or Overlay)';
matlabbatch{6}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {{'/Users/drea/Dropbox/SPMZurich15/PracticalsPreprocessing/Preprocessing_Advanced/001_Upload_SPM15_PracticalsPreprocessing/example_physio_short/struct/wBrain.nii'}};
matlabbatch{7}.cfg_basicio.run_ops.call_matlab.inputs{1}.anyfile(1) = cfg_dep('Named File Selector: Behavioral Onsets File(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{7}.cfg_basicio.run_ops.call_matlab.inputs{2}.directory(1) = cfg_dep('Make Directory: Make Directory ''first_level_2BF''', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
matlabbatch{7}.cfg_basicio.run_ops.call_matlab.outputs{1}.filter.mat = true;
matlabbatch{7}.cfg_basicio.run_ops.call_matlab.fun = 'get_multiple_conditions_ioio';
matlabbatch{8}.spm.tools.physio.save_dir(1) = cfg_dep('Make Directory: Make Directory ''first_level_2BF''', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
matlabbatch{8}.spm.tools.physio.log_files.vendor = 'Philips';
matlabbatch{8}.spm.tools.physio.log_files.cardiac(1) = cfg_dep('Named File Selector: Physiological Logfile(1) - Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{8}.spm.tools.physio.log_files.respiration(1) = cfg_dep('Named File Selector: Physiological Logfile(1) - Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{8}.spm.tools.physio.log_files.scan_timing = {''};
matlabbatch{8}.spm.tools.physio.log_files.sampling_interval = [];
matlabbatch{8}.spm.tools.physio.log_files.relative_start_acquisition = 0;
matlabbatch{8}.spm.tools.physio.log_files.align_scan = 'first';
matlabbatch{8}.spm.tools.physio.sqpar.Nslices = 37;
matlabbatch{8}.spm.tools.physio.sqpar.NslicesPerBeat = [];
matlabbatch{8}.spm.tools.physio.sqpar.TR = 2.5;
matlabbatch{8}.spm.tools.physio.sqpar.Ndummies = 5;
matlabbatch{8}.spm.tools.physio.sqpar.Nscans = 100;
matlabbatch{8}.spm.tools.physio.sqpar.onset_slice = 19;
matlabbatch{8}.spm.tools.physio.sqpar.time_slice_to_slice = [];
matlabbatch{8}.spm.tools.physio.sqpar.Nprep = 6;
matlabbatch{8}.spm.tools.physio.thresh.scan_timing.gradient_log.grad_direction = 'y';
matlabbatch{8}.spm.tools.physio.thresh.scan_timing.gradient_log.zero = 0.5;
matlabbatch{8}.spm.tools.physio.thresh.scan_timing.gradient_log.slice = 0.6;
matlabbatch{8}.spm.tools.physio.thresh.scan_timing.gradient_log.vol = [];
matlabbatch{8}.spm.tools.physio.thresh.scan_timing.gradient_log.vol_spacing = 0.08;
matlabbatch{8}.spm.tools.physio.thresh.cardiac.modality = 'ECG';
matlabbatch{8}.spm.tools.physio.thresh.cardiac.initial_cpulse_select.auto_matched.min = 0.4;
matlabbatch{8}.spm.tools.physio.thresh.cardiac.initial_cpulse_select.auto_matched.file = 'initial_cpulse_kRpeakfile.mat';
matlabbatch{8}.spm.tools.physio.thresh.cardiac.posthoc_cpulse_select.off = struct([]);
matlabbatch{8}.spm.tools.physio.model.type = 'RETROICOR';
matlabbatch{8}.spm.tools.physio.model.order.c = 3;
matlabbatch{8}.spm.tools.physio.model.order.r = 4;
matlabbatch{8}.spm.tools.physio.model.order.cr = 1;
matlabbatch{8}.spm.tools.physio.model.order.orthogonalise = 'none';
matlabbatch{8}.spm.tools.physio.model.input_other_multiple_regressors(1) = cfg_dep('Named File Selector: Realignment Parameter File(1) - Files', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{8}.spm.tools.physio.model.output_multiple_regressors = 'multiple_regressors.txt';
matlabbatch{8}.spm.tools.physio.verbose.level = 2;
matlabbatch{8}.spm.tools.physio.verbose.fig_output_file = '';
matlabbatch{8}.spm.tools.physio.verbose.use_tabs = false;
matlabbatch{9}.spm.stats.fmri_spec.dir(1) = cfg_dep('Make Directory: Make Directory ''first_level_2BF''', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
matlabbatch{9}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{9}.spm.stats.fmri_spec.timing.RT = 2.5;
matlabbatch{9}.spm.stats.fmri_spec.timing.fmri_t = 37;
matlabbatch{9}.spm.stats.fmri_spec.timing.fmri_t0 = 19;
matlabbatch{9}.spm.stats.fmri_spec.sess.scans(1) = cfg_dep('Named File Selector: Functional Images(1) - Files', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{9}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{9}.spm.stats.fmri_spec.sess.multi(1) = cfg_dep('Call MATLAB function: Call MATLAB: output 1 - filter mat', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','outputs', '{}',{1}));
matlabbatch{9}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{9}.spm.stats.fmri_spec.sess.multi_reg(1) = cfg_dep('TAPAS PhysIO Toolbox: physiological noise regressors file', substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','physnoisereg'));
matlabbatch{9}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{9}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{9}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];
matlabbatch{9}.spm.stats.fmri_spec.volt = 1;
matlabbatch{9}.spm.stats.fmri_spec.global = 'None';
matlabbatch{9}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{9}.spm.stats.fmri_spec.mask = {''};
matlabbatch{9}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{10}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{9}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{10}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{10}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{11}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{11}.spm.stats.con.consess{1}.tconsess.name = 'cue_present';
matlabbatch{11}.spm.stats.con.consess{1}.tconsess.coltype.colconds.conweight = 1;
matlabbatch{11}.spm.stats.con.consess{1}.tconsess.coltype.colconds.colcond = 1;
matlabbatch{11}.spm.stats.con.consess{1}.tconsess.coltype.colconds.colbf = 1;
matlabbatch{11}.spm.stats.con.consess{1}.tconsess.coltype.colconds.colmod = 1;
matlabbatch{11}.spm.stats.con.consess{1}.tconsess.coltype.colconds.colmodord = 0;
matlabbatch{11}.spm.stats.con.consess{1}.tconsess.sessions = 1;
matlabbatch{11}.spm.stats.con.consess{2}.tconsess.name = 'decision_present';
matlabbatch{11}.spm.stats.con.consess{2}.tconsess.coltype.colconds.conweight = 1;
matlabbatch{11}.spm.stats.con.consess{2}.tconsess.coltype.colconds.colcond = 2;
matlabbatch{11}.spm.stats.con.consess{2}.tconsess.coltype.colconds.colbf = 1;
matlabbatch{11}.spm.stats.con.consess{2}.tconsess.coltype.colconds.colmod = 1;
matlabbatch{11}.spm.stats.con.consess{2}.tconsess.coltype.colconds.colmodord = 0;
matlabbatch{11}.spm.stats.con.consess{2}.tconsess.sessions = 1;
matlabbatch{11}.spm.stats.con.consess{3}.tconsess.name = 'response_subj';
matlabbatch{11}.spm.stats.con.consess{3}.tconsess.coltype.colconds.conweight = 1;
matlabbatch{11}.spm.stats.con.consess{3}.tconsess.coltype.colconds.colcond = 3;
matlabbatch{11}.spm.stats.con.consess{3}.tconsess.coltype.colconds.colbf = 1;
matlabbatch{11}.spm.stats.con.consess{3}.tconsess.coltype.colconds.colmod = 1;
matlabbatch{11}.spm.stats.con.consess{3}.tconsess.coltype.colconds.colmodord = 0;
matlabbatch{11}.spm.stats.con.consess{3}.tconsess.sessions = 1;
matlabbatch{11}.spm.stats.con.consess{4}.tconsess.name = 'outcome_present';
matlabbatch{11}.spm.stats.con.consess{4}.tconsess.coltype.colconds.conweight = 1;
matlabbatch{11}.spm.stats.con.consess{4}.tconsess.coltype.colconds.colcond = 4;
matlabbatch{11}.spm.stats.con.consess{4}.tconsess.coltype.colconds.colbf = 1;
matlabbatch{11}.spm.stats.con.consess{4}.tconsess.coltype.colconds.colmod = 1;
matlabbatch{11}.spm.stats.con.consess{4}.tconsess.coltype.colconds.colmodord = 0;
matlabbatch{11}.spm.stats.con.consess{4}.tconsess.sessions = 1;
matlabbatch{11}.spm.stats.con.consess{5}.fcon.name = 'Task Effects';
matlabbatch{11}.spm.stats.con.consess{5}.fcon.weights = [1 0 0 0 0 0 0 0
                                                         0 1 0 0 0 0 0 0
                                                         0 0 1 0 0 0 0 0
                                                         0 0 0 1 0 0 0 0
                                                         0 0 0 0 1 0 0 0
                                                         0 0 0 0 0 1 0 0
                                                         0 0 0 0 0 0 1 0
                                                         0 0 0 0 0 0 0 1];
matlabbatch{11}.spm.stats.con.consess{5}.fcon.sessrep = 'none';
matlabbatch{11}.spm.stats.con.consess{6}.fcon.name = 'Movement Regressors';
matlabbatch{11}.spm.stats.con.consess{6}.fcon.weights = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
matlabbatch{11}.spm.stats.con.consess{6}.fcon.sessrep = 'none';
matlabbatch{11}.spm.stats.con.consess{7}.fcon.name = 'Physiological Regressors';
%
matlabbatch{11}.spm.stats.con.consess{7}.fcon.weights = [0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0
                                                         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
%
matlabbatch{11}.spm.stats.con.consess{7}.fcon.sessrep = 'none';
matlabbatch{11}.spm.stats.con.delete = 1;
matlabbatch{12}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{11}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{12}.spm.stats.results.conspec.titlestr = '';
matlabbatch{12}.spm.stats.results.conspec.contrasts = Inf;
matlabbatch{12}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{12}.spm.stats.results.conspec.thresh = 0.05;
matlabbatch{12}.spm.stats.results.conspec.extent = 0;
matlabbatch{12}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{12}.spm.stats.results.units = 1;
matlabbatch{12}.spm.stats.results.print = 'ps';
matlabbatch{12}.spm.stats.results.write.none = 1;
