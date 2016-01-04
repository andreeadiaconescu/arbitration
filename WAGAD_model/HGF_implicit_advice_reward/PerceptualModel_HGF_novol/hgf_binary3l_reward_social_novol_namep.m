function pstruct = hgf_binary3l_reward_social_novol_namep(pvec)
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.


pstruct = struct;

pstruct.mu2r_0 = pvec(1);
pstruct.sa2r_0 = pvec(2);
pstruct.mu3r_0 = pvec(3);
pstruct.sa3r_0 = pvec(4);
pstruct.ka_r    = pvec(5);
pstruct.om_r    = pvec(6);
pstruct.th_r    = pvec(7);

pstruct.mu2a_0 = pvec(8);
pstruct.sa2a_0 = pvec(9);
pstruct.mu3a_0 = pvec(10);
pstruct.sa3a_0 = pvec(11);
pstruct.ka_a    = pvec(12);
pstruct.om_a    = pvec(13);
pstruct.th_a    = pvec(14);

return;