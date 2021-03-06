#ifndef FilterModule_Standalone_LinearChannelsBuffer_h
#define FilterModule_Standalone_LinearChannelsBuffer_h


namespace FelidadaeAudio {
	template<class SampleType>
	class AudioBuffer {
	public:
		
		SampleType* data_ = nullptr;
		
		//Create, destroy
		AudioBuffer(const unsigned int& numOfChannels, const unsigned int& channelLength): numOfChannels_(numOfChannels), channelLength_(channelLength) {};
		void deallocManuallyData() {
			if(data_ != nullptr)
				delete [] data_;
		}
		//.
		
		//to use (*this)[channNum][sampleNum]
		SampleType*             operator [](unsigned int idx)       {
			return data_+idx * channelLength_;
		}
		const SampleType* const operator [](unsigned int idx) const {
			return data_+idx * channelLength_;
		}
		//.
		
		//to convert to float_type, and to assign float_type array
		operator float_type* () const { return data_; }
		SampleType* operator =(SampleType* buff) { data_ = buff; return data_; }
		//.
		
		unsigned int get_allLength() const { return numOfChannels_ * channelLength_; }
		
	private:
		const unsigned int& numOfChannels_;
		const unsigned int& channelLength_;
	};
}

#endif
