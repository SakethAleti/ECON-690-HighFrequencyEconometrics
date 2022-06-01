% ---------------EXCERSIZE #2(COMPOUND POISSON PROCESS)-------------------
% SET PARAMETERS
n=80;
T=1.25*252;
sigma=0.011;
lamda=15/252;

% PART B(STIMULATE MODEL)
J1=jump(lamda,T,n,sigma); % calculate value of Jt
e_J1=exp(J1);% make exponential for log-jump
t=0:1/n:T; % construct observation time series
f2=figure('name','Time Series of  Exponential Jump(COMPOUND POISSON PROCESS)');
plot(t,e_J1);% plot of the simulated compound Poisson process
xlabel('Time(day)');
ylabel('Stimulation of Exponential Jump');
xlim([0,T]);
%------------------------END OF EXCERCIZE #2------------------------------