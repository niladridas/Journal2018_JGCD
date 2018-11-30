function P = Optimal_Transport(X_f,Y,cost,Aeq,Aeq_1,weight)
M = size(X_f,2);
% X_f = diag([1/1.52;1/(1.61*10^(-8));1/(1.61*10^(-7));1/(1.61*10^(-8));1/(1.61*10^(-8));5/(1.61*10^(-8))])*X_f;
tmpmax = max(abs(X_f),[],2);
X_fnew = diag(tmpmax)*X_f;
% X_f = diag([1/max(abs(1));1/(1.61*10^(-8));1/(1.61*10^(-7));1/(1.61*10^(-8));1/(1.61*10^(-8));5/(1.61*10^(-8))])*X_f;
D = cost(X_fnew);
W = weight(X_f,Y);
if any(isnan(W(:)))
    save('errorXf.mat','X_f');
    save('errorD.mat','D');
    save('errorW.mat','W');
    error('terminate')
end
D1 = reshape(D,[M*M,1]);
beq = (1/M)*ones(M,1);
A = [Aeq;Aeq_1];
options = optimoptions('linprog','Algorithm','dual-simplex','display', 'off');
% options = optimset('display', 'off');
x = linprog(D1,[],[],A,[beq;W'],zeros(M*M,1),[],[],options);
P = M.*x;
P = reshape(P,[M,M]);
end