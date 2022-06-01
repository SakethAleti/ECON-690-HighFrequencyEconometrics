function [j] =jump(lamda,T,n,sigma)
% simulate a Compound Poisson Process
% T is total observe time
% j is the array of accumulated jump at a specifit time from 0 to T
% n is the number of observations in every unit of time
% sigma is the standard variance of jump
  j=[];
  j(1)=0; % the initial value of jump (at t=0)
  N=random('poisson',lamda*T); % the number of total jumps follow a Poisson distribution with density lamda*T
  t=random('uniform',0,T,N,1); % the time of jumps follow a uniform distribution from (0,T)
  y=random('normal',0,(18*sigma)/sqrt(n),N,1);% the size of jumps follow normal distribution with mean=0,sd=(18*sigma)/sqrt(n)
  for i=1:T*n
      k=0;     
      for h=1:N % this loop aims at calculate the jumps which happens during time period ((i-1)/n,i/n)
         p=y(h)*indic((i-1)/n,i/n,t(h));
         k=k+p;
      end
      j(i+1)=j(i)+k;% accumulate jumps from time 0 to (i+1)/n
  end
end


