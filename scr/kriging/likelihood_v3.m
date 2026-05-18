function [NegLnLike, Psi, U] = likelihood_v3(x, Model)
% [NegLnLike, Psi, U] = likelihood_v3(x, Model)
% Anisotropic SE (p=2) ordinary Kriging concentrated negative log-likelihood
% Inputs:
%   x      : 1-by-d (or d-by-1) vector, log10(theta)
%   Model  : struct with fields:
%              - X (n-by-d)  normalized design points in [0,1]^d
%              - y (n-by-1)  target values (use same scaling throughout)
% Outputs:
%   NegLnLike : N*log(sigma^2) + log|K|   (constants dropped)
%   Psi       : correlation matrix (no nugget on diagonal; 1 on diag)
%   U         : Cholesky factor of (Psi + eta*I) with 'lower' flag
%
% Notes:
% - Uses ordinary Kriging (unknown constant mean).
% - Kernel: k(x_i,x_j) = exp( -sum_k theta_k * |x_i(k) - x_j(k)|^2 ).
% - Adaptive nugget eta to ensure Cholesky factorization.
% - This U must be reused for prediction with lower-triangular solves.

    % ----- unpack -----
    X = Model.X;
    y = Model.y(:);
    [n, d] = size(X);

    % ----- hyperparameters -----
    theta = 10.^x(:);     % d-by-1
    p = 2;                % squared exponential

    % ----- build correlation matrix Psi (diag = 1) -----
    Psi = eye(n);
    for i = 1:n
    xi = X(i,:);
    for j = i+1:n
        dx2 = abs(xi - X(j,:)).^p;   % 1-by-d
        val = exp( - (dx2 * theta) );% scalar
        Psi(i,j) = val;
        Psi(j,i) = val;
    end
end

    % ----- adaptive nugget for numerical stability -----
    eta = 1e-8;          % start tiny
    max_eta = 1e-3;      % ceiling
    while true
        [U, pflag] = chol(Psi + eta*eye(n), 'lower');  % lower-triangular
        if pflag == 0
            break;
        end
        eta = eta * 10;
        if eta > max_eta
            % If still not PD, return a big penalty
            NegLnLike = 1e12; U = []; return;
        end
    end

    % ----- ordinary Kriging concentrated likelihood -----
    one = ones(n,1);

    % K^{-1}y and K^{-1}1 via Cholesky solves
    Ky = U \ y;     Ky = U' \ Ky;       % K^{-1} y
    K1 = U \ one;   K1 = U' \ K1;       % K^{-1} 1

    % GLS mean
    denom = one' * K1;
    if denom <= eps
        NegLnLike = 1e12; return;
    end
    mu = (one' * Ky) / denom;

    % residuals and K^{-1}r
    r = y - mu*one;
    Kr = U \ r;     Kr = U' \ Kr;       % K^{-1} r

    % process variance (concentrated MLE)
    sigma2 = (r' * Kr) / n;
    if ~isfinite(sigma2) || sigma2 <= 0
        NegLnLike = 1e12; return;
    end

    % log|K| from Cholesky (K = Psi + eta*I)
    LnDetK = 2 * sum(log(diag(U)));

    % concentrated negative log-likelihood (drop constants)
    NegLnLike = n*log(sigma2) + LnDetK;
end
