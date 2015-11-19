
#import "MelodyComposerBridge.h"
#import "Utils.h"
#import "MelodyComposer.h"



@interface MelodyComposerBridge() {
	@public
	MelodyComposer* melodyComposer_;
}

@end


@implementation MelodyComposerBridge

-(id) init {
	if([super init]) {
		self->melodyComposer_ = new MelodyComposer();
	}
	return self;
}

-(NSArray*) lastMelody {
	std::vector<Note>& melody = self->melodyComposer_->lastMelody_;
	NSMutableArray* melody_ = [[NSMutableArray alloc] init];
	for (std::vector<Note>::iterator inote = melody.begin(); inote != melody.end(); ++inote) {
		[melody_ addObject: [[NSNumber alloc] initWithUnsignedInt: inote->frequencyIndex]];
		[melody_ addObject: [[NSNumber alloc] initWithFloat: inote->duration]];
	}
	return melody_;
}
-(NSUInteger) maxInterval {
	return self->melodyComposer_->maxInterval_;
}
-(void) setMaxInterval:(NSUInteger)maxInterval {
	self->melodyComposer_->maxInterval_ = maxInterval;
}
-(NSUInteger) phraseSize {
	return self->melodyComposer_->melodySize_;
}
-(void) setPhraseSize:(NSUInteger)phraseLength {
	self->melodyComposer_->melodySize_ = phraseLength;
}
-(float) minNoteLength {
	return self->melodyComposer_->minNoteLength_;
}
-(void) setMinNoteLength:(float)minimumLengthOfNote {
	self->melodyComposer_->minNoteLength_ = minimumLengthOfNote;
}

-(void) newMelodyWithMin: (NSUInteger) minIdx withMaxFrequencyIndexes: (NSUInteger) maxIdx {
	self->melodyComposer_->minAllowedIdx_ = minIdx;
	self->melodyComposer_->maxAllowedIdx_ = maxIdx;
	self->melodyComposer_->compose();
}

@end
