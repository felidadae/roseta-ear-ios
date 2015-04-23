#ifndef __Earing__test__
#define __Earing__test__

//#include <iostream>
#include <vector>
#import <AudioToolbox/AudioToolbox.h>
#include "IProcess.h"
#include "FMTypes.h"
#include "Tuner.h"



class Synth: FelidadaeAudio::IProcess<float_type> {
public:
	static const unsigned int sampleRate = 44100;
	
	Synth(Tuner& tuner);
	
	/* IProcess*/
	void process (FelidadaeAudio::AudioInOutBuffers<float_type>& audioBlocks);
	void reset() {};
	
	/* Public 2D positions Events Handlers*/
	/* Note: position (row,string==0,column,fret==0) is the lowest frequency note*/
	void attackNote  (unsigned positionX, unsigned positionY);
	void bendNote    (unsigned positionX, unsigned positionY, float bendingIndexX, float bendingIndexY);
	void unbendNote  (unsigned positionX, unsigned positionY);
	void realeaseNote(unsigned positionX, unsigned positionY);
	
	
private:
	static const unsigned int maxActiveNotes = 50;
	static const unsigned int theLowestNoteFrequency = 80;
	constexpr static double maxAmplitudeValue = 0.25;
	
	Tuner& tuner_;
	
	class PlayingNoteInfo {
	public:
		double phi;
		double       amplitude, frequency;
		unsigned int idx;
		double t_p, t_dp;
		bool         ifDp/*ifNoteDepressed*/;
		double       bendingX, bendingY;
		
		PlayingNoteInfo();
		
		float_type getSampleValue();
		
		void updateState();
		bool ifNoteShouldReset();
		bool ifExistNote();
		void reset();
	};
	PlayingNoteInfo notes[maxActiveNotes];
	
	/* Private 1D positions Events Handlers*/
	unsigned findNoteIndexFrequency(unsigned positionX, unsigned positionY);
	void attackNote  (unsigned indexOfNote);
	void bendNote    (unsigned indexOfNote, float bendingIndexX, float bendingIndexY);
	void unbendNote  (unsigned indexOfNote);
	void realeaseNote(unsigned indexOfnote);
};

#endif /* defined(__Earing__test__) */
