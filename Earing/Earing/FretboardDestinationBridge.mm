
#import "FretboardDestinationBridge.h"
#import "MidiManager.h"
#import "SynthHost.h"
#import "Tuner.h"



@interface FretboardDestinationBridge() {
	Tuner* tuner;
	NSUInteger maximumFrequencyIndex_;
}
@property SynthHost*       synthHost;
@property MidiManager*     midiManager;

@property (strong, readwrite) NotePosition* fretboardSize__;

@end



@implementation FretboardDestinationBridge

#pragma mark Creation

- (id) init {
	if([super init]) {
		self->tuner = new Tuner(5, 1);
		self.synthHost = [[SynthHost alloc] initWithTuner: tuner];
		[self.synthHost  play];
		self.midiManager = [[MidiManager alloc] init];
		self.fretboardSize__ = [[NotePosition alloc] init];
	}
	return self;
}


#pragma mark Fretboard Events Receiver

- (void) notePressed: (NotePosition *) notePosition {
	switch (self.destination) {
		case dStandalone:
			self.synthHost->synth->attackNote((unsigned)notePosition.x, (unsigned)notePosition.y);
			break;
			
		case dMidiBlootoothLE:
			/*@TODO*/
			break;
			
		case dMidiWifi:
			//[self.midiManager midiSendOnNoteInForeground: [self findNoteMainFrequencyFromNotePosition:notePosition]+50];
			break;
			
		case dBoth:
			/*@TODO*/
			break;
			
  		default:
			break;
	}
}

- (void) noteGlided:  (NotePosition *) notePosition withValue:(GlidingValue*)value {
	switch (self.destination) {
		case dStandalone:
			self.synthHost->synth->bendNote((unsigned)notePosition.x, (unsigned)notePosition.y, (float)value.x, (float)value.y);
			break;
			
		case dMidiBlootoothLE:
			/*@TODO*/
			break;
			
		case dMidiWifi:
			//[self.midiManager midiSendOnNoteInForeground: [self findNoteMainFrequencyFromNotePosition:notePosition]+50];
			break;
			
		case dBoth:
			/*@TODO*/
			break;
			
		default:
			break;
	}
}

- (void) noteReleased:(NotePosition *) notePosition {
	switch (self.destination) {
		case dStandalone:
			self.synthHost->synth->realeaseNote((unsigned)notePosition.x, (unsigned)notePosition.y);
			break;
			
		case dMidiBlootoothLE:
			/*@TODO*/
			break;
			
		case dMidiWifi:
			//[self.midiManager midiSendOnNoteInForeground: [self findNoteMainFrequencyFromNotePosition:notePosition]+50];
			break;
			
		case dBoth:
			/*@TODO*/
			break;
			
		default:
			break;
	}
}


#pragma mark Tuner Info

- (void) setTuning: (NSArray*) tuning withBase: (NSUInteger) base {
	std::vector<int> tuninggg;
	for(unsigned i = 0; i < [tuning count]; ++i)
		tuninggg.push_back((int)([tuning[i] integerValue]));
	self->tuner->setTuning(0, tuninggg);
}

- (void) setFretboardSize: (NotePosition*) fretboardSize {
	self.fretboardSize__.x = fretboardSize.x;
	self.fretboardSize__.y = fretboardSize.y;
}

- (NSUInteger)  getMaximumFrequencyIndex {
	NotePosition* note = self.fretboardSize__;
	note.x = note.x-1;
	note.y = note.y-1;
	return [self getFrequencyIndexFromPosition: note];
}

- (unsigned) getFrequencyIndexFromPosition: (NotePosition*) notePosition {
	return tuner->getFrequencyFromPosition((unsigned)notePosition.x, (unsigned)notePosition.y)+1;
}


#pragma mark MelodyToPositionsConverter

- (NotePosition*) getNotePositionWithPreviousNotePosition: (NotePosition*) previousNotePosition
											 withInterval: (NSUInteger) interval
{
	NotePosition* nextNotePosition = [[NotePosition alloc] init];
	
	std::vector<int> sth = tuner->getSth((unsigned int)previousNotePosition.y);
	std::vector<int> n;
	for(unsigned i = 0; i < self.fretboardSize__.y; ++i)
		n.push_back(sth[i]+ (int)previousNotePosition.x+(int)interval);
	
	unsigned stringIndex=0;
	unsigned i = 0;
	while(n[i]<0) { ++i; ++stringIndex; }
	for(; i < self.fretboardSize__.y; ++i) {
		if(n[i]<0 || n[i] >= self.fretboardSize__.x ) continue;
		unsigned deltaX = abs(n[i]-(int)previousNotePosition.x);
		unsigned deltaXX= abs(n[stringIndex] - (int)previousNotePosition.x);
		if( deltaX < deltaXX )
			stringIndex = i;
	}
	
	nextNotePosition.x = n[stringIndex];
	nextNotePosition.y = stringIndex;
	return nextNotePosition;
}

- (NotePosition*) getNotePositionFromFrequencyIndex: (NSUInteger) frequencyIndex {
	NotePosition* notePosition = [[NotePosition alloc] init];
	notePosition.x = 3;
	notePosition.y = 3;
	return notePosition;
}

@end
