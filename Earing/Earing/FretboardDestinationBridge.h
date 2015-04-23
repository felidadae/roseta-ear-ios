#import <UIKit/UIKit.h>
#import "NotePosition.h"
#import "GlidingValue.h"
#import "TunerDelegate.h"
#import "DestinationDelegate.h"


@interface FretboardDestinationBridge : NSObject<TunerDelegate, DestinationDelegate>

/*sharing instance*/
- (id) init;

/*synth bridge*/
@property (readwrite) DestinationType destination;
- (void) notePressed: (NotePosition *) notePosition;
- (void) noteGlided:  (NotePosition *) notePosition withValue:(GlidingValue*)values;
- (void) noteReleased:(NotePosition *) notePosition;

/*tuner*/
- (unsigned) 	getFrequencyIndexFromPosition: (NotePosition*) notePosition;
- (NSUInteger)  getMaximumFrequencyIndex;
- (void) setTuning: (NSArray*) tuning withBase: (NSUInteger) base;


- (NotePosition*) getNotePositionFromFrequencyIndex: (NSUInteger) frequencyIndex;
- (NotePosition*) getNotePositionWithPreviousNotePosition: (NotePosition*) previousNotePosition withInterval: (NSUInteger) interval;
- (void) 	 	setFretboardSize: (NotePosition*) fretboardSize;

@end
