function [Ks,K] = lqr_obs(sys)
%Progetto del controllore LQR

Q = [10 0 0 0;
     0 10 0 0;
     0 0 100 0;
     0 0 0 20];

R = 1;
B1 = sys.B(:,1);

K = lqr(sys.A,B1,Q,R);

ob = obsv(sys);

if(rank(ob) == order(sys))

    sys_pert = ss(sys.A, [B1 B1], sys.C, zeros(2,2) );
    [~, L_filt] = kalman(sys_pert,1e10,1);
    Ks = ss(sys.A-B1*K-L_filt*sys.C, L_filt, K, 0);
else 
    disp("Sistema non completamente osservabile.")
    Ks = 0;
    
end
