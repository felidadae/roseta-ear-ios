#include "MelodyComposer.h"
#include <stdlib.h>     /* srand, rand */
#include <time.h>       /* time */



unsigned randUnsigned(unsigned min, unsigned max) {
	return rand() % (max-min)+min;
}

float randFloat(float min, float max) {
	unsigned NPart = 16;
	unsigned part = rand() % NPart;
	float delta = max-min;
	float partdelta = delta / float(NPart);
	return min + float(part)*partdelta;
}



MelodyComposer::MelodyComposer() {
	srand (time(NULL));
}

std::vector<Note>& MelodyComposer::compose() {
	std::vector<Note> melody(melodySize_);
	
	melody[0].frequencyIndex = randUnsigned(this->minAllowedIdx_, this->maxAllowedIdx_);
	for (unsigned inote = 1; inote != melodySize_; ++inote) {
		unsigned freqIdx = randUnsigned(0, maxInterval_) + melody[inote-1].frequencyIndex;
		if ( freqIdx > maxAllowedIdx_ ) freqIdx = maxAllowedIdx_;
		if ( freqIdx < minAllowedIdx_ ) freqIdx = minAllowedIdx_;
		melody[inote].frequencyIndex = freqIdx;
	}
	
	for (unsigned inote = 0; inote != melodySize_; ++inote) {
		melody[inote].duration = 
			randFloat(minNoteLength_, maxNoteLengthK_* minNoteLength_);
	}
	
	this->lastMelody_ = melody;
	return this->lastMelody_;
}

