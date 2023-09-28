function sensingChannelParam = getSensingChannelParam(fc, bandwidth, txBeamformingGain, rxBeamformingGain, targetDistance, targetVelocity, targetRCS)
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

targetDelay = range2time(targetDistance, c0);
targetDoppler = speed2dop(2 * targetVelocity, lambda);
targetSNRdB = getSensingSNRdB(lambda, kappa, targetDistance, targetRCS, Pt_dBm, bandwidth, noiseFigure_dB, antennaGain);
normalizedSNRdB = targetSNRdB - max(targetSNRdB);
targetAlpha = sqrt(db2pow(normalizedSNRdB)) .* exp(1j * 2 * pi * fc * targetDelay);

sensingChannelParam.pathDelay = targetDelay;
sensingChannelParam.pathDoppler = targetDoppler;
sensingChannelParam.targetSNRdB = targetSNRdB;
sensingChannelParam.pathCoefficient = targetAlpha;
sensingChannelParam.carrierFrequency = fc;
end