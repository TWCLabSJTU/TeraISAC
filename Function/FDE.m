function equalizedData = FDE(rxData, HData, SNRdB)
C = conj(HData) ./ (conj(HData) .* HData + 10^(-SNRdB / 10));
equalizedData = rxData .* C;
end