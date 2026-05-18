function negLogCEI = constrainedei_v2(x, ObjectiveInfo, ConstraintInfo)
% negLogCEI = -log( EI(x) * prod_i P_feas_i(x) )
% Assumes:
%   predictor(x, ObjectiveInfo, 'NegLogEI') returns -log(EI(x))  (natural log)
%   predictor(x, Ci, 'Pfeas') returns P_feas_i(x) in [0,1]
% If your predictor has different option names/semantics, adapt the two calls below.

% --- objective: get -log(EI)
negLogEI = predictor(x, ObjectiveInfo, 'NegLogEI');   % MUST be natural log
% Fallback if you only have EI directly:
% EI = max(predictor(x, ObjectiveInfo, 'EI'), 0);
% negLogEI = -log(EI + eps);

% --- constraints: product of feasibility probabilities
m = numel(ConstraintInfo);
logP = 0.0;
for i = 1:m
    Pi = predictor(x, ConstraintInfo{i}, 'Pfeas');   % in [0,1]
    Pi = min(max(Pi, realmin), 1 - 1e-15);          % clamp away from 0/1
    logP = logP + log(Pi);                           % natural log
end

% --- final: negative log of EI * product P_feas
negLogCEI = -( -negLogEI + logP );   % = -log(EI) - log(prod P) = -log(EI*prod P)
% guard: if EI is numerically 0, push large
if ~isfinite(negLogCEI), negLogCEI = 1e12; end
end
