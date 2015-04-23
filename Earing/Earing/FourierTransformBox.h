
#ifndef Earing_FourierTransformBox_h
#define Earing_FourierTransformBox_h

#include <accelerate/accelerate.h>


class FourierTransformBox {
public:
	
	FourierTransformBox(unsigned size) {
		size_ = size;
		sizeLog2_ = log2(size);
		setup_ = vDSP_create_fftsetup( sizeLog2_, 0 );
	}
	
	~FourierTransformBox() {
		vDSP_destroy_fftsetup ( setup_ );
	}
	
	/* In place, float type*/
	void execute(float* realp, float* imagep, FFTDirection direction) {
		DSPSplitComplex signal;
		signal.realp = realp;
		signal.imagp = imagep;
		vDSP_fft_zip(setup_, &signal, 1, sizeLog2_, direction);
	}
	
	/* For many the same transforms*/
	void execute(  unsigned numberOfChunks,
				   float* realp, float* imagep,
				   FFTDirection direction)
	{
		for(unsigned chunkI = 0; chunkI < numberOfChunks; ++chunkI)
			execute(realp+chunkI*size_, imagep+chunkI*size_, direction);
	}
	
	
private:
	unsigned size_;
	unsigned sizeLog2_;
	FFTSetup setup_;
};

#endif
