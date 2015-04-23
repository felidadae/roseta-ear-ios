#import <UIKit/UIKit.h>
#import "DestinationDelegate.h"
#import "TunerDelegate.h"
#import "FretboardView.h"
#import "NotePosition.h"



@interface FretboardViewController : UIViewController <FretboardEventsReceiver>

/* DestinationDelegate - FretboardViewController does not contain synthesizer code - 
 it calls destinationDelegate for that reason; Internally source of events is FretboardView: events
 go through FreboardViewController and in the end through DestinationDelegate*/
@property (readwrite) id<DestinationDelegate> destinationDelegate;
/* Tuner delegate is necessary to colour notes in function of frequency*/
@property (readwrite) id<TunerDelegate> tunerDelegate;

/* Used by MelodyComposer to lighten first note of melody on fretboard*/
- (void) lightenBaseNote: (NotePosition*) notePosition directionIfForward: (bool) ifForward;

/* Size of internal FretboardView (x,y)*/
- (NotePosition*) getFretboardSize;

@end
