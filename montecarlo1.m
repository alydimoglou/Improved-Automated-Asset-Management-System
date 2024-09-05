function  x = montecarlo1( returns, prices,i)
%time periods
t= size(returns,1); 
% Price at time 0 for the ith asset
Price_0 = prices(end-(t-1),i);%prices at time 0;

% Drift (annualized)
Drift = .08; %0.08

% Volatility (annualized)
Vol = .4; 

% Valuation date
%Valuation = datetime(2012,1,1);

% Investment horizon date
%Horizon = datetime(2013,1,1);

% Risk-free rate
%RiskFreeRate = 0.03;

% Number of trials for the Monte Carlo simulation
NTRIALS = 10000;

% Length (in years) of the simulation
T = t/12;

% Number of periods per trial (approximately 100 periods per year)
NPERIODS = round(100*T);

% Length (in years) of each time step per period
dt = T/NPERIODS;

% Instantiate the gbm object
%need to generalize to i stocks #
StockGBM = gbm(Drift, Vol, 'StartState', Price_0);
% Run the simulation
Paths = StockGBM.simByEuler(NPERIODS, 'NTRIALS', NTRIALS, ...
        'DeltaTime', dt, 'Antithetic', true);
    %pretty sure theres smtg wrong w how im assigning this to paths
% plot(squeeze(Paths(:,:,1:1000)));
% title('Simulation of a Stock');
% xlabel('Time');
% ylabel('Price');

%The goal is to find the efficient portfolio frontier for the returns at 
% the horizon date. Hence, obtain the scenarios from the trials of the Monte Carlo 
% simulation at the end of the simulation period.
Price_T = squeeze(Paths(end, 1, :)); 

AssetScenarios = zeros(NTRIALS, 1);

% Strategy 1: Stock only
AssetScenarios(:, 1) = (Price_T - Price_0) ./ Price_0; %needs ot work for i assets
x = AssetScenarios;

% Stock only
% subplot(2,1,1);
% histogram(AssetScenarios(:,1),'Normalization','probability')
% title('Stock-Only Distribution')
% xlabel('Return')
% ylabel('Relative Probability')

%this is what I need to append to assetscenarios matrix
% 
% %CVAR efficient fronteir 
% p = PortfolioCVaR('Name','CVaR Portfolio Five Hedging Levels',...
%    'AssetList',{'Stock'},... %WRONG
%    'Scenarios', AssetScenarios, 'LowerBound', 0, ...
%    'Budget', 1, 'ProbabilityLevel', 0.95);
% 
% % Estimate the efficient frontier to obtain portfolio weights
% pwgt = estimateFrontier(p);
% 
% % Plot the efficient frontier
% figure;
% plotFrontier(p, pwgt);
% 
% %Mean-variance efficient frontier
% pmv = Portfolio('Name','Mean-Variance Portfolio Five Hedging Levels',...
%    'AssetList',{'Stock','Hedge50','Hedge75','Hedge90','Hedge95'});
% pmv = estimateAssetMoments(pmv, AssetScenarios);
% pmv = setDefaultConstraints(pmv);
% 
% % Estimate the efficient frontier to obtain portfolio weights
% pwgtmv = estimateFrontier(pmv);
% 
% % Plot the efficient frontier
% figure;
% plotFrontier(pmv, pwgtmv);
end