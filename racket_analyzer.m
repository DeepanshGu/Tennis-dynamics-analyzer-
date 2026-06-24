% TENNIS DYNAMICS HEATMAPPER: PHASE 1
% Modeling Racket Face Geometry and Vibrational Shock Profiles
clear; clc; close all;

disp('Generating Racket String Bed Matrix...');

% 1. Racket Face Dimensions (Standard Midplus Frame in cm)
a = 13.5; % Semi-minor axis (Half-width = 13.5 cm, Total width = 27 cm)
b = 18.0; % Semi-major axis (Half-height = 18.0 cm, Total height = 36 cm)

% 2. Create the Spatial Grid (X and Y coordinates)
x = linspace(-16, 16, 250);
y = linspace(-21, 21, 250);
[X, Y] = meshgrid(x, y);

% 3. Apply the Elliptical Boundary Condition (x^2/a^2 + y^2/b^2 = 1)
% This mathematically separates the inside of the frame from the outside empty space
racket_ellipse = (X./a).^2 + (Y./b).^2;
inside_frame = racket_ellipse <= 1;

% 4. Physics Engine: Structural Node & Energy Loss Model
% The sweet spot is typically centered slightly lower toward the throat (y = -3 cm)
y_sweet_spot = -3;
R_sweet = sqrt((X./a).^2 + ((Y - y_sweet_spot)./b).^2);

% Calculate the shock wave transmission coefficient
% 0 = Perfect Sweet Spot (No structural vibration)
% 1 = Maximum Shock (Hitting the stiff carbon fiber rim)
Shock_Profile = 1 - (1 - R_sweet).^3; 

% Mask out everything outside the physical racket frame
Shock_Profile(~inside_frame) = NaN;

% 5. Render the Heat Map
figure('Name', 'Racket Structural Dynamics', 'NumberTitle', 'off');
hold on;

% Create the colored energy contours
contourf(X, Y, Shock_Profile, 40, 'EdgeColor', 'none');
colormap(jet); % High intensity colors for high shock zones
c = colorbar;
c.Label.String = 'Structural Shock Transmission (Energy Loss)';

% Draw the actual carbon fiber frame outline for visual reference
theta = linspace(0, 2*pi, 200);
frame_x = a * cos(theta);
frame_y = b * sin(theta);
plot(frame_x, frame_y, 'k-', 'LineWidth', 3);

% Clean up the visual display
title('Tennis Racket Face Shock Absorption Map');
xlabel('Width (cm)');
ylabel('Height (cm)');
axis equal;
axis([-16 16 -21 21]);
grid on;

disp('Phase 1 Complete: Racket structural profile mapped successfully.');
% TENNIS DYNAMICS: PHASE 2 - POWER EFFICIENCY CALCULATION
% Calculate Power Efficiency Coefficient (PEC) based on position

% 1. Define the center of percussion (sweet spot)
x_ss = 0; y_ss = -3; 

% 2. Calculate distance from sweet spot for every point on the grid
dist_from_ss = sqrt((X - x_ss).^2 + (Y - y_ss).^2);

% 3. Efficiency Decay Function (Inverse Square Law)
% Efficiency drops as we move away from the vibrational node
PEC = 1 ./ (1 + 0.1 * dist_from_ss.^2);
PEC(~inside_frame) = NaN; % Keep it within the frame boundaries

% 4. Plot the Power Efficiency Heatmap
figure('Name', 'Power Efficiency Map', 'NumberTitle', 'off');
contourf(X, Y, PEC, 20, 'EdgeColor', 'none');
colormap(parula); % Professional engineering palette
colorbar;
hold on;
plot(frame_x, frame_y, 'k-', 'LineWidth', 3);
title('Power Efficiency Coefficient (PEC) Across String Bed');
xlabel('Width (cm)'); ylabel('Height (cm)');
axis equal; grid on;

% TENNIS DYNAMICS: PHASE 3 - VIBRATIONAL SHOCK MAPPING
% This calculates where the frame absorbs the most impact energy

% 1. Structural Flex Function
% Higher value = More frame flex (More vibration/Shock to the arm)
% Lower value = Stiff frame (Less vibration)
Shock_Map = (X.^2 / a^2) + ((Y - y_ss).^2 / b^2); 

% 2. Normalize and Invert to create a "Shock Intensity" map
Shock_Intensity = (Shock_Map - min(Shock_Map(:))) / (max(Shock_Map(:)) - min(Shock_Map(:)));
Shock_Intensity(~inside_frame) = NaN;

% 3. Plot the Shock Heatmap
figure('Name', 'Vibrational Shock Heatmap', 'NumberTitle', 'off');
contourf(X, Y, Shock_Intensity, 30, 'EdgeColor', 'none');
colormap(flipud(hot)); % Red/White for high-shock zones
colorbar;
hold on;
plot(frame_x, frame_y, 'k-', 'LineWidth', 3);
title('Vibrational Shock Transmission Map');
xlabel('Width (cm)'); ylabel('Height (cm)');
axis equal; grid on;
