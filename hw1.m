clear all; close all; clc;
load Testdata
 
%Basic set up
L = 15; % spatial domain
n = 64; % Fourier modes
x2 = linspace(-L,L,n+1); x = x2(1:n); y = x; z = x;
k = (2 * pi / (2 * L)) * [0:(n/2 - 1) -n/2:-1];
ks = fftshift(k);
[X,Y,Z] = meshgrid(x,y,z);
[Kx, Ky, Kz] = meshgrid(ks,ks,ks);
 
%fftn shift
avg = zeros(n,n,n);
for i = 1:20
    avg = avg + fftn(reshape(Undata(i,:),n,n,n));
end
 
%Normalize
avg = abs(fftshift(avg)) ./ max(abs(avg(:)));
figure(1)
isosurface(Kx,Ky,Kz,fftshift(avg),0.5)
grid on, drawnow
xlabel("Kx"), ylabel("Ky"), zlabel("Kz")
title("Normalized Fourier Transformed Data");
 
%Center frequency
[M, index] = max(avg(:));
[Xi, Yi, Zi] = ind2sub([n,n,n],index);
xc = ks(Yi);
yc = ks(Xi);
zc = ks(Zi);
 
%Gaussian Filter
bw = 0.1;
filter = exp(-bw * (Kx - xc).^2 + -bw * (Ky - yc).^2 + -bw * (Kz - zc).^2);
filter = fftshift(filter);

%Find Path
path = zeros(20,3);
for i = 1:20
    Unds(:,:,:) = reshape(Undata(i,:),n,n,n);
    dsf = filter.*fftn(Unds);
    dsf = ifftn(dsf);
    [M, i2] = max(abs(dsf(:)));
    [xp,yp,zp] = ind2sub([n,n,n], i2);
    path(i,1) = X(xp,yp,zp);
    path(i,2) = Y(xp,yp,zp);
    path(i,3) = Z(xp,yp,zp);
end
 
plot3(path(:,1),path(:,2),path(:,3),'b-<','LineWidth',2);
grid on, drawnow
title('The Path of the Marble');
xlabel("x"), ylabel("y"), zlabel("z")
hold on;
plot3(path(20,1),path(20,2),path(20,3),'*','MarkerSize',15);
