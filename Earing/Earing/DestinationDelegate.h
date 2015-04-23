
#ifndef Earing_DestinationDelegate_h
#define Earing_DestinationDelegate_h

#import "NotePosition.h"
#import "GlidingValue.h"



@protocol  DestinationDelegate <NSObject>

typedef NS_ENUM(NSUInteger, DestinationType) {
	dStandalone,
	dMidiWifi,
	dMidiBlootoothLE,
	dBoth
};
@property (readwrite) DestinationType destination;

- (void) notePressed: (NotePosition *) notePosition;
- (void) noteGlided:  (NotePosition *) notePosition withValue:(GlidingValue*)values;
- (void) noteReleased:(NotePosition *) notePosition;

@end

#endif
