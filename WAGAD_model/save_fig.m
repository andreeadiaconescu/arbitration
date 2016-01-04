function fnOut = save_fig(fh, type, pathSave, fn, res)
%save figure with current name as filename (with some removal of bad
%characters for saving
%
%  output = save_fig(fh, type, pathSave, fn)
%
% IN
%   fh          figure handle (default gcf) OR vector of figure handles
%   type        fig save file type (default 'png');
%   pathSave    path to save to (default pwd)
%   fn          file name (default: nice name created from figure name/title)
%   res         resolution
% OUT
%   fnOut       full name (incl path) of output file)
% EXAMPLE
%   save_fig
%
%   See also get_fig_name str2fn
%
% Author: Lars Kasper
% Created: 2013-11-07
% Copyright (C) 2013 Institute for Biomedical Engineering, ETH/Uni Zurich.
% $Id: save_fig.m 326 2013-11-16 18:01:17Z kasperla $
if ~nargin, fh = gcf;end

fhArray = fh;

for iFh = 1:length(fhArray)
    fh = fhArray(iFh);
    
    if nargin < 2, type = 'png';end
    if nargin < 3, pathSave = pwd; end
    if nargin < 4 || isempty(fn)
        fn = get_fig_name(fh,1);
    end
    if nargin < 5
        res = 300;
    end
    fnOut = fullfile(pathSave, [fn, '.', type]);
    set(fh, 'PaperPositionMode', 'auto');
    switch type
        case 'fig'
            saveas(fh, fnOut);
        otherwise
            switch type
                case 'eps'
                    dFormat = '-depsc2'; renderer = '-painter';
                case 'tif'
                    dFormat = 'dtiff'; renderer = '-OpenGL';
                case 'jpg'
                    dFormat = 'djpeg'; renderer = '-OpenGL';
                otherwise
                    dFormat = sprintf('-d%s',type);
            end
            print(fh, sprintf('-r%d',res), dFormat, fnOut);
    end
end