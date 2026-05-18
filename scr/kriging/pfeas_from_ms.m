function Pf = pfeas_from_ms(mu_g, s_g)
% Pf = pfeas_from_ms(mu_g, s_g)
% Probability that g(x) <= 0 given GP prediction (mu_g, s_g).
% Inputs:
%   mu_g : predicted mean of constraint
%   s_g  : predicted std of constraint
%
% Output:
%   Pf : probability of feasibility in [0,1]

    if s_g <= 1e-12
        Pf = double(mu_g <= 0); return;
    end

    z  = (0 - mu_g)/s_g;
    Pf = 0.5*(1+erf(z/sqrt(2)));

    % Clamp to avoid log(0)
    Pf = min(max(Pf, realmin), 1-1e-15);
end
