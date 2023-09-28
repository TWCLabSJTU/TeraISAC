function tfSignal = ISFFT(ddSignal, M, N)
tfSignal = fft(ifft(ddSignal.').') * sqrt(N) / sqrt(M) ;
end