function [Xdd, txSignal] = OTFSmod(data, M, N, sigma_p)
sigma_d = 1 - sigma_p;
pilotAmplitude = sqrt(M * N * sigma_p / sigma_d);
pilot = zeros(M, N);
pilot(M/2, N/2) = pilotAmplitude;
ddSignal = data + pilot;
tfSignal = ISFFT(ddSignal, M, N);
txFrame = ifft(tfSignal) * sqrt(M);
txSignal = reshape(txFrame, [], 1);
Xdd = ddSignal;
end