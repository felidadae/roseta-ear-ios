#ifndef __Earing__MelodyComposer__
#define __Earing__MelodyComposer__

#include <iostream>
#include <vector>


class Note {
public:
	float duration;
	unsigned frequencyIndex;
};

class MelodyComposer {
public:
	std::vector<Note> lastMelody_;
	
	//State
	unsigned minAllowedIdx_;
	unsigned maxAllowedIdx_;
	
	float minNoteLength_;
	float maxNoteLengthK_; //maxNoteLengthAsMultiplyOfMin_
	
	unsigned melodySize_; 
	unsigned maxInterval_;
	
	MelodyComposer();

	std::vector<Note>& compose();
};

#endif
