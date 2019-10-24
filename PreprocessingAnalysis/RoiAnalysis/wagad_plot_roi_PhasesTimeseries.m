function fh = wagad_plot_roi_PhasesTimeseries(t, y1, y3, ...
                y2, y4,nVoxels, nTrialsy1, nTrialsy3,...
                nTrialsy2, nTrialsy4,...
                stringTitle,colourLine)
%Plots mean (over trials) and s.e.m as shading for peristimulus time
%courses
%
%   fh = wagad_plot_roi_CombinedTimeseries(t1, y1, y2, nVoxels, nTrialsy1, nTrialsy2,stringTitle,colourLine);
%
% IN
%
% OUT
%
% EXAMPLE
%   wagad_plot_roi_CombinedTimeseries
%
%   See also wagad_extract_roi_timeseries tnueeg_line_with_shaded_errorbar

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

if nargin < 13
    fh = figure('Name', stringTitle);
end
tnueeg_line_with_shaded_errorbar(t, mean(y1)', std(y1)'./sqrt(nVoxels*nTrialsy1), colourLine{1});
hold all;
tnueeg_line_with_shaded_errorbar(t, mean(y2)', std(y2)'./sqrt(nVoxels*nTrialsy2), colourLine{2});
tnueeg_line_with_shaded_errorbar(t, mean(y3)', std(y3)'./sqrt(nVoxels*nTrialsy3), colourLine{3});
tnueeg_line_with_shaded_errorbar(t, mean(y4)', std(y4)'./sqrt(nVoxels*nTrialsy4), colourLine{4});
title(stringTitle);
xlabel('Peristimulus Time (seconds)');
ylabel('Signal Change (%)');
