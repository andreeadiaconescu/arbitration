display('Using SPM12, version 6470');
display('Using physIO, version 861');
% remove all other toolboxes
restoredefaultpath;

[~,username] = unix('whoami');
username(end) = []; % remove trailing end of line character

if ismac
    
    switch username
        
        case 'drea' % Andreeas laptop
            addpath(genpath('/Users/drea/Dropbox/MadelineMSc/Code/WAGAD/'));
            addpath('/Users/drea/Documents/Toolboxes/spm12');
            
        otherwise % @Madeline: change to your own paths HERE
            
            addpath(genpath('/Users/mstecy/Dropbox/MadelineMSc/Code/WAGAD/'));
            addpath(genpath('/Users/mstecy/Desktop/IOIO_Wager_Computational_Model/PreprocessingSingleSubjectAnalysis/spm12'));
    end
    
else
    
    switch username
        case 'dandreea'
            addpath(genpath('/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/code/project'));
            addpath(genpath('/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/code/spm12'));
            addpath(genpath('/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/code/WAGAD_model'));
            
            addpath(genpath('/cluster/scratch_xl/shareholder/klaas/dandreea/WAGAD/code/batches'));
            
        case 'kasperla'
            addpath(genpath('/cluster/project/tnu/kasperla/WAGAD/code'));
            rmpath(genpath('/cluster/project/tnu/kasperla/WAGAD/code/Toolboxes/spm12'))
            addpath('/cluster/project/tnu/kasperla/WAGAD/code/Toolboxes/spm12');
    end