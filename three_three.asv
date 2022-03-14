clear all; clc; close all;

freqs = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 80, 120, 160, 200];

phases_1 = zeros(14,1);
phases_2 = zeros(14,1);
gain_1 = zeros(14,1);
gain_2 = zeros(14,1);

for i = 1:length(freqs)
    freq = freqs(i);
    data = load(strcat('velocity_response_freq_', num2str(freq), '.mat'));
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

c = 0;
Ts = 0.001;
m_1 = 0.000321; m_2 = 0.000174;
b_1 = 0.01; b_2 = 0.001;
d_1 = 0.846; d_2 = 0.0846;
k = 0.0473;
a_1 = 1; a_2 = 2; a_3 = 3;

sys1 = tf([(1/m_1) (b_2/m_1/m_2) (k/m_1/m_2)], [1 a_1 a_2 a_3])
sys2 = tf([(k/m_1/m_2)], [1 a_1 a_2 a_3])

figure
bode(sys1)
figure
bode(sys2)
