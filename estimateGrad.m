function [solvedGrad, lossfunct, poserror, clockbias] = estimateGPS(y0, Sl, s0, b0, maxSteps, alphaGrad, STrue, b)
%y0 ~ pseudorange vector
%Sl ~ Satelite position vectors
%s0 ~ Initial estimate for S
%b0 ~ Initial estimate for bias
%alphaGrad ~ Step size coefficients
%STrue ~ Actual receiver position
%b ~ Actual clock bias

%Gradient Descent
xk = [s0;b0]; %Initial condition vector
y = y0;
stepsGrad = 0;
while stepsGrad < maxSteps
    Sk = xk(1:3); %Position
    bk = xk(4); %Clock bias
    for i=1:4
        deltaSl = Sk - Sl(:,i);
        Rl = norm(deltaSl); %True range
        rl(i,:) = deltaSl'/Rl; %Unit vector
        hx(i,1) = Rl + bk;
    end
    H = [rl ones(4,1)]; %Jacobian Matrix
    stepsGrad = stepsGrad + 1;
    xk = xk + alphaGrad*H'*(y - hx); %Next iterated value of x
    
    %loss, position error, clock bias plot data
    lossfunct(stepsGrad) = .5*sum((y-hx).^2);
    poserror(stepsGrad) = norm(STrue-Sk);
    clockbias(stepsGrad) = abs(b-bk);
end
solvedGrad = xk(1:4);
end