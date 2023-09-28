function Ytf = OFDM_output(Xtf, deltaf, Ts, delay, Doppler)
[M, N] = size(Xtf);
Ytf = Xtf .* repmat(exp(1j * 2 * pi * Doppler * (0:1:(N-1)) * Ts), M, 1) .* repmat(exp(-1j * 2 * pi * (0:1:(M-1))' * deltaf * delay), 1, N);
end