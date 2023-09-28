function [delayGrid, DopplerGrid, normalizedProfile] = OFDM_imaging(Xtf, Ytf, deltaf, Ts, P, K, delayLim, DopplerLim)
[M, N] = size(Xtf);
alpha = zeros(1, P);
delay = zeros(1, P);
Doppler = zeros(1, P);
ytf = Ytf(:);
ytf_ni = ytf;
for p = 1:P
    Ytf_ni = reshape(ytf_ni, [M N]);
    % phase I
    delayList = 0:1:(M-1);
    DopplerList = 0:1:(N-1);
    profile = fft(ifft(conj(Xtf) .* Ytf_ni).').';
    [~, index] = max(abs(profile(:)));
    [mi, ni] = ind2sub(size(profile), index);
    % phase II
    phi = double( (sqrt(5) - 1) / 2);
    a1 = delayList(mi) - 1; b1 = delayList(mi) + 1;
    if DopplerList(ni) < N/2
        a2 = DopplerList(ni) - 1; b2 = DopplerList(ni) + 1;
    else
        a2 = DopplerList(ni) - N - 1; b2 = DopplerList(ni) - N + 1;
    end
    for k = 1:K
        I1 = b1 - a1; I2 = b2 - a2;
        x1 = a1 + (1 - phi) * I1; x2 = a1 + phi * I1;
        y1 = a2 + (1 - phi) * I2; y2 = a2 + phi * I2;

        Ytf_11 = OFDM_output(Xtf, deltaf, Ts, x1 / (M * deltaf), y1 / (N * Ts));
        Ytf_12 = OFDM_output(Xtf, deltaf, Ts, x1 / (M * deltaf), y2 / (N * Ts));
        Ytf_21 = OFDM_output(Xtf, deltaf, Ts, x2 / (M * deltaf), y1 / (N * Ts));
        Ytf_22 = OFDM_output(Xtf, deltaf, Ts, x2 / (M * deltaf), y2 / (N * Ts));
        f11 = abs(sum(sum(conj(Ytf_11) .* Ytf_ni)))^2;
        f12 = abs(sum(sum(conj(Ytf_12) .* Ytf_ni)))^2;
        f21 = abs(sum(sum(conj(Ytf_21) .* Ytf_ni)))^2;
        f22 = abs(sum(sum(conj(Ytf_22) .* Ytf_ni)))^2;

        [~, fmax] = max([f11, f12, f21, f22]);
        switch fmax
            case 1, b1 = x2; b2 = y2;
            case 2, b1 = x2; a2 = y1;
            case 3, a1 = x1; b2 = y2;
            case 4, a1 = x1; a2 = y1;
        end
    end
    delay(p) = (a1 + b1) / 2 / (M * deltaf);
    Doppler(p) = (a2 + b2) / 2 / (N * Ts);
    Ytf_p = OFDM_output(Xtf, deltaf, Ts, delay(p), Doppler(p));
    ytf_p = Ytf_p(:);
    alpha(p) = (ytf_p' * ytf_p) \ (ytf_p' * ytf_ni);
    ytf_ni = ytf_ni - alpha(p) * ytf_p;
end

imagingProfile = zeros(length(DopplerLim), length(delayLim));
for p=1:P
    ytf_ni = Ytf(:);
    for pp=1:P
        if pp ~= p
            Ytf_p = OFDM_output(Xtf, deltaf, Ts, delay(pp), Doppler(pp));
            ytf_p = Ytf_p(:);
            ytf_ni = ytf_ni - alpha(pp) * ytf_p;
        end
    end
    Ytf_ni = reshape(ytf_ni, [M N]);
    delayDopplerProfile = zeros(length(DopplerLim), length(delayLim));
    for delayIndex = 1:length(delayLim)
        for DopplerIndex = 1:length(DopplerLim)
            if ((delayLim(delayIndex) - delay(p)) * deltaf)^2 + ((DopplerLim(DopplerIndex) - Doppler(p)) *Ts)^2 < (1/M^2 + 1/N^2) / 32
                Ytf_u = OFDM_output(Xtf, deltaf, Ts, delayLim(delayIndex), DopplerLim(DopplerIndex));
                delayDopplerProfile(DopplerIndex, delayIndex) = abs(sum(sum(conj(Ytf_u) .* Ytf_ni)))^2;
            end
        end
    end
%     delayDopplerProfile(delayDopplerProfile == 0) = 0.001 * max(max(delayDopplerProfile));
    imagingProfile = imagingProfile + delayDopplerProfile / max(max(delayDopplerProfile));
end
normalizedProfile = imagingProfile / max(max(imagingProfile));
[delayGrid, DopplerGrid] = meshgrid(delayLim, DopplerLim);
end