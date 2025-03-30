function [F,FF, G, E, Q, R, Psi, Gamma, TH] = constr_matrix(sys, Hp,Hu,Hw, q_u, q_x, u_min,u_max, Du_min, Du_max, x_min,x_max, th_min,th_max)

A = sys.A;
B1 = sys.B(:,1);
Cz = sys.C;

n = size(A,1);
m = size(B1,2); %input
l = size(Cz,1); %output


%%Matrici dei vincoli

F = zeros(q_u*Hu,Hu*m);
FF = F;
F1 = -1*ones(q_u*Hu,1);
F = [F , F1];

E = F;

f1 = [1/u_min 0 0 0 0  -1];
f2 = [1/u_max 0 0 0 0 -1];

e1 = [1/Du_min 0 0 0 0 -1];
e2 = [1/Du_max 0 0 0 0  -1];

F(1:2,:) = [f1;f2];

E(1:2,:) = [e1;e2];


G = zeros(q_x*Hp,Hp*l);
G1 = -1*ones(q_x*Hp,1);
G = [G , G1];

G(1,1) = 1/x_min;
G(2,1) = 1/x_max;
G(3,2) = 1/th_min;
G(4,2) = 1/th_max;

for i=1:Hu-1

    f1i = circshift(f1(1:Hu), i);
    f2i = circshift(f2(1:Hu), i);
    
    F(2*i+1 : 2*i+2 , 1:Hu) = [f1i;f2i];

    e1i = circshift(e1(1:Hu), i);
    e2i = circshift(e2(1:Hu), i);
    
    E(2*i+1 : 2*i+2 , 1:Hu) = [e1i;e2i];
end

for i=1:Hu

    for j=i:Hu
        FF(:,i) = FF(:,i) + F(:,j);
    end
end

for i=1:Hp-1
    
    g1i = circshift(G(1,1:Hp*l), 2*i);
    g2i = circshift(G(2,1:Hp*l), 2*i);
    g3i = circshift(G(3,1:Hp*l), 2*i);
    g4i = circshift(G(4,1:Hp*l), 2*i);

    G(4*i+1 : 4*i+4 , 1:Hp*l) = [g1i;g2i;g3i;g4i];

end

Qi = [5e5 0 ; 0 1e3];
Q = kron(eye(Hp),Qi);


Ri = 1;
R = kron(eye(Hu),Ri);


%%Matrici PSI GAMMA THETA

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


Psi = CZ*Psi;
Gamma = CZ*Gamma;
TH = CZ*TH;
end
