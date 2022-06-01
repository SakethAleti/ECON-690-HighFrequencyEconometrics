%% Illustration of simple CLT
clear;close all;
%% Simulation
n = 1000; % sample size
MC = 2000; % number of Monte Carlo trials
xbar = zeros(MC,1);
se = zeros(MC,1);
for mc = 1:MC
    z = randn(n,1);
    x = z.^2;
    xbar(mc) = mean(x);
    se(mc) = std(x)/sqrt(n);
end
e = xbar - 1;
%% Analyzing the estimation errors
figure;
hist(e,200)
fprintf('Mean(error): %f\n',mean(e))
fprintf('Std(error): %f\n',std(e))
%% Standard error
% Note that the varaince of x is 2
sqrt(2)/sqrt(n)

%% Estimated standard error
mean(se)

%% t statistics
t = (xbar - 1) ./ se;
figure;
ksdensity(t);
hold on;
xgrid = linspace(-5,5,1000);
plot(xgrid,normpdf(xgrid),'r--')
