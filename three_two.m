clear all; clc; close all;

data1 = load("velocity_response_amp_15.mat");
c = 0;
Ts = 0.001;
m1 = 0.000321; m2 = 0.000174;
b1 = 0.01; b2 = 0.001;
d1 = 0.846; d2 = 0.0846;
k = 0.0473;

t = data1.t;
u = data1.u;

open('flexible_drive.mdl');
sim('flexible_drive.mdl');

figure
subplot(3, 1, 1)
plot(t, u);
ylabel('Voltage [V]');
subplot(3, 1, 2);
plot(t, data1.v1); hold on; 
plot(t, v1sim(1:8001));
ylabel('v1 [mm/s]');
legend('experimental', 'simualated');
subplot(3, 1, 3);
plot(t, data1.v2); hold on; 
plot(t, v2sim(1:8001));
ylabel('v2 [mm/s]');
legend('experimental', 'simualated');
