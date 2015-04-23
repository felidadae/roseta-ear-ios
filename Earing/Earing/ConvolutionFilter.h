#ifndef __LowPassFilter_Standalone__ConvolutionFilter__
#define __LowPassFilter_Standalone__ConvolutionFilter__

#include "AudioInOutBuffers.h"
#include "FMTypes.h"
#include "PIR_fftw.h"
#include "ChannelsWindow.h"
//---
#include "FourierTransformBox.h"



class ConvolutionFilter  {
public:
     ConvolutionFilter();
    ~ConvolutionFilter();
    
    void setNewIR(const IRF* irf);
    
	void process(FelidadaeAudio::AudioInOutBuffers<float_type>& audio );
	void reset() {window_.reset();}

private:
	ChannelsWindow window_;
	const IRF* irf_ = nullptr;
	
    PIR_fftw partitionedIR_;
    
    //FDL cursor (cursor where is delay line which was been inserted the earliear and now will be overwritten)
    unsigned int lastInsertedDelayLineIdx = 0;
    //.
    
    //fft plans
	FourierTransformBox* fftPlan;
    //.
    
    //Buffers
    float_type* bufferTransform_R_ = nullptr,  *bufferTransform_I_ = nullptr, * bufferAccumulator_R_= nullptr, *bufferAccumulator_I_ = nullptr; //< [channel0][channel1]...[channelN]
    //---
    float_type* bufferFDL_R_ = nullptr, *bufferFDL_I_ = nullptr; // [[FDL(chann=0, line=0)] [FDL(chann=1, line=0)] ... [FDL(chann=N-1, line=0)]]  [ {FDL(chann={0:N-1}, line = 1)} ] ... [FDL(chann={0:N-1}, line = numOfPartsIRPerChannel)]
    //.
};



#endif /* defined(__LowPassFilter_Standalone__ConvolutionFilter__) */
