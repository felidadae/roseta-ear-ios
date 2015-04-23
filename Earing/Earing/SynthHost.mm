
#import <AudioToolbox/AudioToolbox.h>
//
#import "SynthHost.h"
#import "Synth.h"
#import "AudioInOutBuffers.h"
#import "IRF.h"
#import "Tuner.h"



OSStatus RenderTone(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp,
					UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData)
{
	void** elements = (void**)(inRefCon);
	Synth* synth = (Synth*) (elements[0]);
	ConvolutionFilter* filter = (ConvolutionFilter*) (elements[1]);
	
	bool filterOn = true;
	
	FelidadaeAudio::AudioInOutBuffers<float_type> audio;
	audio.channelLength_ = inNumberFrames;
	audio.numOfChannels_ = 1;
	if(filterOn)
		audio.out_.data_ = new Float32 [inNumberFrames];
	else
		audio.out_.data_ = (Float32 *)ioData->mBuffers[0].mData;
	
	synth->process(audio);
	
	if(filterOn) {
		audio.in_.data_ = audio.out_.data_;
		audio.out_.data_ = (Float32 *)ioData->mBuffers[0].mData;
		filter->process(audio);
	}
	
	
	return noErr;
}


@implementation SynthHost {
	AudioComponentInstance toneUnit;
}

- (id) initWithTuner: (Tuner*) tuner {
	if([super init]) {
		self->synth = new Synth(*tuner);
		self->convolutionFilter = new ConvolutionFilter();
		[self prepareConvolutionerFilter];
		[self createToneUnit];
	}
	return self;
}

- (void) prepareConvolutionerFilter {
	/* Read IR*/
	IRF* irf = new IRF();
	unsigned size = 2048*2;
	irf->h_ = new float_type[size];
	for(unsigned i=0; i<size; ++i){
		irf->h_.data_[i] = 1/(i+50.0);
		//std::cout<< irf->h_.data_[i] << std::endl;
	}
	irf->N_=size;
	irf->numOfChannels_ = 1;
	self->convolutionFilter->setNewIR(irf);
}

- (void) createToneUnit {
	/* Configure the search parameters to find the default playback output unit
	   (called the kAudioUnitSubType_RemoteIO on iOS but
	   kAudioUnitSubType_DefaultOutput on Mac OS X)
	 */
	AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	
	/* Get the default playback output unit
	 */
	AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
	NSAssert(defaultOutput, @"Can't find default output");
	
	/* Create a new unit based on this that we'll use for output
	 */
	OSErr err = AudioComponentInstanceNew(defaultOutput, &toneUnit);
	NSAssert1(toneUnit, @"Error creating unit: %hd", err);
	
	/* Set our tone rendering function on the unit
	 */
	AURenderCallbackStruct input;
	input.inputProc = RenderTone;
	void** elements = new void* [2];
	elements[0]=(void *)(self->synth);
	elements[1]=(void *)(self->convolutionFilter);
	input.inputProcRefCon = (void *)(elements);
	err = AudioUnitSetProperty(toneUnit,
							   kAudioUnitProperty_SetRenderCallback,
							   kAudioUnitScope_Input,
							   0,
							   &input,
							   sizeof(input));
	NSAssert1(err == noErr, @"Error setting callback: %hd", err);
	
	/* Set the format to 32 bit, single channel, floating point, linear PCM
	 */
	const int four_bytes_per_float = 4;
	const int eight_bits_per_byte = 8;
	AudioStreamBasicDescription streamFormat;
	streamFormat.mSampleRate = synth->sampleRate;
	streamFormat.mFormatID = kAudioFormatLinearPCM;
	streamFormat.mFormatFlags =
	kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
	streamFormat.mBytesPerPacket = four_bytes_per_float;
	streamFormat.mFramesPerPacket = 1;
	streamFormat.mBytesPerFrame = four_bytes_per_float;
	streamFormat.mChannelsPerFrame = 1;
	streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
	err = AudioUnitSetProperty (toneUnit,
								kAudioUnitProperty_StreamFormat,
								kAudioUnitScope_Input,
								0,
								&streamFormat,
								sizeof(AudioStreamBasicDescription));
	NSAssert1(err == noErr, @"Error setting stream format: %hd", err);
}


#pragma mark Start, stop AU

- (void) play {
	OSErr err = AudioUnitInitialize(toneUnit);
	NSAssert1(err == noErr, @"Error initializing unit: %hd", err);
	err = AudioOutputUnitStart(toneUnit);
	NSAssert1(err == noErr, @"Error starting unit: %hd", err);
}

- (void) stop {
	if (toneUnit)
	{
		AudioOutputUnitStop(toneUnit);
		AudioUnitUninitialize(toneUnit);
		AudioComponentInstanceDispose(toneUnit);
		toneUnit = nil;
	}
}

@end


