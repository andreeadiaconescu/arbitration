function parsave_roi(fnSave, t, y, nVoxels, nTrials, stringTitle) 
% wrapper to save in parfor loop roi data from extract_timeseries
%
%    parsave_roi(fnSave, t, y, nVoxels, nTrials, stringTitle)
%
% IN
%
% OUT
%
% EXAMPLE
%   parsave_roi
%
%   See also wagad_extract_roi_timeseries

% Author:   Lars Kasper
% Created:  2019-05-26
% Copyright (C) 2019 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the TAPAS UniQC Toolbox, which is released
% under the terms of the GNU General Public License (GPL), version 3.
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%

save(fnSave, 't','y', 'nVoxels', 'nTrials', 'stringTitle');
