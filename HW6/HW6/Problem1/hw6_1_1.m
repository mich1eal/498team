clc
clear all
close all

load('data.mat');
plot_figs = 1;

%get the independent (xdat) and dependent (lat, lon) variables
xdat = data(:,1:116);
lat = data(:,117);
lon = data(:,118);

%add constants to include the intercepts
newx = [ones(size(xdat,1),1) xdat];

%perform straightforward linear regression
b_lat = regress(lat,newx);
b_lon = regress(lon,newx);

%predict the dependent variables based on the linear model
lat_p = newx*b_lat;
lon_p = newx*b_lon;

%calculate R-squared
Rsq_lat = 1 - sum((lat - lat_p).^2)/sum((lat - mean(lat)).^2);
Rsq_lon = 1 - sum((lon - lon_p).^2)/sum((lon - mean(lon)).^2);
display(Rsq_lat);
display(Rsq_lon);

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
%     
    figure()
    plot((lat-lat_p), 'b');
    hold on; grid on;
    plot((lon-lon_p), 'r');
    legend('Latitude residuals','Longitude residuals');
    title('Latitude and Longitude Residuals');
    ylabel('Residuals');
    xlabel('Index number');
    
    figure()
    plot(lat, lat_p, 'b*');
    hold on; grid on;
    plot(lon, lon_p, 'r*');
    legend('Latitude','Longitude');
    title('Observed and Predicted values');
    ylabel('Predicted values');
    xlabel('Observed values');
end