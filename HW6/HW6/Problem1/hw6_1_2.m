clc
clear all
close all

load('data.mat');
plot_figs = 1;

%get the independent (xdat) and dependent (lat, lon) variables
xdat = data(:,1:116);
lat = data(:,117);
lon = data(:,118);

%offset dependent variables to make all positive
lat_off = 40;
lon_off = 90;
lat = lat + lat_off;
lon = lon + lon_off;

%do box-cox transformation
[lat_bc, L_lat] = boxcox(lat);
[lon_bc, L_lon] = boxcox(lon);

%add constants to include the intercepts
newx = [ones(size(xdat,1),1) xdat];

%perform straightforward linear regression
b_lat = regress(lat_bc,newx);
b_lon = regress(lon_bc,newx);

%predict the dependent variables based on the linear model
lat_p_bc = newx*b_lat;
lon_p_bc = newx*b_lon;

%do inverse box-cox on the predicted values
lat_p = (lat_p_bc.*L_lat + 1).^(1/L_lat);
lon_p = (lon_p_bc.*L_lon + 1).^(1/L_lon);

%calculate R-squared
Rsq_lat = 1 - sum((lat - lat_p).^2)/sum((lat - mean(lat)).^2);
Rsq_lon = 1 - sum((lon - lon_p).^2)/sum((lon - mean(lon)).^2);
display(Rsq_lat);
display(Rsq_lon);

%calculate R-squared
% Rsq_lat = 1 - sum((lat_bc - lat_p_bc).^2)/sum((lat_bc - mean(lat_bc)).^2);
% Rsq_lon = 1 - sum((lon_bc - lon_p_bc).^2)/sum((lon_bc - mean(lon_bc)).^2);
% display(Rsq_lat);
% display(Rsq_lon);

%show plots
if(plot_figs)
%     figure()
%     plot(lat, 'b*');
%     hold on; grid on;
%     plot(lat_p, 'r*');
%     legend('Observed','Predicted');
%     title('Observed and Predicted Latitude values');
%     ylabel('Latitude (degrees)');
%     xlabel('Index number');
%     
%     figure()
%     plot(lon, 'b*');
%     hold on; grid on;
%     plot(lon_p, 'r*');
%     legend('Observed','Predicted');
%     title('Observed and Predicted Longitude values');
%     ylabel('Longitude (degrees)');
%     xlabel('Index number');
    
    figure()
    plot((lat-lat_p), 'b');
    hold on; grid on;
    plot((lon-lon_p), 'r');
    legend('Latitude residuals','Longitude residuals');
    title('Latitude and Longitude Residuals');
    ylabel('Residuals');
    xlabel('Index number');
    
    figure()
    plot(lat-lat_off, lat_p-lat_off, 'b*');
    hold on; grid on;
    plot(lon-lon_off, lon_p-lon_off, 'r*');
    legend('Latitude','Longitude');
    title('Observed and Predicted values');
    ylabel('Predicted values');
    xlabel('Observed values');
end