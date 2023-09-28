function s = OTFS_LMMSE(R, alpha, delay, Doppler, T, sigma_2)
[M, N] = size(R);
A = @(s, type) OTFS_operator(s, type, M, N, T, alpha, delay, Doppler);
s = cgls(A, R(:), sigma_2);
    function r = OTFS_operator(s, type, M, N, T, alpha, delay, Doppler)
        st = zeros(M*N, length(alpha));
        if type == 1
            for p = 1:length(alpha)
                lt = ceil(delay(p) / (T/ M));
                st(:, p) = alpha(p) * exp(1j * 2 * pi * Doppler(p) * (0:1:(M*N - 1)).' * T / M) .*...
                    circshift(reshape(ifft( repmat(exp(1j * 2 * pi * (0:1:(M-1)).' / M * (lt - delay(p) / (T / M))), 1, N) .* fft(reshape(s, M, N)) / sqrt(M) ) * sqrt(M) ,[], 1) , lt);
            end
        else
            for p = 1:length(alpha)
                lt = ceil(delay(p) / (T/ M));
                st(:, p) = alpha(p)' * reshape(ifft( repmat(exp(-1j * 2 * pi * (0:1:(M-1)).' / M * (lt - delay(p) / (T / M))), 1, N) .* fft(reshape(circshift( exp(-1j * 2 * pi * Doppler(p) * (0:1:(M*N - 1)).' * T / M) .* s, -lt), M, N)) / sqrt(M) ) * sqrt(M) ,[], 1);
            end
        end
        r = sum(st, 2);
    end
end