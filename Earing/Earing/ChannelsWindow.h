#ifndef LowPassFilter_Standalone_ChannelsWindow_h
#define LowPassFilter_Standalone_ChannelsWindow_h

#include "AudioInOutBuffers.h"
#include "FMTypes.h"
//#include "IConvolutioner.h"
#include "AudioBuffer.h"



class ChannelsWindow {
public:
    
    //Construct, destroy
    ChannelsWindow(): buffer_(numOfChannels_, channelLength_) {}
    virtual ~ChannelsWindow() {}
    //.
    
    //Main
	void update(FelidadaeAudio::AudioInOutBuffers<float_type>& audio, unsigned int numOfSamplesFromPrevBlocks);
    void reset();
    //.
    
    //to use (*this)[channNum][sampleNum]
    float_type*             operator [] (unsigned int idx)       {
        return buffer_[idx];
    }
    const float_type* const operator [] (unsigned int idx) const {
        return buffer_[idx];
    }
    //.
    
    //to convert to float_type, and to assign float_type array
    float_type* operator =  (float_type* buff) { buffer_.data_ = buff; return buffer_.data_; }
    operator float_type* () const { return buffer_.data_; }
    //.
    
    //get
    unsigned int get_channelLength () { return channelLength_; }
    unsigned int get_numOfChannels () { return numOfChannels_; }
    unsigned int get_historySize   () { return historySize_; }
    unsigned int get_inputBlockSize() { return inputBlockSize_; }
    unsigned int get_allLength     () { return buffer_.get_allLength(); }
    //.
    
	FelidadaeAudio::AudioBuffer<float_type> buffer_;
    
private:
    
    unsigned int numOfChannels_     = 0;
    unsigned int channelLength_     = 0;
    //.
    
    unsigned int historySize_       = 0;
    unsigned int inputBlockSize_    = 0;
    
  
	void setNewValues       (FelidadaeAudio::AudioInOutBuffers<float_type>& audio, unsigned int& numOfSamplesFromPrevBlocks);
	bool checkIfRecreate    (FelidadaeAudio::AudioInOutBuffers<float_type>& audio, unsigned int& numOfSamplesFromPrevBlocks);
    //
	void normalUpdating     (FelidadaeAudio::AudioInOutBuffers<float_type>& audio);
	void recreateBuffers    (FelidadaeAudio::AudioInOutBuffers<float_type>& audio);
};



#endif
