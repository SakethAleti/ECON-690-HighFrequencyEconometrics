load('SPY1sec1week');
    % each column of p is 1-day of 1-sec SPY price
    % 5 days in the week of Aug 19, 2020 (5 columns)

    
%%
d = [];
for i = 1:30*60
    if mod(23400,i) == 0
        d = [d;i];
    end
end

%%
rv = zeros(size(d));
x = log(p);
for i = 1:length(d)
    tmpd = d(i);
    xs = x(1:tmpd:end,:);
    dxs = xs(2:end,:) - xs(1:end-1,:);
    rv(i) = sum(dxs(:).^2);
end

%%
figure;
plot([log(30),log(30)],1/10^4*[0.8,1.2],'g--'); hold on;
plot([log(60),log(60)],1/10^4*[0.8,1.2],'r--'); hold on;
plot([log(300),log(300)],1/10^4*[0.8,1.2],'b--'); hold on;
legend('30 sec','1 min','5 min')
plot(log(d),rv,'ks-');
    % plotting in log scale of delta for visual ease
xlabel('log(\Delta)'); ylabel('Weekly RV')
title('Sig. Plot for SPY, Week of Aug 19, 2020 (1 sec - 30 min)')
box off; legend boxoff;
set(gca,'fontname','times','fontsize',12)