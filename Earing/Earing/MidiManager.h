
#import <Foundation/Foundation.h>
#import "midi.h"



@interface MidiManager : NSObject {
    Midi *midi;
}
@property (nonatomic,assign) Midi *midi;

- (void) midiSendOnNoteInForeground:       (UInt8) n/*60 is middle C*/;
- (void) midiSendOffNoteInForeground:      (UInt8) n/*60 is middle C*/;

- (void) midiSendAftertouchInForeground:   (UInt8) n/*60 is middle C*/ withValue: (UInt8) v;

@end
