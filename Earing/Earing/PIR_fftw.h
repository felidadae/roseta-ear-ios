
#ifndef __FilterModule_Standalone__PartitionedIRProvider__
#define __FilterModule_Standalone__PartitionedIRProvider__

#include "PIRBase.h"
#include "AudioBuffer.h"
#include "FourierTransformBox.h"
#include <cmath>



class PIR_fftw: public PIRBase  {
public:
    PIR_fftw();
    
    void setNewIRF(const IRF* irf, unsigned int blockSize);

    float_type* imaginary_  = nullptr; // [[PIR(chann=0, part=0)] [PIR(chann=1, part=0)] ... [PIR(chann=N-1, part=0)]]  [ {PIR(chann={0:N-1}, part = 1)} ] ... [PIR(chann={0:N-1}, part = numOfPartsIRPerChannel)]
    float_type* real_       = nullptr;
    
    unsigned int get_numOfChannels() { return numOfChannels_; }
    unsigned int get_channelLength() { return channelLength_; }
};



#endif /* defined(__FilterModule_Standalone__PartitionedIRProvider__) */










