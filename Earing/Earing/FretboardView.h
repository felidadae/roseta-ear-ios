#import <UIKit/UIKit.h>
#import "NotePosition.h"
#import "GlidingValue.h"
#import "FretboardEventsReceiver.h"


@interface FretboardView : UIView

@property (readwrite) id <FretboardEventsReceiver> receiverOfFretboardEvents;

@property (readwrite) CGSize noteLayerSize;
@property (readwrite) CGFloat xNotesSpace;  /*percentage of width  of note*/
@property (readwrite) CGFloat yNotesSpace;  /*percentage of height of note*/
@property (readwrite) CGFloat minXMargin;
@property (readwrite) CGFloat minYMargin;

@property (readonly) CGFloat xMargin;
@property (readonly) CGFloat yMargin;
@property (readonly) NotePosition* fretboardSize;

/* After changing desired properties function of layoutNotes family should be called*/
- (void) layoutNotes;
- (void) layoutNotesWithNewSize: (CGRect) newSize;

-(CALayer*) findNotesLayer: (NotePosition*) notePosition;

@end