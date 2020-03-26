function [rp, rc, rpc, Rp, Rc, Zp, Zc] = calcpatternZscore(grating_resp, plaid_resp, comp_pred)
% function [rp, rc, rpc, Rp, Rc, Zp, Zc] = calcpatternZscore(grating_resp, plaid_resp, comp_pred)
%
% code from Najib Majaj and Chris Tailby - taken 2006 by Yasmine El-Shamayleh
% code from Yasmine El-Shamayleh - taken 2007 by Romesh Kumbhani
%
% made parallel by Romesh Kumbhani (2011-03-30)

[rows,cols] = size(grating_resp);
df = cols-3;

if exist('parfor','builtin')&&(rows>1000)
    if (matlabpool('size') <= 1)
        matlabpool open;
    end
    rp  = zeros(rows,1);
    rc  = zeros(rows,1);
    rpc = zeros(rows,1);
    parfor ii=1:rows
        rp_temp = corrcoef(plaid_resp(ii,:), grating_resp(ii,:));
        rp(ii,1) = rp_temp(1,2);
        rc_temp = corrcoef(plaid_resp(ii,:), comp_pred(ii,:));
        rc(ii,1) = rc_temp(1,2);
        rpc_temp = corrcoef(grating_resp(ii,:), comp_pred(ii,:));
        rpc(ii,1) = rpc_temp(1,2);
    end
else
    rp  = zeros(rows,1);
    rc  = zeros(rows,1);
    rpc = zeros(rows,1);
    for ii=1:rows
        rp_temp = corrcoef(plaid_resp(ii,:), grating_resp(ii,:));
        rp(ii,1) = rp_temp(1,2);
        rc_temp = corrcoef(plaid_resp(ii,:), comp_pred(ii,:));
        rc(ii,1) = rc_temp(1,2);
        rpc_temp = corrcoef(grating_resp(ii,:), comp_pred(ii,:));
        rpc(ii,1) = rpc_temp(1,2);
    end
end

Rp = (rp-(rc.*rpc))./(sqrt((1-rc.^2).*(1-rpc.^2)));
Rc = (rc-(rp.*rpc))./(sqrt((1-rp.^2).*(1-rpc.^2)));
Zp = ((0.5.*(log((1+Rp)./(1-Rp)))./(sqrt(1/df))));
Zc = ((0.5.*(log((1+Rc)./(1-Rc)))./(sqrt(1/df))));
