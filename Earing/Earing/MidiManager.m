
#import "MidiManager.h"



@implementation MidiManager

#pragma mark Initialization

- (id) init
{
	self = [super init];
	
    IF_IOS_HAS_COREMIDI
    {
        midi = [[Midi alloc] init];
        midi.delegate = self;
        
        /* properties on the source */
        NSLog(@"%@",[midi sourceSessionName]);  // show the Apple sesion name
        NSLog(@"%@",[midi sourceDNSName]);      // show the DNS name
        NSLog(@"%@",[midi sourceDescription]);  // show all properties
		//
        NSLog(@"%@",[midi destinationSessionName]);  // show the Apple sesion name
        NSLog(@"%@",[midi destinationDNSName]);      // show the DNS name
        NSLog(@"%@",[midi destinationDescription]);  // show all properties
    }
	
	return self;
}


#pragma mark Sending Midi Events

/* MIDI send routines
 input:note number - 60 is middle C
 */
- (void) midiSendOnNoteInForeground:(UInt8)n
{
    const UInt8 note      = n;
    const UInt8 noteOn[]  = { 0x90, note, 127 };
    //
    [midi sendBytes:noteOn size:sizeof(noteOn)];
}

- (void) midiSendOffNoteInForeground:(UInt8)n
{
    const UInt8 note      = n;
    const UInt8 noteOff[] = { 0x80, note, 0   };
    //
    [midi sendBytes:noteOff size:sizeof(noteOff)];
}

- (void) midiSendAftertouchInForeground:   (UInt8) n/*60 is middle C*/ withValue: (UInt8) v
{
	const UInt8 note      = n;
    const UInt8 aftertouch[] = { 0x80, note, 0   };
    //
    [midi sendBytes:aftertouch size:sizeof(aftertouch)];
}


@end
