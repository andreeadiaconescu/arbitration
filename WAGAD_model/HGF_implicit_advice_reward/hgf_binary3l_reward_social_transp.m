function [pvec, pstruct] = hgf_binary3l_reward_social_transp(r, ptrans)
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, Andreea Diaconescu TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.


pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)       = ptrans(1);                   % mu2r_0
pstruct.mu2r_0 = pvec(1);
pvec(2)       = exp(ptrans(2));              % sa2r_0
pstruct.sa2r_0 = pvec(2);
pvec(3)       = ptrans(3);                   % mu3r_0
pstruct.mu3r_0 = pvec(3);
pvec(4)     = exp(ptrans(4));                % sa3r_0
pstruct.sa3r_0 = pvec(4);
pvec(5)       = sgm(ptrans(5),r.c_prc.kaub_r); % ka_r
pstruct.ka_r    = pvec(5);
pvec(6)       = ptrans(6);                   % om_r
pstruct.om_r    = pvec(6);
pvec(7)       = sgm(ptrans(7),r.c_prc.thub_r); % th_r
pstruct.th_r    = pvec(7);

pvec(8)       = ptrans(8);                   % mu2a_0
pstruct.mu2a_0 = pvec(8);
pvec(9)       = exp(ptrans(9));              % sa2a_0
pstruct.sa2a_0 = pvec(9);
pvec(10)       = ptrans(10);                   % mu3a_0
pstruct.mu3a_0 = pvec(10);
pvec(11)     = exp(ptrans(11));                % sa3a_0
pstruct.sa3a_0 = pvec(11);
pvec(12)       = sgm(ptrans(12),r.c_prc.kaub_a); % ka_a
pstruct.ka_a    = pvec(12);
pvec(13)       = ptrans(13);                   % om_a
pstruct.om_a    = pvec(13);
pvec(14)       = sgm(ptrans(14),r.c_prc.thub_a); % th_a
pstruct.th_a    = pvec(14);

return;