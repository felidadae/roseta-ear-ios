
#import <Foundation/Foundation.h>


@interface MelodyComposerBridge : NSObject

@property (readonly) NSArray *lastMelody;
@property (readwrite) NSUInteger maxInterval;
@property (readwrite) NSUInteger phraseSize;
@property (readwrite) float minNoteLength;
	
-(void) newMelodyWithMin: (NSUInteger) minIdx
 	withMaxFrequencyIndexes: (NSUInteger) maxIdx;

@end
