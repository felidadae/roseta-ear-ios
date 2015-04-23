
#ifndef Earing_FretboardEventsReceiver_h
#define Earing_FretboardEventsReceiver_h

#include "NotePosition.h"



@protocol FretboardEventsReceiver <NSObject>

/*required*/-(void) notesPressed:  (NSArray*  /*Array of objects of class NotePosition*/) notesPositions;
@optional   -(void) notesGlided:   (NSArray*  /*Array of objects of class NotePosition*/) notesPositions
					theirValues:   (NSArray*  /*Array of objects of class GlidingValue*/) values;
/*required*/-(void) notesReleased: (NSArray*  /*Array of objects of class NotePosition*/) notesPositions;

@end

#endif
