function sim_prc_traj(iParameter,iSubject)
pathroot='C:\Users\adiaconescu\Documents\HGF_Workshop\';
datapath=[pathroot 'data\'];
addpath([pathroot 'code\']);
savepath = [pathroot 'results\'];
rp_model= {'rp_voltemp'};
prc_model= {'hgf_binary3l_free_par'};

if ~nargin
    iParameter = 1;
    iSubject = 1;
end

switch iSubject
    case 1
        data = {'AB'};
    case 2
        data = {'seq_volatility'};
    case 3
        data = {'seq_no_volatility'};
end
    
switch iParameter
    case 1
        parArray=[0.02:0.1:0.72];
    case 2
        parArray=[-10.5:1.0:-1.5];
    case 3
        parArray=[0:0.1:0.9];
end

P=numel(parArray);
p_prc=zeros(P,7);
for m=1:numel(rp_model)
    for i=1:numel(prc_model)
fh = [];
sh = [];
lgh = NaN(1,P);
lgstr = cell(1,P);
        for par=1:P
            subj=data{1};
            df = ls(fullfile(datapath, [subj '.txt']));
            input_u = load(fullfile(datapath, df));
            if iSubject == 1;
            datafile = fullfile(datapath, df);
            [r,input_u, input_y] = read_IOIO(datafile);
            end
            switch iParameter
                case 1
                    ka=parArray(par);
                    p_prc=[0 1 1 1 ka -2 0.5];
                    lgstr{par} = sprintf('\\kappa = %3.1f', ka);
                case 2
                    om=parArray(par);
                    p_prc=[0 1 1 1 0.5 om 0.5];
                    lgstr{par} = sprintf('\\omega = %3.1f', om);
                case 3
                    th=parArray(par);
                    p_prc=[0 1 1 1 0.5 -2 th];
                    lgstr{par} = sprintf('\\theta = %3.1f', th);
            end
            
            sim = simResponses(input_u, prc_model{i}, p_prc, rp_model{m});
            if iSubject == 1;
                temp  = (input_y == sim.y);
                sim_actual_y = double(temp');
                accuracy=sum(sim_actual_y);
                lgstr{par} = sprintf('%s, accuracy = %d/%d trials correct', ...
                    lgstr{par}, accuracy, length(sim_actual_y));
            end
            colors=jet(P);
            currCol = colors(par,:);
            [fh, sh, lgh(par)] = hgf_plot_rainbowsim(par, fh, sh);
            save(fullfile(savepath, sprintf('%s', subj, 'sim_par_',num2str(iParameter), '_', num2str(par), '_' ,rp_model{m},prc_model{i})), 'sim');
        end
        legend(lgh, lgstr);
    end
end

%%
function [fh, sh, lgh] = hgf_plot_rainbowsim(par, fh, sh)
    currCol = colors(par,:);
    if isempty(fh)
        % Set up display
        scrsz = get(0,'screenSize');
        outerpos = [0.2*scrsz(3),0.2*scrsz(4),0.8*scrsz(3),0.8*scrsz(4)];
        
        fh = figure(...
            'OuterPosition', outerpos,...
            'Name','HGF binary fit results');
        % set(gcf,'DefaultAxesColorOrder',colors);
        sh(1) = subplot(3,1,1);
        sh(2) = subplot(3,1,2);
        sh(3) = subplot(3,1,3);        
    else
        figure(fh);
    end
% Number of trials
t = size(sim.u,1);

% Optional plotting of standard deviations (true or false)
plotsd2 = false;
plotsd3 = false;

% Subplots
axes(sh(1))
if plotsd3 == true
    upper3prior = sim.p_prc.mu3_0 +sqrt(sim.p_prc.sa3_0);
    lower3prior = sim.p_prc.mu3_0 -sqrt(sim.p_prc.sa3_0);
    upper3 = [upper3prior; sim.traj.mu(:,3)+sqrt(sim.traj.sa(:,3))];
    lower3 = [lower3prior; sim.traj.mu(:,3)-sqrt(sim.traj.sa(:,3))];
    
    plot(0, upper3prior, 'o', 'Color', currCol, 'LineWidth', 1);
    hold on;
    plot(0, lower3prior, 'o', 'Color', currCol,  'LineWidth', 1);
    fill([0:t, fliplr(0:t)], [(upper3)', fliplr((lower3)')], ...
         'FaceColor', currCol, 'EdgeAlpha', 0, 'FaceAlpha', 0.15);
end
plot(0:t, [sim.p_prc.mu3_0; sim.traj.mu(:,3)], 'Color', currCol, 'LineWidth', 2);
hold on;
plot(0, sim.p_prc.mu3_0, 'o','Color', currCol,  'LineWidth', 2); % prior
xlim([0 t]);
title('Posterior expectation \mu_3 of log-volatility of tendency x_3', 'FontWeight', 'bold');
xlabel('Trial number');
ylabel('\mu_3');

axes(sh(2));
if plotsd2 == true
    upper2prior = sim.p_prc.mu2_0 +sqrt(sim.p_prc.sa2_0);
    lower2prior = sim.p_prc.mu2_0 -sqrt(sim.p_prc.sa2_0);
    upper2 = [upper2prior; sim.traj.mu(:,2)+sqrt(sim.traj.sa(:,2))];
    lower2 = [lower2prior; sim.traj.mu(:,2)-sqrt(sim.traj.sa(:,2))];
    
    plot(0, upper2prior, 'o', 'Color', currCol,  'LineWidth', 1);
    hold all;
    plot(0, lower2prior, 'o', 'Color', currCol,  'LineWidth', 1);
    fill([0:t, fliplr(0:t)], [(upper2)', fliplr((lower2)')], ...
         'FaceColor', currCol, 'EdgeAlpha', 0, 'FaceAlpha', 0.15);
end
plot(0:t, [sim.p_prc.mu2_0; sim.traj.mu(:,2)], 'Color', currCol, 'LineWidth', 2);
hold on;
plot(0, sim.p_prc.mu2_0, 'o', 'Color', currCol,  'LineWidth', 2); % prior
xlim([0 t]);
title('Posterior expectation \mu_2 of tendency x_2', 'FontWeight', 'bold');
xlabel({'Trial number', ' '}); % A hack to get the relative subplot sizes right
ylabel('\mu_2');
% hold off;

axes(sh(3));
lgh = plot(0:t, [sgm(sim.p_prc.mu2_0, 1); sgm(sim.traj.mu(:,2), 1)],'Color', currCol, 'LineWidth', 2);
hold on;
plot(0, sgm(sim.p_prc.mu2_0, 1), 'o', 'Color', currCol,  'LineWidth', 2); % prior
plot(1:t, sim.u(:,1), 'o', 'Color', [0 0.6 0]); % inputs
if ~isempty(find(strcmp(fieldnames(sim),'y'))) && ~isempty(sim.y)
    y = stretch(sim.y(:,1), 1+0.16 + (par-1)*0.05);
    plot(1:t, y, '.', 'Color', currCol); % responses
    if iSubject ==1;
        sim_y_is_y = stretch(input_y, 1.32);
        plot(1:t, sim_y_is_y, '*', 'Color', 'r'); % responses that were congruent       
    end
    switch iParameter
        case 1
            title(['Input u (green), responses (rainbow) and posterior expectation of input s(\mu_2) for \omega=', num2str(sim.p_prc.om), ...
            ', \vartheta=', num2str(sim.p_prc.th)],'FontWeight', 'bold');
        case 2
            title(['Input u (green), responses (rainbow) and posterior expectation of input s(\mu_2) for \kappa=', num2str(sim.p_prc.ka), ...
            ', \vartheta=', num2str(sim.p_prc.th)],'FontWeight', 'bold');
        case 3
            title(['Input u (green), responses (rainbow) and posterior expectation of input s(\mu_2) for \kappa=', num2str(sim.p_prc.ka), ...
            ', \omega=', num2str(sim.p_prc.om)],'FontWeight', 'bold');
    end
    ylabel('y, u, s(\mu_2)');
    axis([0 t -0.35 1.35]);
else
    title(['Input u (green) and posterior expectation of input s(\mu_2) (red) for \kappa=', ...
           num2str(sim.p_prc.ka), ', \omega=', num2str(sim.p_prc.om), ', \vartheta=', num2str(sim.p_prc.th)], ...
      'FontWeight', 'bold');
    ylabel('u, s(\mu_2)');
    axis([0 t -0.1 1.1]);
end
plot(1:t, 0.5, 'k');
xlabel('Trial number');
% hold off;
end

end

function y = stretch(y, fac)
    y = y - 0.5;
    y = y*fac;
    y = y + 0.5;
end