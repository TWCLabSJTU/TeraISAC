function [alpha, delay, Doppler] = OTFS_estimation(Xdd, Ydd, T, P, K, initChannel)
[M, N] = size(Xdd);
deltaf = 1 / T;
ydd = Ydd(:);
ydd_ni = ydd;
if (~exist('initChannel', 'var'))
    alpha = zeros(1, P);
    delay = zeros(1, P);
    Doppler = zeros(1, P);
else
    alpha = initChannel(1, :);
    delay = initChannel(2, :);
    Doppler = initChannel(3, :);
    [~, maxGainIndex] = max(abs(alpha));
    for p = 1:P
        if p~= maxGainIndex
            ydd_ni = ydd_ni - alpha(p) * OTFS_output(Xdd, T, delay(p), Doppler(p));
        end
    end
end

for p = 1:P
    % phase I
    delayList = (0:1:(M-1)) * T / M;
    DopplerList = (-N/2:1:(N/2 - 1)) * deltaf / N;
    profile = zeros(M, N);
    for m = 1:length(delayList)
        for n = 1:length(DopplerList)
            ydd_p = OTFS_approximatedOutput(Xdd, T, delayList(m), DopplerList(n));
            profile(m, n) = abs(ydd_p' * ydd_ni)^2;
        end
    end
    [~, index] = max(profile(:));
    [mi, ni] = ind2sub(size(profile), index);
    % phase II
    phi = double( (sqrt(5) - 1) / 2);
    a1 = mi - 2; b1 = mi;
    a2 = ni - N/2 - 2; b2 = ni - N/2;
    for k = 1:K
        I1 = b1 - a1; I2 = b2 - a2;
        x1 = a1 + (1 - phi) * I1; x2 = a1 + phi * I1;
        y1 = a2 + (1 - phi) * I2; y2 = a2 + phi * I2;
        
        ydd_11 = OTFS_output(Xdd, T, x1 * T / M, y1 * deltaf / N);
        ydd_12 = OTFS_output(Xdd, T, x1 * T / M, y2 * deltaf / N);
        ydd_21 = OTFS_output(Xdd, T, x2 * T / M, y1 * deltaf / N);
        ydd_22 = OTFS_output(Xdd, T, x2 * T / M, y2 * deltaf / N);
        f11 = abs(ydd_11' * ydd_ni)^2;
        f12 = abs(ydd_12' * ydd_ni)^2;
        f21 = abs(ydd_21' * ydd_ni)^2;
        f22 = abs(ydd_22' * ydd_ni)^2;
        
        [~, fmax] = max([f11, f12, f21, f22]);
        switch fmax
            case 1, b1 = x2; b2 = y2;
            case 2, b1 = x2; a2 = y1;
            case 3, a1 = x1; b2 = y2;
            case 4, a1 = x1; a2 = y1;
        end
    end
    delay(p) = (a1 + b1) / 2 * T / M;
    Doppler(p) = (a2 + b2) / 2 * deltaf / N;
    Hp = OTFS_output(Xdd, T, delay(p), Doppler(p));
    alpha(p) = (Hp' * Hp ) \ (Hp' * ydd_ni);
    ydd_ni = ydd_ni - alpha(p) * Hp;
end
end