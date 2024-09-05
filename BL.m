function x = BL(periodReturns, benchRetn)
  
   % Black-Litterman Model - Assumes risk-free rate is 0
  
   % Find expected returns, cov matrix, and number of assets
   rets = periodReturns;
   mean_values = mean(rets,1);
   n = size(rets,2);
   Q = cov(rets);
  
   % C = tau*Q, where we use tau = 1/n
   tau = 1/size(rets, 1);
   C = tau*Q;
  
   % Views of the market by the investor (use average returns as view)
   v = n; %Total number of views
   P = zeros(v, n); %matrix of asset views that represents the investor's relative preferences
   q = zeros(v, 1); %represents the expected returns of the assets according to the investor's views
   Omega = zeros(v); %matrix of view uncertainties that represents the investor's uncertainty about their views
  
   for i = 1:n
       %cur_name = cell2mat(cellfun(@num2str, assetNames(i), 'UniformOutput', false));
       P(i, i) = 1;
       q(i) = mean_values(i);
       Omega(i,i) = 1e-5; %Strong investor views
   end
  
   % Convert Views to Monthly
   bizyear2bizday = 1/12;
   q = q*bizyear2bizday;
   Omega = Omega*bizyear2bizday;
  
   % Implement the equilibrium returns
   [wtsMarket, PI] = findMarketPortfolioAndImpliedReturn(rets, benchRetn);
   %You can compute μ and cov(μ) directly by using this matrix operation:
   mu_bl = (P'*(Omega\P) + inv(C)) \ ( C\PI + P'*(Omega\q));
   cov_mu = inv(P'*(Omega\P) + inv(C));
  
   % Use estimateMaxSharpeRatio with the Portfolio object to find allocations with the maximum Sharpe ratio
   portBL = Portfolio('NumAssets', n, 'lb', 0, 'budget', 1, 'Name', 'Mean Variance with Black-Litterman');
   portBL = setAssetMoments(portBL, mu_bl, Q + cov_mu); 
   portBL = setDefaultConstraints(portBL);
   portBL = setMinMaxNumAssets(portBL, round(n*0.5), []);  
   portBL = setBounds(portBL, 0.05, 'BoundType', 'conditional');
   x = estimateMaxSharpeRatio(portBL);
end
