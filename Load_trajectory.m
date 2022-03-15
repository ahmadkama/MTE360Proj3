traj = load('trajectory_data.mat')

%%
figure(99); % opens a figure window
  plot(t,s); % plots trajectory versus time
  title('A Simple Trajectory'); % creates a title for the plot
  ylabel('displacement [mm]'); % labels the y-axis
grid on;
  xlabel('Time [msec]') % labels the x-axis