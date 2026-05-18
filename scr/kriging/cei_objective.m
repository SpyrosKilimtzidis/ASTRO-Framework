function negLogCEI = cei_objective(x, Obj, Ctrs, f_best)
% negLogCEI = cei_objective(x, Obj, Ctrs, f_best)
% Constrained Expected Improvement objective (minimize this).
%
% Inputs
%   x      : 1-by-d point in normalized space [0,1]^d
%   Obj    : struct with fields X,y,theta_log,U,cholLower (objective GP)
%   Ctrs   : cell array of structs (one per constraint GP), each with
%            fields X,y,theta_log,U,cholLower. Feasible if g(x) <= 0.
%   f_best : current best FEASIBLE objective value (scalar). If no feasible
%            point exists yet, pass inf and the CEI will focus on feasibility.
%
% Output
%   negLogCEI : -log( EI(x) * prod_i P_feas_i(x) ), robustly clamped
%
% Notes
%   - Requires helper functions: pred_mean_var, ei_from_ms, pfeas_from_ms
%   - Uses natural logarithms for numerical stability

    % --- Ensure row vector and within [0,1] ---
    x = x(:)';                          % force row
    % (Optional) hard clamp to [0,1] to avoid numerical drift
    % x = min(max(x, 0), 1);

    % --- Objective EI ---
    [f, s] = pred_mean_var(x, Obj.X, Obj.y, Obj.theta_log, Obj.U, Obj.cholLower);

    if isinf(f_best) || isnan(f_best)
        % No feasible incumbent yet -> drive feasibility first
        EI = 0.0;
    else
        EI = ei_from_ms(f, s, f_best);
    end

    % --- Product of feasibility probabilities ---
    logP = 0.0;
    for i = 1:numel(Ctrs)
        [mu_g, s_g] = pred_mean_var(x, Ctrs{i}.X, Ctrs{i}.y, ...
                                       Ctrs{i}.theta_log, Ctrs{i}.U, Ctrs{i}.cholLower);
        Pf = pfeas_from_ms(mu_g, s_g);          % P(g_i(x) <= 0)
        % Clamp inside (0,1) to avoid log(0)
        Pf = min(max(Pf, realmin), 1-1e-15);
        logP = logP + log(Pf);                  % natural log
    end

    % --- Combine: CEI = EI * prod(Pf), return -log(CEI) ---
    CEI = EI * exp(logP);
    CEI = max(CEI, realmin);                    % guard
    negLogCEI = -log(CEI);

    % Final guard in case of unexpected NaN/Inf
    if ~isfinite(negLogCEI)
        negLogCEI = 1e12;
    end
end
