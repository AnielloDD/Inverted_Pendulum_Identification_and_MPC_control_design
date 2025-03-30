function [Kmpc, Psi, Gamma, TH, CZ, T, Q, R] = mpc_without_constr(sys,Hp,Hu)

A = sys.A;
B1 = sys.B(:,1);
Cz = sys.C;

n = size(A,1);
m = size(B1,2); %input
l = size(Cz,1); %output

%Definizione matrici per la predizione

Psi = zeros(n*Hp,n);
Gamma = zeros(n*Hp,m);
TH = zeros(n*Hp,m*Hu);
T = zeros(l*Hp,m);

j = 1;

for i=1:Hp

    %Costruzione matrice Psi
    A0 = A^i;
    Psi(j:n*i,:) = A0;

    %Costruzione matrice Gamma
    for k=0:i-1
        Gamma(j:n*i,:) = Gamma(j:n*i,:) + A^k*B1;
    end
    
    j = n*i+1;

    %Costruzione Reference Trajectory

    T(2*i-1) = 1;

end


for i=1:Hu
    TH(:,i) = circshift(Gamma,n*(i-1));

    if(i>1)
        TH(1:n*(i-1),i) = 0;
    end
end

CZ = kron(eye(Hp),Cz);

Qi = [5 0 ; 0 2];
Q = kron(eye(Hp),Qi);

Q(1:2 , 1:2) = [500 0 ; 0 2];
Q(3:4 , 3:4) = [500 0 ; 0 2];
Q(5:6 , 5:6) = [500 0 ; 0 2];
Q(7:8 , 7:8) = [500 0 ; 0 2]; % Ho modificato i pesi di Q per avere una minore sovraelongazione all'inizio

Ri = 1;
R = kron(eye(Hu),Ri);

R(1,1) = 0.01;
R(2,2) = 0.1;
R(3,3) = 0.5; % Ho modificato i pesi di R ai primi passi 
%per avere un tempo di assestamento adeguato, per avere 
% un segnale di controllo più aggressivo all'inizio

%%RefTraj
T(1:5,1) = 0;
Sq = chol(Q);
Sr = chol(R);

Psi = CZ*Psi;
Gamma = CZ*Gamma;
TH = CZ*TH;


Kfull = [Sq*TH ; Sr] \ [Sq ; zeros(Hu,length(Sq))];

Kmpc = Kfull(1,:);


end