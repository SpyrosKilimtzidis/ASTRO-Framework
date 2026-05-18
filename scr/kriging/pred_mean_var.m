function [f, s, cache] = pred_mean_var(x, X, y, theta_log, U, cholLower)
% [f,s] = pred_mean_var(x,X,y,theta_log,U,cholLower)
% Kriging mean and std prediction at 1-by-d point x (normalized).
% Inputs:
%   x         : 1-by-d point in [0,1]^d
%   X,y       : training data (n-by-d, n-by-1)
%   theta_log : log10-theta hyperparameters (d-by-1 or 1-by-d)
%   U         : Cholesky factor from likelihood_v3
%   cholLower : true if U=chol(...,'lower')
%
% Outputs:
%   f : predicted mean
%   s : predicted std (>=0)
%   cache : struct with mu, sigma2, alpha (optional)

    th = 10.^theta_log(:);  % theta as column
    p = 2;
    n = size(X,1);
    one = ones(n,1);

    % GLS mean
    if cholLower
        Ky = U\(y);   Ky = U'\Ky;        % K^{-1} y
        K1 = U\(one); K1 = U'\K1;        % K^{-1} 1
    else
        Ky = U'\(y);   Ky = U\Ky;
        K1 = U'\(one); K1 = U\K1;
    end
    mu = (one' * Ky) / (one' * K1);

    r = y - mu*one;
    if cholLower
        alpha = U'\(U\r);                % K^{-1} r
    else
        alpha = U\(U'\r);
    end
    sigma2 = (r' * alpha) / n;

    % Cross-correlation k(x)
    dx2 = abs(X - x).^p;
    k   = exp(-dx2 * th);

    % Mean
    f = mu + k' * alpha;

    % Variance
    if cholLower
        v     = U\k;
        Kinvk = U'\v;
    else
        v     = U'\k;
        Kinvk = U\v;
    end
    denom = max(one' * K1, realmin);
    c1 = 1 - one' * Kinvk;
    s2 = sigma2 * (1 - (k' * Kinvk) + (c1^2)/denom);
    s = sqrt(max(s2,0));

    if nargout > 2
        cache.mu = mu; cache.sigma2 = sigma2;
        cache.alpha = alpha; cache.cholLower = cholLower;
    end
end
