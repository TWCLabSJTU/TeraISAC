function commChannelParam = getCommChannelParam(fc, bandwidth, txBeamformingGain, rxBeamformingGain, LoSDistance, NLoSDistance, ReflectionLoss_dB, MaximumVelocity_kmh)
c0 = physconst('LightSpeed');
switch fc
    case(300e9)
        kappa = 2.17e-6;
        noiseFigure_dB = 10;
        Pt_dBm = 13;
    case(140e9)
        kappa = 0;
        noiseFigure_dB = 6;
        Pt_dBm = 13;
    otherwise
        kappa = 0;
        noiseFigure_dB = 6;
        Pt_dBm = 13;
end
lambda = c0 / fc;
antennaGain = txBeamformingGain + rxBeamformingGain;

pathDistance = [LoSDistance, NLoSDistance];
pathDelay = pathDistance / c0;
pathVelocityCos = cos(-pi + 2 * pi * rand(1, length(pathDistance)));
maxVelocity = MaximumVelocity_kmh / 3.6;
pathVelocity = maxVelocity * pathVelocityCos;
pathDoppler = pathVelocity * fc / c0;

pathSNRdB = getCommSNRdB(lambda, kappa, pathDistance, Pt_dBm, bandwidth, noiseFigure_dB, antennaGain, ReflectionLoss_dB);
normalizedSNRdB = pathSNRdB - max(pathSNRdB);
pathAlpha = sqrt(db2pow(normalizedSNRdB) / 2) .* (randn(size(normalizedSNRdB)) + 1j * randn(size(normalizedSNRdB)));

commChannelParam.pathDelay = pathDelay;
commChannelParam.pathDoppler = pathDoppler;
commChannelParam.pathCoefficient = pathAlpha;
commChannelParam.pathSNRdB = pathSNRdB;
commChannelParam.carrierFrequency = fc;
end