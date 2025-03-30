%Parameters value

M = 1; %mass of the cart [Kg]

m = 1; %mass of the pendulum [Kg]

g = 9.81; %gravity [m/s2]

L = 0.5; %lenght of the pendulum

Kd = 10; %Friction coefficientof the cart

%%Punto di equilibrio
x0 = zeros(4,1);
u0 = zeros(1,1);
u_nom = 0;
y_nom = [0 0];

Ts = 0.02; %Tempo di campionamento 
%[s] in base al polo più veloce del sistema cc con lqr
% Ts = 2pi/(10*wfast) che sta a -15

%%Linearized system

[A,B,C,D, lin_sys_ss, sys_uy, P] = linearized_sys();


%%Controller
[K_s,K] = lqr_obs(lin_sys_ss);


