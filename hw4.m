
%% Load in Data
clc;close; clear all

testd = [];
for str={"Michael", "Beethoven", "ACDC"}
    for i=1:3
        [y, Fs]=audioread(strcat(str{1},num2str(i),".mp3"));
        y = y'/ 2;
        y = y(1,:) + y(2,:);
        for j = 40:5:160
            test = y(1, Fs*j : Fs*(j+5));
            perm = abs(spectrogram(test));
            perm = reshape(perm, [1, 8*32769]);
            testd = [testd;perm];
        end
    end
end
testd = testd';
%% SVD 
[U, S, V] = svd(testd - mean(testd(:)), 'econ');
figure(1)
plot(diag(S) ./ sum(diag(S)), 'bo');

true = [ones(20,1); 2*ones(20,1); 3*ones(20,1)];
rp1 = randperm(50); 
rp2 = randperm(50); 
rp3 = randperm(50);
michael = V(1:50, 2:4);
beethoven = V(51:100, 2:4);
alice = V(101:150, 2:4);
train = [michael(rp1(1:30), :); beethoven(rp2(1:30), :); alice(rp3(1:30),:)];
test1 = [michael(rp1(31:end), :); beethoven(rp2(31:end), :); alice(rp3(31:end),:)];

% classify (Built in)
ctrain = [ones(30,1); 2*ones(30,1); 3*ones(30,1)];
est = classify(test1, train, ctrain);
temp = [est== true];
lda = sum(temp) / length(temp);
figure(2)
subplot(2,1,1);
bar(est);
title('Linear Discriminant Analysis ');
xlabel('Test data');

% naive bayes
nb = fitcnb(train, ctrain);
est = nb.predict(test1);
temp = [est== true];
bayes = sum(temp) / length(temp);

subplot(2,1,2);
bar(est)
title('Naive Bayes Algorithm');
xlabel('Test data');


% final results
bayes = mean(bayes);
lda = mean(lda);
result = [bayes;lda]
