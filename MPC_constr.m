function [dU,status,iA] = MPC_constr(e, Hu, TH, F,FF, G, E, Q, R, Z, u, iA)

H = TH'*Q*TH + R;
f = -2*TH'*Q*e;

ro = 1000000;

G_constr = G(:,1:end-1);
W = E(:,1:end-1);

Avinc = [FF ; G_constr*TH; W];
dim_A = size(Avinc,2);
r = size(Avinc,1);

A_slack = [Avinc, -eye(r); zeros(r,dim_A) , -eye(r)] ;

b1 = -FF(:,1)*u - F(:,end);
b2 = -G_constr*(Z) - G(:,end);
b3 = E(:,end);

b = [b1 ; b2 ; b3];

b_slack = [b ; zeros(r,1)];
Aeq = zeros(0,size(A_slack,2));
beq = zeros(0,1);

H_slack =  [2*H , zeros(5,r) ; zeros(r , 5) , ro*eye(r)];
f_slack = [f ; zeros(r,1)];


opt = mpcActiveSetOptions;


[dU1,status,iA,~] = mpcActiveSetSolver(H_slack,f_slack,A_slack,b_slack,Aeq,beq,iA,opt);


dU = dU1(1,1);


