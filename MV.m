function x = MV(mu, Q)
    p = Portfolio('AssetCovar',Q,'AssetMean',mu);
    p = setDefaultConstraints(p); % Long-only fully-invested portfolio
 
    % Find minimum variance portfolio
    x = p.estimateFrontierLimits('min');

end