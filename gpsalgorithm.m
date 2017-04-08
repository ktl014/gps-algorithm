%%set S values
S = [1;0;0]; %STrue location
S0 = [.9331;.25;.258819]; %Initial estimate of receiver location
Sl = [3.5852 2.9274 2.6612 1.4159; %Satelite positions
    2.07 2.9274 0 0;
    0 0 3.1712 3.8904];
b = 2.3454788068e-3; %true clock bias
ERmconv = 6.37e6;%Earth radius meter conversion
%set up pseudorange vector
y0 = zeros(4,1);
for i=1:4 % pseudorange values
    deltaSl = Sl(:,i) - S;
    y0(i,1) = norm(deltaSl)+b;
end

[solvedGrad,lossfunctGrad, poserrorGrad, clockbiasGrad] = estimateGrad(y0,Sl,S0,0,50000,0.25,S,b);
[solvedGauss, lossfunctGauss, poserrorGauss, clockbiasGauss] = estimateGauss(y0,Sl,S0,0,4,1,S,b);
%Gradient Descent Plots
figure(1);
subplot(3,1,1);
semilogy(lossfunctGrad);
title('Gradient Descent of Loss Function');
ylabel('Log Loss Function');
xlabel('Iterations');
subplot(3,1,2);
plot(poserrorGrad*ERmconv);
title('Gradient Descent Iterated Position Error');
ylabel('Position Error (m)');
xlabel('Iterations');
subplot(3,1,3);
plot(clockbiasGrad*ERmconv);
title('Gradient Descent Iterated Clock Bias Error');
ylabel('Clock Bias Error (m)');
xlabel('Iterations');
%Gauss Newton Plots
figure(2);
subplot(3,1,1);
semilogy(lossfunctGauss);
title('Gauss Newton of Loss Function');
ylabel('Log Loss Function');
xlabel('Iterations');
subplot(3,1,2);
plot(poserrorGauss*ERmconv);
title('Gauss Newton Iterated Position Error');
ylabel('Position Error (m)');
xlabel('Iterations');
subplot(3,1,3);
plot(clockbiasGauss*ERmconv);
title('Gauss Newton Iterated Clock Bias Error');
ylabel('Clock Bias Error (m)');
xlabel('Iterations');
