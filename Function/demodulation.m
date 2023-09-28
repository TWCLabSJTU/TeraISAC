function demodulatedData = demodulation(data, modSize, modType)
if strcmp(modType, 'psk')
    demodulatedData = pskdemod(data, modSize, pi/4);
elseif strcmp(modType, 'qam')
    demodulatedData = qamdemod(data, modSize, 'UnitAveragePower', true);
end
end