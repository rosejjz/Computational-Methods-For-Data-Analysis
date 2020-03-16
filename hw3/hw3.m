close all; clear all; clc;

%% load data and basic setup
for i = 1:3
    for j = 1:4
        load(['cam' num2str(i) '_' num2str(j) '.mat']);
    end
end

n11 = size(vidFrames1_1,4);
n21 = size(vidFrames2_1,4);
n31 = size(vidFrames3_1,4);
n12 = size(vidFrames1_2,4);
n22 = size(vidFrames2_2,4);
n32 = size(vidFrames3_2,4);
n13 = size(vidFrames1_3,4);
n23 = size(vidFrames2_3,4);
n33 = size(vidFrames3_3,4);
n14 = size(vidFrames1_4,4);
n24 = size(vidFrames2_4,4);
n34 = size(vidFrames3_4,4);

%% ideal
close all;
x1 = [];
y1 = [];
for i = 1:n11
    X = rgb2gray(vidFrames1_1(:,:,:,i));
    X(1:200,:) = 0;
    X(:,1:320) = 0;
    X(:,480:end) = 0;
    [~, I] = max(X(:));
    [x,y] = ind2sub(size(X),I);
    x1 = [x1 x];
    y1 = [y1 y];
end

x2 = [];
y2 = [];
for i = 1:n21
    X = rgb2gray(vidFrames2_1(:,:,:,i));
    X(1:50,:) = 0;
    X(300:end,:) = 0;
    X(:,1:260) = 0;
    X(:,330:end) = 0;
    [~, I] = max(X(:));
    [x,y] = ind2sub(size(X),I);
    x2 = [x2 x];
    y2 = [y2 y];
end

x3 = [];
y3 = [];
for i = 1:n31
    X = rgb2gray(vidFrames3_1(:,:,:,i));
    X(1:200,:) = 0;
    X(350:end,:) = 0;
    X(:,1:200) = 0;
    X(:,480:end) = 0;
    [~, I] = max(X(:));
    [y,x] = ind2sub(size(X),I);
    x3 = [x3 x];
    y3 = [y3 y];
end

n = min([length(y1), length(y2), length(y3)]);
x1 = x1(:,1:n);
y1 = y1(:,1:n);
x2 = x2(:,1:n);
y2 = y2(:,1:n);
x3 = x3(:,1:n);
y3 = y3(:,1:n);
mat = [x1; y1; x2; y2; x3; y3];
[M,N] = size(mat);
[U,S,V] = svd(mat);
figure(1)
plot(diag(S)./sum(diag(S)),'bo--')
xlabel('Principle Component')
ylabel('Energy Percentage');
title('Energy for ideal case')

[M,N] = size(mat);
mat = mat - repmat(mean(mat,2),1,N);
[U,S,V] = svd(mat);
svdmat = U*S*V';
x1 = svdmat(1,:);
y1 = svdmat(2,:);
x2 = svdmat(3,:);
y2 = svdmat(4,:);
x3 = svdmat(5,:);
y3 = svdmat(6,:);

figure(2)
subplot(2,1,1)
hold on
plot(x1);
plot(x2);
plot(x3);
hold off
ylim([-100, 100])
xlabel('Frame numbers')
ylabel('Position')
title('Horizontal Position of the hanging mass (ideal case)')
legend('x1','x2','x3');

subplot(2,1,2)
hold on
plot(y1);
plot(y2);
plot(y3);
hold off
ylim([-100, 100])
xlabel('Frame numbers')
ylabel('Position')
title('Vertical Position of the hanging mass (ideal case)')
legend('y1','y2','y3');

%% noisy
close all;
x1 = [];
y1 = [];
for i = 1:n12
    X = rgb2gray(vidFrames1_2(:,:,:,i));
    X(1:200,:) = 0;
    X(350:end,:) = 0;
    X(:,1:320) = 0;
    X(:,480:end) = 0;
    [~, I] = max(X(:));
    [x,y] = ind2sub(size(X),I);
    x1 = [x1 x];
    y1 = [y1 y];
end

x2 = [];
y2 = [];
for i = 1:n22
    X = rgb2gray(vidFrames2_2(:,:,:,i));
    X(1:50,:) = 0;
    X(300:end,:) = 0;
    X(:,1:260) = 0;
    X(:,330:end) = 0;
    [~, I] = max(X(:));
    [x,y] = ind2sub(size(X),I);
    x2 = [x2 x];
    y2 = [y2 y];
end

x3 = [];
y3 = [];
for i = 1:n32
    X = rgb2gray(vidFrames3_2(:,:,:,i));
    X(1:200,:) = 0;
    X(350:end,:) = 0;
    X(:,1:200) = 0;
    X(:,480:end) = 0;
    [~, I] = max(X(:));
    [y,x] = ind2sub(size(X),I);
    x3 = [x3 x];
    y3 = [y3 y];
end

n = min([length(y1), length(y2), length(y3)]);
mat = [x1(:,1:n);y1(:,1:n);x2(:,1:n);y2(:,1:n);x3(:,1:n);y3(:,1:n)];
[M,N] = size(mat);
[U,S,V] = svd(mat);

figure(1)
plot(diag(S)./sum(diag(S)),'bo--')
xlabel('Principle Component')
ylabel('Energy Percentage');
title('Energy for noisy case')

[M,N] = size(mat);
mat = mat - repmat(mean(mat,2),1,N);
[U,S,V] = svd(mat);
svdmat = S*V';
x1 = svdmat(1,:);
y1 = svdmat(2,:);
x2 = svdmat(3,:);
y2 = svdmat(4,:);
x3 = svdmat(5,:);
y3 = svdmat(6,:);

figure(2)
subplot(2,1,1)
hold on
plot(x1);
plot(x2);
plot(x3);
hold off
ylim([-100, 100])
xlabel('Frame numbers')
ylabel('Position')
title('Horizontal Position of the hanging mass (noisy case)')
legend('x1','x2','x3');

subplot(2,1,2)
hold on
plot(y1);
plot(y2);
plot(y3);
hold off
ylim([-100, 100])
xlabel('Frame numbers')
ylabel('Position')
title('Vertical Position of the hanging mass (noisy case)')
legend('y1','y2','y3');

%% horizontal 
close all;
x1 = [];
y1 = [];
x1 = [];
y1 = [];
for i = 1:n13
    X = rgb2gray(vidFrames1_3(:,:,:,i));
    X(1:150,:) = 0;
    X(410:end,:) = 0;
    X(:,1:320) = 0;
    X(:,400:end) = 0;
    [~, I] = max(X(:));
    [x,y] = ind2sub(size(X),I);
    x1 = [x1 x];
    y1 = [y1 y];
end

x2 = [];
y2 = [];
for i = 1:n23
    X = rgb2gray(vidFrames2_3(:,:,:,i));
    X(1:50,:) = 0;
    X(300:end,:) = 0;
    X(:,1:260) = 0;
    X(:,330:end) = 0;
    [~, I] = max(X(:));
    [x,y] = ind2sub(size(X),I);
    x2 = [x2 x];
    y2 = [y2 y];
end

x3 = [];
y3 = [];
for i = 1:n33
    X = rgb2gray(vidFrames3_3(:,:,:,i));
    X(1:200,:) = 0;
    X(350:end,:) = 0;
    X(:,1:200) = 0;
    X(:,480:end) = 0;
    [~, I] = max(X(:));
    [y,x] = ind2sub(size(X),I);
    x3 = [x3 x];
    y3 = [y3 y];
end

n = min([length(y1), length(y2), length(y3)]);
mat = [x1(:,1:n);y1(:,1:n);x2(:,1:n);y2(:,1:n);x3(:,1:n);y3(:,1:n)];
[M,N] = size(mat);
[U,S,V] = svd(mat);

figure(1)
plot(diag(S)./sum(diag(S)),'bo--')
xlabel('Principle Component')
ylabel('Energy Percentage')
title('Energy for horizontal case')

[M,N] = size(mat);
mat = mat - repmat(mean(mat,2),1,N);
[U,S,V] = svd(mat);
svdmat = S*V';
x1 = svdmat(1,:);
y1 = svdmat(2,:);
x2 = svdmat(3,:);
y2 = svdmat(4,:);
x3 = svdmat(5,:);
y3 = svdmat(6,:);

figure(2)
subplot(2,1,1)
hold on
plot(x1);
plot(x2);
plot(x3);
hold off
ylim([-100, 100])
xlabel('Frame numbers')
ylabel('Position')
title('Horizontal Position of the hanging mass (horizontal case)')
legend('x1','x2','x3');

subplot(2,1,2)
hold on
plot(y1);
plot(y2);
plot(y3);
hold off
ylim([-100, 100])
xlabel('Frame numbers')
ylabel('Position')
title('Vertical Position of the hanging mass (horizontal case)')
legend('y1','y2','y3');
%% horizontal and rotation
close all;
x1 = [];
y1 = [];
for i = 1:n14
    X = rgb2gray(vidFrames1_4(:,:,:,i));
    X(1:200,:) = 0;
    X(:,1:320) = 0;
    X(:,480:end) = 0;
    [~, I] = max(X(:));
    [x,y] = ind2sub(size(X),I);
    x1 = [x1 x];
    y1 = [y1 y];
end

x2 = [];
y2 = [];
for i = 1:n24
    X = rgb2gray(vidFrames2_4(:,:,:,i));
    X(1:50,:) = 0;
    X(300:end,:) = 0;
    X(:,1:260) = 0;
    X(:,330:end) = 0;
    [~, I] = max(X(:));
    [x,y] = ind2sub(size(X),I);
    x2 = [x2 x];
    y2 = [y2 y];
end

x3 = [];
y3 = [];
for i = 1:n34
    X = rgb2gray(vidFrames3_4(:,:,:,i));
    X(1:200,:) = 0;
    X(350:end,:) = 0;
    X(:,1:200) = 0;
    X(:,480:end) = 0;
    [~, I] = max(X(:));
    [y,x] = ind2sub(size(X),I);
    x3 = [x3 x];
    y3 = [y3 y];
end

n = min([length(y1), length(y2), length(y3)]);
mat = [x1(:,1:n);y1(:,1:n);x2(:,1:n);y2(:,1:n);x3(:,1:n);y3(:,1:n)];
[M,N] = size(mat);
[U,S,V] = svd(mat);

figure(1)
plot(diag(S)./sum(diag(S)),'bo--')
xlabel('Principle Component')
ylabel('Energy Percentage');
title('Energy for horizontal + rotation case')

[M,N] = size(mat);
mat = mat - repmat(mean(mat,2),1,N);
[U,S,V] = svd(mat);
svdmat = S*V';
x1 = svdmat(1,:);
y1 = svdmat(2,:);
x2 = svdmat(3,:);
y2 = svdmat(4,:);
x3 = svdmat(5,:);
y3 = svdmat(6,:);

figure(2)
subplot(2,1,1)
hold on
plot(x1);
plot(x2);
plot(x3);
hold off
ylim([-100, 100])
xlabel('Frame numbers')
ylabel('Position')
title('Horizontal Position of the hanging mass (horizontal + rotation case)')
legend('x1','x2','x3');

subplot(2,1,2)
hold on
plot(y1);
plot(y2);
plot(y3);
hold off
ylim([-100, 100])
xlabel('Frame numbers')
ylabel('Position')
title('Vertical Position of the hanging mass (horizontal + rotation case)')
legend('y1','y2','y3');




