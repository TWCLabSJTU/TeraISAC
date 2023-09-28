function pilotBlock = generatePilotBlock(blockSize)
% generate Zadoff-Chu sequence
pilotBlock = exp(-1j * 3 * pi * ((0 : blockSize - 1).^2) / blockSize).';
end