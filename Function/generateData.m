function data = generateData(M, N, modSize, modType)
dataBits = generateBits(M * N, log2(modSize));
dataDe = bi2de(dataBits);
dataDe = reshape(dataDe, M, N);
data = modulation(dataDe, modSize, modType);
end