function [A,B,C,D,sys,sys_uy,P] = linearized_sys()

M = 1; %mass of the cart [Kg]
m = 1; %mass of the pendulum [Kg]
g = 9.81; %gravity [m/s2]
L = 0.5; %lenght of the pendulum
Kd = 10;

A = [0 1 0 0;
     0 -Kd/M m*g/M 0;
     0 0 0 1;
     0 -Kd/(L*M) m*g/L+g/L 0];

B = [0 0; 1/M 0; 0 0; 1/(L*M) 1/(L*m)];
C = [1 0 0 0;
     0 0 1 0];
D = [0 0;0 0];

states = {'x' 'x_dot' 'phi' 'phi_dot'};
inputs = {'u' 'dF'};
outputs = {'x'; 'phi'};

sys = ss(A,B,C,D,'statename',states,'inputname',inputs,'outputname',outputs);
sys_uy = ss(A,B(:,1),C,zeros(2,1),'statename',states,'inputname','u','outputname',outputs);
trnsf = zpk(tf(sys));

P(1,1) = minreal(trnsf(1,1));
P(2,1) = minreal(trnsf(2,1));
P(1,2) = minreal(trnsf(1,2));
P(2,2) = minreal(trnsf(2,2));


end

