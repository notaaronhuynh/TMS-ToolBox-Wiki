%Apply low pass filter
%Inputs: Data, sample rate, cutoff frequency
%Outpus: filtered data

function filteredData=ProcessLowPass(app,Data,SampleRate,Cutoff)

%check for invalid values
if Cutoff> SampleRate/2
    msgbox('Invalid cutoff frequency');
    Cutoff=SampleRate/2-1;
    app.LowPassEditField.Value=Cutoff;
elseif Cutoff == 0
    Cutoff=1;
    app.LowPassEditField.Value=Cutoff;
end

newData=nan(size(Data))';

%Filter
if strcmp(app.LowPassFilterType, "Butterworth") % butterworth
    [b,a] = butter(app.LowPassFilterOrder,Cutoff/(SampleRate/2),'low');
elseif strcmp(app.LowPassFilterType, "Chebyshev I") % chebyshev type I
    [b,a] = cheby1(app.LowPassFilterOrder,Cutoff/(SampleRate/2),'low');
elseif strcmp(app.LowPassFilterType, "Chebyshev II") % chebyshev type Ii
    [b,a] = cheby2(app.LowPassFilterOrder,Cutoff/(SampleRate/2),'low');
elseif strcmp(app.LowPassFilterType, "Elliptic") % elliptic
    [b,a] = ellip(app.LowPassFilterOrder,Cutoff/(SampleRate/2),'low');
elseif strcmp(app.LowPassFilterType, "Bessel") % bessel (only low pass)
    [b,a] = besself(app.LowPassFilterOrder,Cutoff/(SampleRate/2));    
end

for i=1:length(Data(:,1)) %for each trial
    TrialData=Data(i,:);
    if any(isnan(TrialData)) %if there are any nans
        NumLoc=find(~isnan(TrialData)); %locations of real numbers
        TrialData=TrialData(NumLoc);
    else
        NumLoc=1:length(TrialData);
    end

    newData(NumLoc,i)=filtfilt(b,a,TrialData);
end

filteredData=newData';

end