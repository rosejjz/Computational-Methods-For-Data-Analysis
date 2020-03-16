close all; clear all; clc;
load handel
v = y';
L = 9;
n = length(v);
t = (1:length(v))/Fs;
k = (2*pi/L) * [0:(n-1)/2 -n/2:-1];
ks = fftshift(k);
plot(t,v);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Signal of Interest, v(n)');
%% Gaussian a = (0.01,1,10,100) dt = 0.1
a = [0.01,1,10,100];
dt = 0.1;
ts = 0:dt:L;

for j = 1:length(a)
    sgtspec = [];
    curr = a(j);
    for i = 1:length(ts)
        func = exp(-curr*(t-ts(i)).^2);
        sg = func.*v;
        sgt = fft(sg);
        sgtspec =[sgtspec; abs(fftshift(sgt))];
    end
    figure(j)
    pcolor(ts, ks, sgtspec.'), shading interp
    xlabel('Time(sec)');
    ylabel('Frequency(\omega)');
    title("Spectrogam through Gábor filtering with width = " + num2str(curr) + " and dt = 0.1");
    colormap(hot)
end

%% Gaussian a = 1 dt = (0.05,0.1,0.5,1)
a = 1;
dt = [0.05,0.1,1,3];

for j = 1:length(dt)
    sgtspec = [];
    ts = 0:dt(j):L;
    for i = 1:length(ts)
        func = exp(-a*(t-ts(i)).^2);
        sg = func.*v;
        sgt = fft(sg);
        sgtspec =[sgtspec; abs(fftshift(sgt))];
    end
    figure(j)
    pcolor(ts, ks, sgtspec.'), shading interp
    xlabel('Time(sec)');
    ylabel('Frequency(\omega)');
    title("Spectrogam through Gábor filtering with width = 1 and dt = " + num2str(dt(j)));
    colormap(hot)
end

%% Gaussian filter
sgtspec = [];
a = 10;
ts = 0:0.1:L;
for i = 1:length(ts)
    func = exp(-a*(t-ts(i)).^2);
    sg = func.*v;
    sgt = fft(sg);
    sgtspec =[sgtspec; abs(fftshift(sgt))];
end
subplot(3,1,1);
pcolor(ts, ks, sgtspec.'), shading interp
xlabel('Time(sec)');
ylabel('Frequency(\omega)');
title("Gaussian window");
colormap(hot)

% Mexican hat wavelet
sgtspec = [];
a = 0.5;
ts = 0:0.1:L;
for i = 1:length(ts)
    func = 2/(sqrt(3*a)*pi^(1/4))*(1-((t-ts(i))/a).^2).*exp(-(t-ts(i)).^2/(2*a^2));
    sg = func.*v;
    sgt = fft(sg);
    sgtspec =[sgtspec; abs(fftshift(sgt))];
end
subplot(3,1,2);
pcolor(ts, ks, sgtspec.'), shading interp
xlabel('Time(sec)');
ylabel('Frequency(\omega)');
title("Mexican hat wavelet");
colormap(hot)

% Step Function (Shannon) Window
sgtspec = [];
a = 1;
ts = 0:0.1:L;
for i = 1:length(ts)
    func = abs(t-ts(i));
    sg = func.*v;
    sgt = fft(sg);
    sgtspec =[sgtspec; abs(fftshift(sgt))];
end
subplot(3,1,3);
pcolor(ts, ks, sgtspec.'), shading interp
xlabel('Time(sec)');
ylabel('Frequency(\omega)');
title("Step Function (Shannon) Window");
colormap(hot)

%%
[y,Fs] = audioread('music1.wav');
y = y'/2;
tr_piano=length(y)/Fs; % record time in seconds
n = length(y);
L = tr_piano;
t = (1:length(y))/Fs;
k = (2*pi/L) * [0:(n-1)/2 -n/2:-1];
ks = fftshift(k);
pfreq = [];
sgtspec = [];

ts = 0:0.1:L;
a = 10;
for i = 1:length(ts)
    func = exp(-a*(t-ts(i)).^2);
    sg = func.*y;
    sgt = fft(sg);
    [V,I] = max(abs(sgt));
    pfreq = [pfreq; abs(k(I))];
    sgtspec =[sgtspec; abs(fftshift(sgt))/max(abs(sgt))];
end

figure(1)
plot(ts,pfreq/(2*pi))
title('Music Scroe of the piano');
xlabel('Time(sec)');
ylabel('Frequency(Hz)');

% subplot(2,1,2);
% pcolor(ts, ks, sgtspec.'), shading interp
% xlabel('Time(sec)');
% ylabel('Frequency(Hz)');
% title('Spectrogram of the piano');
% colormap(hot)



%%
[y,Fs] = audioread('music2.wav');
y = y'/2;
tr_piano=length(y)/Fs; % record time in seconds
n = length(y);
L = tr_piano;
t = (1:length(y))/Fs;
k = (2*pi/L) * [0:(n-1)/2 -n/2:-1];
ks = fftshift(k);
pfreq = [];
sgtspec = [];

ts = 0:0.1:L;
a = 50;
for i = 1:length(ts)
    func = exp(-a*(t-ts(i)).^2);
    sg = func.*y;
    sgt = fft(sg);
    [V,I] = max(abs(sgt));
    pfreq = [pfreq; abs(k(I))];
    sgtspec =[sgtspec; abs(fftshift(sgt))/max(abs(sgt))];
end

figure(1)
plot(ts,pfreq/(2*pi))
title('Music Scroe of the recorder');
xlabel('Time(sec)');
ylabel('Frequency(Hz)');
% 
% subplot(2,1,2);
% pcolor(ts, ks, sgtspec.'), shading interp
% xlabel('Time(sec)');
% ylabel('Frequency(Hz)');
% title('Spectrogram of the recorder');
% colormap(hot)
