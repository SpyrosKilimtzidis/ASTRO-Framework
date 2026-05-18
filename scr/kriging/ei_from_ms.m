function EI = ei_from_ms(f, s, f_best)
% EI = ei_from_ms(f, s, f_best)
% Expected improvement at a candidate point.
% Inputs:
%   f      : predicted mean (objective)
%   s      : predicted std
%   f_best : current best feasible objective value
%
% Output:
%   EI : expected improvement (>=0)

    if s <= 1e-12 || isinf(f_best)
        EI = 0; return;
    end

    z   = (f_best - f) / s;
    Phi = 0.5*(1+erf(z/sqrt(2)));
    phi = exp(-0.5*z.^2)/sqrt(2*pi);

    EI = max((f_best - f).*Phi + s.*phi, 0);
end
