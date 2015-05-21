#import <UIKit/UIKit.h>
#import "NotePosition.h"
#import "GlidingValue.h"
#import "FretboardEventsReceiver.h"


@interface FretboardView : UIView

@property (readwrite) id <FretboardEventsReceiver> receiverOfFretboardEvents;

@property (readwrite) CGSize noteLayerSize;
@property (readwrite) CGFloat minXNotesSpace;  /*percentage of width  of note*/
@property (readwrite) CGFloat minYNotesSpace;  /*percentage of height of note*/
@property (readwrite) CGFloat xMargin;
@property (readwrite) CGFloat yMargin;

@property (readonly) CGFloat xNotesSpace;  /*percentage of width  of note*/
@property (readonly) CGFloat yNotesSpace;  /*percentage of height of note*/
@property (readonly) NotePosition* fretboardSize;

/* After changing desired properties function of layoutNotes family should be called*/
- (void) layoutNotes;
- (void) layoutNotesWithNewSize: (CGRect) newSize;

-(CALayer*) findNotesLayer: (NotePosition*) notePosition;

@end