#include "ChannelsWindow.h"



#pragma mark public

void ChannelsWindow::update(FelidadaeAudio::AudioInOutBuffers<float_type>& audio, unsigned int numOfSamplesFromPrevBlocks) {
    if (!checkIfRecreate(audio, numOfSamplesFromPrevBlocks)) {
        setNewValues(audio, numOfSamplesFromPrevBlocks);
        normalUpdating(audio);
    }
    else {
        setNewValues(audio, numOfSamplesFromPrevBlocks);
        recreateBuffers(audio);
    }
}

void ChannelsWindow::reset() {
    for(int i = 0 ; i < numOfChannels_ * channelLength_; ++i)
        buffer_.data_[i] = 0;
}



#pragma private 

void ChannelsWindow::setNewValues (FelidadaeAudio::AudioInOutBuffers<float_type>& audio, unsigned int& numOfSamplesFromPrevBlocks) {
    historySize_    = numOfSamplesFromPrevBlocks;
    numOfChannels_  = audio.numOfChannels_;
    inputBlockSize_ = audio.channelLength_;
    channelLength_  = inputBlockSize_ + historySize_;
}

bool ChannelsWindow::checkIfRecreate(FelidadaeAudio::AudioInOutBuffers<float_type>& audio, unsigned int& numOfSamplesFromPrevBlocks) {
    if (    numOfChannels_ == audio.numOfChannels_      &&   channelLength_ == audio.channelLength_ + numOfSamplesFromPrevBlocks    )
        return false;
    return true;
}

void ChannelsWindow::normalUpdating(FelidadaeAudio::AudioInOutBuffers<float_type>& audio) {
    for(unsigned int chanNum = 0; chanNum < numOfChannels_; ++chanNum) {
        int sampleNum = 0;
        for(; sampleNum < historySize_; sampleNum++)
            buffer_[chanNum][sampleNum] = buffer_   [chanNum][sampleNum + inputBlockSize_];
        for(; sampleNum < channelLength_; ++sampleNum)
            buffer_[chanNum][sampleNum] = audio.in_ [chanNum][sampleNum - historySize_];
    }
}

void ChannelsWindow::recreateBuffers(FelidadaeAudio::AudioInOutBuffers<float_type>& audio) {
    //Destroying old and creating new
    if(buffer_.data_)
        delete buffer_.data_;
    buffer_ = new float_type[numOfChannels_ * channelLength_];
    //.
    
    //Writing apprioprate values
    for(unsigned channNum = 0; channNum < numOfChannels_; ++channNum) {
        unsigned sampleNum = 0;
        for(; sampleNum < historySize_;   ++sampleNum)
            buffer_[channNum][sampleNum] = 0;
        for(; sampleNum < channelLength_; ++sampleNum)
            buffer_[channNum][sampleNum] = audio.in_[channNum][sampleNum-historySize_];
    }
}





