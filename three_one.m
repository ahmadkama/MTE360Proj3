clear all; clc; close all;

data1 = load("velocity_response_amp_15.mat");
data2 = load("velocity_response_amp_20.mat");


figure
title('Input and response with amplitude 1.5V');
subplot(2, 1, 1);
plot(data1.t, data1.v1, 'b'); hold on;
plot(data1.t, data1.v2, 'g');
legend('v1', 'v2');
ylabel('Velocity [mm/s]');
xlabel('time [s]');

subplot(2, 1, 2);
plot(data1.t, data1.u, 'r');
ylabel('Voltage [V]');
xlabel('time [s]');

figure
title('Input and response with amplitude 1.5V');
subplot(2, 1, 1);
plot(data2.t, data2.v1, 'b'); hold on;
plot(data2.t, data2.v2, 'g');
legend('v1', 'v2');
ylabel('Velocity [mm/s]');
xlabel('time [s]');

subplot(2, 1, 2);
plot(data2.t, data2.u, 'r');
ylabel('Voltage [V]');
xlabel('time [s]');


ss_a = zeros(200,1);
ss_a(1:100) = data1.v1(1901:2000);
ss_a(101:200) = data1.v2(1901:2000);
ss_a = mean(ss_a)

ss_b = zeros(200,1);
ss_b(1:100) = data2.v1(1901:2000);
ss_b(101:200) = data2.v2(1901:2000);
ss_b = mean(ss_b)

u_a = 1.5; u_b = 2.0;
d_t = (u_a * ss_b - u_b * ss_a) / (ss_b - ss_a)
b_t = (u_a - d_t) / ss_a

beta = 0.1; gamma = 0.1;
b_1 = b_t / (1 + beta)
b_2 = b_t - b_1
d_1 = d_t / (1 + gamma)
d_2 = d_t - d_1

ss_v_1 = mean(data2.v1(901:1000))
tau = find(data2.v1 < ss_v_1 * 0.63, 1) / 1000
p = 1 / tau

alpha = 0.54;
m_t = b_t / p
m_1 = m_t / (1 + alpha)
m_2 = m_t - m_1

a_1 = (m_1 * b_2 + m_2 * b_1) / (m_1 * m_2);

% i_first_peak = find(data2.v2(1:1000) == min(data2.v2(1:1000)), 1)
% i_second_peak = find(data2.v2(i_first_peak+10:1000) == min(data2.v2(i_first_peak+10:1000)), 1)
% period = (i_second_peak - i_first_peak) / 1000
% w_d = 2 * pi / period
period = 1.549 - 1.234;
w_d = 2*pi/period


%% iteration
delta = 11111111;
zeta = 0.1;
counter = 0;
while delta > 0.0001 && counter < 1000
    w_n = w_d/sqrt(1-zeta^2);
    k = m_1 * m_2 * w_n^2 / m_t;
    a_2 = (b_1 * b_2 + m_t * k) / (m_1 * m_2);
    a_3 = b_t * k / (m_1 * m_2);
    sys = tf([k/m_1/m_2], [1 a_1 a_2 a_3 0]);
    [Wn,Z,P] = damp(sys);
    delta = abs(zeta - Z(3));
    zeta = Z(3);
    counter = counter + 1;
end

delta
counter
w_n = w_d/sqrt(1-zeta^2)
k = m_1 * m_2 * w_n^2 / m_t
a_2 = (b_1 * b_2 + m_t * k) / (m_1 * m_2)
a_3 = b_t * k / (m_1 * m_2)
sys = tf([k/m_1/m_2], [1 a_1 a_2 a_3 0])
damp(sys)
figure
pzmap(sys)


%%
c = 0;
Ts = 0.001;
m1 = m_1; m2 = m_2;
b1 = b_1; b2 = b_2;
d1 = d_1; d2 = d_2;

t = data1.t;
u = data1.u;

open('flexible_drive.mdl');
sim('flexible_drive.mdl');

figure
subplot(3, 1, 1)
plot(t, u);
ylabel('Voltage [V]');
subplot(3, 1, 2);
plot(t, data1.v1); hold on; plot(t, v1sim(1:8001));
ylabel('v1 [mm/s]');
legend('experimental', 'simualated');
subplot(3, 1, 3);
plot(t, data1.v2); hold on; plot(t, v2sim(1:8001));
ylabel('v2 [mm/s]');
legend('experimental', 'simualated');

%%

freqs = [0.5, 1, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 8.0, 12.0, 16.0, 20.0];

phases_1 = zeros(14,1);
phases_2 = zeros(14,1);
gain_1 = zeros(14,1);
gain_2 = zeros(14,1);

for i = 1:length(freqs)
    freq = freqs(i);
    data = load(strcat('velocity_response_freq_', num2str(freq*10), '.mat'));
    [amp_1, phase_rad_1] = fit_sine_wave(data.t, data.v1, freq*2*pi);
    [amp_2, phase_rad_2] = fit_sine_wave(data.t, data.v2, freq*2*pi);

    gain_1(i) = amp_1 / 2.5;
    phases_1(i) = phase_rad_1 * 180 / pi;
    gain_2(i) = amp_2 / 2.5;
    phases_2(i) = phase_rad_2 * 180 / pi;
end

phases_1
phases_2
gain_1
gain_2

sys1 = tf([(1/m_1) (b_2/m_1/m_2) (k/m_1/m_2)], [1 a_1 a_2 a_3])
sys2 = tf([(k/m_1/m_2)], [1 a_1 a_2 a_3])

figure
bode(sys1)
figure
bode(sys2)
