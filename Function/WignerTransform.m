function tfSignal = WignerTransform(rxSignal, M, N)
tfSignal = reshape(rxSignal, M, N);
tfSignal = fft(tfSignal) / sqrt(M);
end
