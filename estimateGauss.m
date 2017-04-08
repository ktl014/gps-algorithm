function [solvedGauss, lossfunct, poserror, clockbias] = estimateGauss(y0, Sl, s0, b0, maxSteps, alphaGauss, STrue, b)
%y0 ~ pseudorange vector
%Sl ~ Satelite position vectors
%s0 ~ Initial estimate for S
%b0 ~ Initial estimate for bias
%alphaGauss ~ Step size coefficients
%STrue ~ Actual receiver position
%b ~ Actual clock bias

%Gauss-Newton
xk = [s0;b0]; %Initial condition vector
y = y0;
stepsGauss = 0;
while stepsGauss < maxSteps
    Sk = xk(1:3); %Position
    bk = xk(4); %Clock bias
    for i=1:4
        deltaSl = Sk - Sl(:,i);
        Rl = norm(deltaSl); %True range
        rl(i,:) = deltaSl'/Rl; %Unit vector
        hx(i,1) = Rl + bk;
    end
    H = [rl ones(4,1)]; %Jacobian Matrix
    %Q = (H.'*H)^-1 %pseudoinverse H
    stepsGauss = stepsGauss + 1;
    xk = xk + alphaGauss*H\(y - hx); %Next iterated value of x

    %loss, position error, clock bias plot data
    lossfunct(stepsGauss) = .5*sum((y-hx).^2);
    poserror(stepsGauss) = norm(STrue-Sk);
    clockbias(stepsGauss) = abs(b-bk);
end
solvedGauss = xk(1:4);
end