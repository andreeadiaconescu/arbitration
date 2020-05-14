function [y, prob] = linear_1stlevelprecision_reward_social_sim(r, infStates, p)

% Get parameters
be0  = p(1);
be1  = p(2);
be2  = p(3);
be3  = p(4);
be4  = p(5);
be5  = p(6);
be6  = p(7);
ze   = p(8);
be_ch  = p(9);
be_wager  = p(10);

% Number of trials
n = size(infStates,1);

% Extract stimuli
u                 = r.u(:,1);
advice_card_space = r.u(:,3);

% Extract trajectories of interest from infStates
mu1hat_a = infStates(:,1,3);
mu1hat_r = infStates(:,1,1);
mu2hat_a = infStates(:,2,3);
mu2hat_r = infStates(:,2,1);
sa2hat_r = infStates(:,2,2);
sa2hat_a = infStates(:,2,4);
mu3hat_r = infStates(:,3,1);
mu3hat_a = infStates(:,3,3);

% Transform the card colour
transformed_mu1hat_r = mu1hat_r.^advice_card_space.*(1-mu1hat_r).^(1-advice_card_space);

%% Belief Vector
% Precision 1st level (i.e., Fisher information) vectors
px = 1./(mu1hat_a.*(1-mu1hat_a));
pc = 1./(mu1hat_r.*(1-mu1hat_r));

% Weight vectors 1st level
wx = ze.*px./(ze.*px + pc); % precision first level
wc = pc./(ze.*px + pc);

% Belief and Choice Noise
b              = wx.*mu1hat_a + wc.*transformed_mu1hat_r;

% Surprise
% ~~~~~~~~
poo = b.^u.*(1-b).^(1-u); % probability of observed outcome
surp = -log2(poo);

% Arbitration
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arbitration = wx;

% Inferential variance (aka informational or estimation uncertainty, ambiguity)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
inferv_a = tapas_sgm(mu2hat_a, 1).*(1 -tapas_sgm(mu2hat_a, 1)).*sa2hat_a; % transform down to 1st level
inferv_r = tapas_sgm(mu2hat_r, 1).*(1 -tapas_sgm(mu2hat_r, 1)).*sa2hat_r; % transform down to 1st level


% Phasic volatility (aka environmental or unexpected uncertainty)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
pv_a = tapas_sgm(mu2hat_a, 1).*(1-tapas_sgm(mu2hat_a, 1)).*exp(mu3hat_a); % transform down to 1st level
pv_r = tapas_sgm(mu2hat_r, 1).*(1-tapas_sgm(mu2hat_r, 1)).*exp(mu3hat_r); % transform down to 1st level

% Calculate predicted log-reaction time
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
logrt    = be0 + be1.*surp + be2.*arbitration + be3.*inferv_a + be4.*inferv_r + be5.*pv_a + be6.*pv_r;

% Initialize random number generator
rng('shuffle');

% Simulate
prob = b.^(be_ch)./(b.^(be_ch)+(1-b).^(be_ch));
y_wager = logrt+sqrt(be_wager)*randn(n, 1);
y_ch    = binornd(1, prob);

y = [y_ch, y_wager];

end