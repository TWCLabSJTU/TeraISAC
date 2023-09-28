function [Xdd, txSignal] = DFTSOTFSmod(data, M, N, sigma_p)
ddData = fft(data.').' / sqrt(N);
[Xdd, txSignal] = OTFSmod(ddData, M, N, sigma_p);
end