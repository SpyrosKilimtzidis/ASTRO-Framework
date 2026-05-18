function f = pred_v2(x, X, y, theta_log, U, cholLower)
% x in [0,1]^d, X in [0,1]^d, y matches training scaling
th = 10.^theta_log(:);
p  = 2;               % must match training
n  = size(X,1);
one = ones(n,1);

if cholLower
    mu  = (one' * (U'\(U\y))) / (one' * (U'\(U\one)));
    r   = y - mu*one;
    alpha = U'\(U\r);
else
    mu  = (one' * (U\(U'\y))) / (one' * (U\(U'\one)));
    r   = y - mu*one;
    alpha = U\(U'\r);
end

dx2 = abs(X - x).^p;         % n-by-d
psi = exp(-dx2 * th);        % n-by-1

f = mu + psi' * alpha;
end
