
#import "MelodyComposer.h"
#import "Utils.h"



@interface MelodyComposer ()

@property (readwrite) NSArray* lastMelody;

@property (readwrite) NSUInteger minFrequencyIndex;
@property (readwrite) NSUInteger maxFrequencyIndex;

@end



@implementation MelodyComposer

-(void) newMelodyWithMin: (NSUInteger) minIdx withMaxFrequencyIndexes: (NSUInteger) maxIdx {
	self.minFrequencyIndex = minIdx;
	self.maxFrequencyIndex = maxIdx;
	NSMutableArray* newMelody = [[NSMutableArray alloc] init];
	
	float phraseLength = 0;
	int lastFrequencyIndex = [Utils randomUnsignedBetween:0 and: (unsigned) maxIdx];
	while ( phraseLength < self.phraseLength ) {
		//Frequency of note
		int deltaFrequencyIndex = [Utils randomUnsignedBetween:0 and: (unsigned)self.maxInterval];
		int sign = [Utils randomUnsignedBetween:0 and:1]; sign *= 2; sign -= 1;
		if (deltaFrequencyIndex*sign + lastFrequencyIndex < 0 || deltaFrequencyIndex*sign + lastFrequencyIndex >= maxIdx) sign = - sign;
		[newMelody addObject: [[NSNumber alloc] initWithUnsignedInt: (unsigned)(deltaFrequencyIndex * sign + lastFrequencyIndex)]];
		//Length    of note
		float noteLength = [Utils randomFloatBetween: self.minimumLengthOfNote and: self.minimumLengthOfNote*4];
		[newMelody addObject: [[NSNumber alloc] initWithFloat: noteLength]];
		
		phraseLength += noteLength;
	}
	
	self.lastMelody = [NSArray arrayWithArray:newMelody];
}

@end
