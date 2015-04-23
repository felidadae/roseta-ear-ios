
#import <Foundation/Foundation.h>


@interface MelodyComposer : NSObject

@property (readonly) NSArray *lastMelody;
@property (readwrite) NSUInteger maxInterval;
@property (readwrite) NSUInteger phraseLength; 
@property (readwrite) float minimumLengthOfNote;
	
-(void) newMelodyWithMin: (NSUInteger) minIdx withMaxFrequencyIndexes: (NSUInteger) maxIdx;

@end
