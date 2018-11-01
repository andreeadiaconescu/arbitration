function pstruct = linear_1stlevelprecision_bayes_namep(pvec)
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, Andreea Diaconescu TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

pstruct = struct;

pstruct.be0 = pvec(1);
pstruct.be1 = pvec(2);
pstruct.be2 = pvec(3);
pstruct.be3 = pvec(4);
pstruct.be4 = pvec(5);
pstruct.be5 = pvec(6);
pstruct.be6 = pvec(7);
pstruct.ze  = pvec(8);
pstruct.be_ch  = pvec(9);
pstruct.be_wager  = pvec(10);

return;