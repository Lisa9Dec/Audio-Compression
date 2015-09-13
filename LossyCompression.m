%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compression using FFT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pkg load signal
[y,fs,nbits]=wavread('tada.wav');

% take the mono waveform
y1=y(:,1);
#sound(y1,fs)

N=512; %FFT size
L=length(y1); % length of sequence
M=100; %Number samples kept will be 2M+1
start = N/2 + 1-M;
end1 = N/2 + 1+M;

K=ceil(L/N); % Number of blocks to be processed.
y1=[y1; zeros(K*N-L , 1)];%append zeros to make the vector length a multiple of N
transmitvec = [];% This is the transmitted vector

for k=1:K
    y2=y1((k-1)*N+1:k*N);
    #disp(k*N - ((k-1)*N+1));
    Y2=(dct(y2));
    #+disp(size(Y2));
    Y3=Y2(start:end1);
    #disp(size(Y3));
    #disp(Y3);
    plot(abs(Y3));
    pause;
    transmitvec = [transmitvec; Y3(1:M+1)];  #Change
end
#disp((transmitvec(1:201)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Receiver: Input to this fuction is vector transmitvec, N, K and 2M+1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P=M+1; #Change
zeroA = floor((N-(2*M+1))/2);  #Change
received= [];
for k=1:K
    Y4 = transmitvec((k-1)*P+1:k*P);
    Y4h = fliplr(conj(Y4));  #Change
    Y4h([1]) = [];  #Change
    Y4 = [Y4 ; Y4h];	#Change
    disp(size(Y4));
    Y5 = [zeros(zeroA+1,1); Y4; zeros(zeroA, 1)];
    y5=ifft(fftshift(Y5));
    received = [received ; y5];
end

wavwrite(received, fs , "sex.wav")

