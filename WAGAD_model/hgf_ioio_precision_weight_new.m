function logp = hgf_ioio_precision_weight_new(r, infStates, ptrans)
% Calculates the log-probability of response y=1 under the IOIO response model with
% precision-weighting of information sources.
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Transform zetas to their native space
ze1 = exp(ptrans(1));
ze2 = exp(ptrans(2));

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
logp = NaN(length(infStates(:,1,1)),1);

% Weed irregular trials out from inferred states, cue inputs, and responses
x = infStates(:,1,1);
x(r.irr) = [];

sa2hat = infStates(:,2,2);
sa2hat(r.irr) = [];

c = r.u(:,2);
c(r.irr) = [];

y = r.y(:,1);
y(r.irr) = [];

% Precision (i.e., Fisher information) vectors
px = 1./(x.*(1-x));
pc = 1./(c.*(1-c));

% Weight vectors

% wx = ze1.*px./(ze1.*px + pc);
% wc = pc./(ze1.*px + pc);

wx = ze1.*1./sa2hat.*px./(ze1.*px.*1./sa2hat + pc);
wc = pc./(ze1.*px.*1./sa2hat + pc);

% Belief vector
b = wx.*x + wc.*c;

% Calculate log-probabilities for non-irregular trials
logp(not(ismember(1:length(logp),r.irr))) = y.*ze2.*log(b./(1-b)) +log((1-b).^ze2 ./((1-b).^ze2 +b.^ze2));

return;
