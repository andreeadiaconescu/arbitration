function [pvec, pstruct] = tapas_rw_social_reward_transp(r, ptrans)
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, Andreea Diaconescu TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)       = tapas_sgm(ptrans(1),1); % vr_0
pstruct.vr_0  = pvec(1);
pvec(2)       = tapas_sgm(ptrans(2),1); % alpha_r
pstruct.al_r  = pvec(2);

pvec(1)       = tapas_sgm(ptrans(1),1); % va_0
pstruct.va_0  = pvec(3);
pvec(2)       = tapas_sgm(ptrans(2),1); % alpha_a
pstruct.al_a  = pvec(4);
return;