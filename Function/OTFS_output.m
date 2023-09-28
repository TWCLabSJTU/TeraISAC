function ydd = OTFS_output(Xdd, T, delay, Doppler)
[M, N] = size(Xdd);
lt = ceil(delay / (T / M));
deltaf = 1 / T;
Xtf = ISFFT(Xdd, M, N);
rt = exp(1j * 2 * pi * Doppler * (0:1:(M*N - 1))' * T / M) .* circshift(reshape(circshift(ifft(diag(exp(-1j * 2 * pi * (0:1:(M-1)) *  deltaf * delay)) * Xtf ) * sqrt(M), - lt ), [], 1), lt);
Rt = reshape(rt, M, N);
Ydd = fft(Rt.').' / sqrt(N);
ydd = Ydd(:);
end