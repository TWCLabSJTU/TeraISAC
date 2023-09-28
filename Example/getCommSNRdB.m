function SNRdB = getCommSNRdB(lambda, kappa, r, Pt_dBm, bandwidth, noiseFigure_dB, antennaGain_dB, reflectionLoss_dB)
FSPL = (lambda ./ (4 * pi * r)).^2 .* exp(-kappa * r);
FSPLdB = pow2db(FSPL);
pathGain_dB = FSPLdB + [0 -reflectionLoss_dB*ones(1, length(r)-1)];
pathGain = db2pow(pathGain_dB);
Pt = db2pow(Pt_dBm - 30);

noisePowerDensity_dBm = -174;
noisePowerDensity = db2pow(noisePowerDensity_dBm - 30);
noisePower = bandwidth * noisePowerDensity * db2pow(noiseFigure_dB);

Pr = db2pow(antennaGain_dB) * Pt * pathGain;
SNR = Pr / noisePower;
SNRdB = pow2db(SNR);
end