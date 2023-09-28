function [ BER ] = calculateBer(txData, rxData, bitsPerSymbol)
%calculate BER
errCount = sum(sum(de2bi(txData, bitsPerSymbol) ~= de2bi(rxData, bitsPerSymbol)));
BER = errCount / (numel(txData) * bitsPerSymbol);
end