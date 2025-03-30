%% create MPC controller object with sample time
ts = 2e-2;

feedin = 1;
feedout = [1 2];
F_s = feedback(lin_sys_ss,K_s,feedin,feedout,-1);
F_s = minreal(F_s);
F_k = c2d(F_s,ts);

mpc1 = mpc(F_k, 0.02);
%% specify prediction horizon
mpc1.PredictionHorizon = 40;
%% specify control horizon
mpc1.ControlHorizon = 5;
%% specify nominal values for inputs and outputs
mpc1.Model.Nominal.U = [0;0];
mpc1.Model.Nominal.Y = [0;0];
%% specify scale factors for inputs and outputs
mpc1.MV(1).ScaleFactor = 100;
%% specify constraints for MV and MV Rate
mpc1.MV(1).Min = -200;
mpc1.MV(1).Max = 200;
mpc1.MV(1).RateMin = -10;
mpc1.MV(1).RateMax = 10;
%% specify constraints for OV
mpc1.OV(1).Min = -10;
mpc1.OV(1).Max = 10;
mpc1.OV(2).Min = -0.26;
mpc1.OV(2).Max = 0.26;
%% specify constraint softening for OV
mpc1.OV(1).MinECR = 0;
mpc1.OV(1).MaxECR = 0;
mpc1.OV(2).MinECR = 0;
mpc1.OV(2).MaxECR = 0.2;
%% specify overall adjustment factor applied to weights
beta = 3.3201;
%% specify weights
mpc1.Weights.MV = 1*beta;
mpc1.Weights.MVRate = 1/beta;
mpc1.Weights.OV = [1.2 1]*beta;
mpc1.Weights.ECR = 100000;
%% use custom input disturbance model
setindist(mpc1, 'model', mpc1_ModelID);
%% use custom output disturbance model
setoutdist(mpc1, 'model', mpc1_ModelOD);
%% use custom measurement noise model
mpc1.Model.Noise = mpc1_ModelMN;
%% specify simulation options
options = mpcsimopt();
options.RefLookAhead = 'off';
options.MDLookAhead = 'off';
options.Constraints = 'on';
options.OpenLoop = 'off';
%% run simulation
sim(mpc1, 501, mpc1_RefSignal, mpc1_MDSignal, options);
