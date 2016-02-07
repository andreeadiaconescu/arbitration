display('Using SPM12, version 6225');
display('Using physIO, version 861');
if ismac
    [~,username] = unix('whoami');
    username(end) = []; % remove trailing end of line character
    
    switch username
        
        case 'drea' % Andreeas laptop
            addpath(genpath('/Users/drea/Dropbox/MadelineMSc/Code/WAGAD/'));
            addpath(genpath('/Users/drea/Documents/MATLAB/spm12'));
            
        otherwise % @Madeline: change to your own paths HERE
            
            addpath(genpath('/Users/mstecy/Dropbox/MadelineMSc/Code/WAGAD/'));
            addpath(genpath('/Users/mstecy/Desktop/IOIO_Wager_Computational_Model/PreprocessingSingleSubjectAnalysis/spm12'));
    end
    
else
    addpath(genpath('/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/code/project'));
    addpath(genpath('/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/code/spm12'));
    addpath(genpath('/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/code/WAGAD_model'));
    
    addpath(genpath('/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/code/batches'));
end