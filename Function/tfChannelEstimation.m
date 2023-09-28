function HData = tfChannelEstimation(txPilot, rxPilot, M, N, PLoc, DLoc)
Hpilot = rxPilot ./ txPilot;
HData = zeros(M, N);
for q = 1:M
    HData(q, :) = interpolate(Hpilot(q, :), PLoc, N, 'linear');
end
HData = HData(:, DLoc);
end