function dataSymbols = modulation(dataIn, modSize, modType)
if strcmp(modType, 'psk')
    dataSymbols = pskmod(dataIn, modSize, pi/4);
elseif strcmp(modType, 'qam')
    dataSymbols = qammod(dataIn, modSize, 'UnitAveragePower', true);
end
end