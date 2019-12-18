function [ir, poles, groupDelay, B, A] = SchroederDecorrelator(RT60,order,Fc,delayInSamples,fs,fftSize)

numStages = length(delayInSamples);

ir = 1;
for it = 1:numStages
    [B,A] = RT602Shelving(RT60,order,Fc,delayInSamples(it),fs);
    
    if rand(1)>0.5
       B = -B; 
    end
    
    [b,a] = IIR2Allpass(B,A,delayInSamples(it));
    
    poles{it} = roots(a);
    poles{it}(imag(poles{it})<0) = [];

    groupDelay{it} = grpdelay(b,a,fftSize);
    
    ir = conv(ir,impz(b,a));
end