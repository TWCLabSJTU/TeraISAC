function ydd = OTFS_approximatedOutput(Xdd, T, delay, Doppler)
[M, N] = size(Xdd);
lt = ceil(delay / (T / M));
deltaf = 1 / T;
kn = ceil(Doppler / (deltaf / N));
Ydd = circshift(Xdd, [lt kn]);
ydd = Ydd(:);
end