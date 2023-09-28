function SNRdB = getSensingSNRdB(lambda, kappa, r, RCS_dBsm, Pt_dBm, bandwidth, noiseFigure_dB, antennaGain_dB)
RCS = db2pow(RCS_dBsm);
pathLoss = lambda^2 * RCS .* exp(-2 * kappa * r) ./ ( (4 * pi)^3 * (r.^4 + 1e-4) );
Pt = db2pow(Pt_dBm - 30);

noisePowerDensity_dBm = -174;
noisePowerDensity = db2pow(noisePowerDensity_dBm - 30);
noisePower = bandwidth * noisePowerDensity * db2pow(noiseFigure_dB);

Pr = db2pow(antennaGain_dB) * Pt * pathLoss;
SNR = Pr / noisePower;
SNRdB = pow2db(SNR);
end