%% Illustration of simple CLT
clear;close all;
%% Simulation setting
n = 1000; % sample size
delta = 1/n;

MC = 9; % number of Monte Carlo trials
RV = zeros(MC,1);
se = zeros(MC,1);

sigma = ((1:n)'/n-0.6).^2 * 2 + 0.5;
IV = sum(sigma.^2) * delta;
figure;
plot((1:n)/n,sigma); xlabel('t'); ylabel('\sigma_t');
fprintf('IV = %f\n',IV);
%% Run Monte Carlo
for mc = 1:MC
    dW = randn(n,1) * sqrt(delta);
    r = sigma .* dW;
    RV(mc) = sum(r.^2);
    se(mc) = sqrt(2/3 * sum(r.^4));
end
e = RV - IV; % estimation error
%% Analyzing the estimation errors
figure; hist(e,200)
fprintf('Mean(error): %f\n',mean(e))
fprintf('Std(error): %f\n',std(e))
%% Estimated standard error
mean(se)
%% t statistics
t = e ./ se;
figure;
ksdensity(t);
hold on;
xgrid = linspace(-5,5,1000);
plot(xgrid,normpdf(xgrid),'r--')
legend('t stat','N(0,1)')

%% Coverage of 95% confidence interval
% Compute the probability of |t| <= 97.5% quantile of N(0,1)
mean(abs(t) <= norminv(0.975))

%% Table
z = norminv(0.95);
L90 = RV - z * se;
U90 = RV + z * se;
rvse = [RV se L90 U90];

figure;
plot(RV(1:20),'k-');
hold on;
plot(L90(1:20),'k--'); plot(U90(1:20),'k--');