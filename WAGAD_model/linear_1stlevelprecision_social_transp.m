function [pvec, pstruct] = linear_1stlevelprecision_social_transp(r, ptrans)
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2014 Christoph Mathys, UCL
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)     = ptrans(1);         % be0
pstruct.be0 = pvec(1);
pvec(2)     = ptrans(2);         % be1
pstruct.be1 = pvec(2);
pvec(3)     = ptrans(3);         % be2
pstruct.be2 = pvec(3);
pvec(4)     = ptrans(4);         % be3
pstruct.be3 = pvec(4);
pvec(5)     = ptrans(5);         % be4
pstruct.be4 = pvec(5);
pvec(6)     = ptrans(6);         % be5
pstruct.be5 = pvec(6);
pvec(7)     = ptrans(7);         % be6
pstruct.be6 = pvec(7);
pvec(8)     = exp(ptrans(8));    % ze
pstruct.ze  = pvec(8);
pvec(9)     = exp(ptrans(9));    % be_ch
pstruct.be_ch  = pvec(9);
pvec(10)     = exp(ptrans(10));    % be_wager
pstruct.be_wager  = pvec(10);

return;