#Audio compression using discrete cosine transforms.

pkg load signal   #To use dct, load this library.
[y,fs,nbits]=wavread('funky.wav');
% take the mono waveform
y1=y(:,1);
#sound(y1,fs)

N=512; %FFT size
L=length(y1); % length of sequence
M=100; %Number samples kept will be 2M+1
start = N/2 + 1-M;
end1 = N/2 + 1+M;

K=ceil(L/N); % Number of blocks to be processed.
numK = K;
y1=[y1; zeros(K*N-L , 1)]; %append zeros to make the vector length a multiple of N

#----------------Audio Compression-------------------#
y1 = reshape(y1 , N , K);
Y2 = dct(y1);
Y3 = Y2(1:(end1-start+1) , :);
transmitvec = Y3(:);
#----------------------------------------------------#

#----------------Audio Decompression-----------------#
P = 2*M+1;
zeroA = floor((N-(2*M+1))/2);
Y4 = reshape(transmitvec , P , K);
Y5 = [Y4; zeros(zeroA+1,size(Y4,2));zeros(zeroA, size(Y4,2));];
Y5 = idct(Y5);
received = Y5(:);
wavwrite(received, fs , "decompress.wav");
#----------------------------------------------------#
