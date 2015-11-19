
#import "FretboardView.h"
#import "UIParams.h"




#pragma mark TouchWithNotePosition Class

@interface TouchWithNotePosition : NSObject
@property (readwrite) UITouch* touch;
@property (readwrite) NotePosition* notePosition;
@end

@implementation TouchWithNotePosition
@end





#pragma mark TouchesWithNotePositions Class

@interface TouchesWithNotePositions : NSObject
@property (readwrite) NSMutableArray* elements;
- (TouchWithNotePosition*) ifTouchExist: (UITouch*) touch;
- (BOOL) ifNotePositionAssociatedWithAnyTouch: (NotePosition*) notePosition;
@end

@implementation TouchesWithNotePositions
-(id) init {
	self = [super init];
	if(self) {
		self.elements = [[NSMutableArray alloc] init];
	}
	return self;
}
- (TouchWithNotePosition*) ifTouchExist: (UITouch*) touch {
	for(TouchWithNotePosition* tNP in self.elements) {
		if([tNP.touch isEqual:touch])
			return tNP;
	}
	return nil;
}
- (BOOL) ifNotePositionAssociatedWithAnyTouch: (NotePosition*) notePosition {
	for(TouchWithNotePosition* tNP in self.elements) {
		if(tNP.notePosition == notePosition)
			return true;
	}
	return false;
}
@end





#pragma mark FretboardView Class

@interface FretboardView ()

@property (readwrite) NotePosition* fretboardSize;
@property (strong, readwrite) TouchesWithNotePositions* touchesWithNotesPositions;
@property (strong, readwrite) UIImageView *blurView;
@property (nonatomic, strong) CALayer *maskLayer;
@property (readwrite) CGFloat xNotesSpace;  /*percentage of width  of note*/
@property (readwrite) CGFloat yNotesSpace;  /*percentage of height of note*/

@end



@implementation FretboardView
{
	CGFloat vertivalCentralAlignmentCorrection;
}

#pragma mark __Initialization

- (void)awakeFromNib {
    self.multipleTouchEnabled = TRUE;
	self.touchesWithNotesPositions = [[TouchesWithNotePositions alloc] init];
	self.fretboardSize = [[NotePosition alloc] init];
	
	self.blurView = [[UIImageView alloc] initWithFrame:  CGRectMake(0, 0, 768, 1024 )];
	
	[self setupBlurredImage];
	[self addSubview: self.blurView];
	self.blurView.hidden = false;
}

- (void)setupBlurredImage {
	UIImage *theImage = [UIImage imageNamed:@"forblur_background"];
	
	CIContext *context = [CIContext contextWithOptions: nil];
	CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
	
	CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
	[filter setValue:inputImage forKey:kCIInputImageKey];
	[filter setValue:[NSNumber numberWithFloat:70.0f] forKey:@"inputRadius"];
	CIImage *result = [filter valueForKey:kCIOutputImageKey];
	CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
	
	self.blurView.image = [UIImage imageWithCGImage:cgImage];
}


#pragma mark __LayoutNotes

- (void) layoutNotesWithNewSize:(CGRect)newSize {
	CGRect screenRect = newSize;
    CGFloat width  = screenRect.size.width;
    CGFloat height = screenRect.size.height;
	
	self.fretboardSize.x  = (width -2*_xMargin)/_noteLayerSize.width /(_minXNotesSpace+1);
	self.fretboardSize.y  = (height-2*_yMargin)/_noteLayerSize.height/(_minYNotesSpace+1);
	
	self.xNotesSpace = (CGFloat)((width  - 2*_xMargin) - (_fretboardSize.x-1) * _noteLayerSize.width )
		/ (CGFloat)(_fretboardSize.x-1) / (CGFloat)_noteLayerSize.width;
	self.yNotesSpace = (CGFloat)((height - 2*_yMargin) - (_fretboardSize.y-1) * _noteLayerSize.height)
		/ (CGFloat)(_fretboardSize.y-1) / (CGFloat)_noteLayerSize.height;
	
	self.maskLayer = [CALayer layer];
	self.maskLayer.frame = self.frame;
	
    for(int istr = 0; istr < _fretboardSize.y; ++istr)
        for(int inot = 0; inot < _fretboardSize.x; ++inot )
        {
			CALayer* note = [CALayer layer];
			note.frame = CGRectMake(_xMargin  + inot*_noteLayerSize.width *(1+_xNotesSpace) + _noteLayerSize.width/2,
									_yMargin  + istr*_noteLayerSize.height*(1+_yNotesSpace) + _noteLayerSize.height/2,
									NOTE_UNACTIVE_RADIUS*2, NOTE_UNACTIVE_RADIUS*2);
			note.cornerRadius = NOTE_UNACTIVE_RADIUS;
			note.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
			note.borderWidth = 10;
			note.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
		
			note.position = CGPointMake(_xMargin  + inot*_noteLayerSize.width *(1+_xNotesSpace) + _noteLayerSize.width/2,
                                        _yMargin  + istr*_noteLayerSize.height*(1+_yNotesSpace) + _noteLayerSize.height/2);
			note.bounds = CGRectMake(0, 0, NOTE_UNACTIVE_RADIUS*2, NOTE_UNACTIVE_RADIUS*2);
		
			[self.maskLayer addSublayer: note];
        }
	
	self.blurView.layer.mask = self.maskLayer;
	[self setNeedsDisplay];
}

- (void) layoutNotes {
	[self layoutNotesWithNewSize:[self bounds]];
}


#pragma mark __CGPoint_NotePosition__Conversion & NotePosition_CALayer__Finding

- (NotePosition*) findNotePositionFromPoint: (CGPoint) point {
	NotePosition* notePosition = [[NotePosition alloc] init];
	notePosition.x = (point.x-_xMargin) / (_noteLayerSize.width* (1+_xNotesSpace));
	notePosition.y = (point.y-_yMargin) / (_noteLayerSize.height*(1+_yNotesSpace));
	notePosition.y = self.fretboardSize.y - notePosition.y -1;
	return notePosition;
}

- (CGPoint) findPointAsMiddleOfLayerFromNotePosition: (NotePosition*) notePosition {
	NotePosition* copy = [[NotePosition alloc] init];
	copy.y = self.fretboardSize.y - notePosition.y -1;
	copy.x = notePosition.x;
	return CGPointMake(_xMargin+copy.x*(1+_xNotesSpace) *_noteLayerSize.width + _noteLayerSize.width /2,
				 	_yMargin+copy.y*(1+_yNotesSpace )*_noteLayerSize.height+ _noteLayerSize.height/2);
}

- (CALayer*) findNotesLayer: (NotePosition*) notePosition {
	NotePosition* copy = [[NotePosition alloc] init];
	copy.y = self.fretboardSize.y - notePosition.y -1;
	copy.x = notePosition.x;
	return [self.blurView.layer.mask.sublayers objectAtIndex: _fretboardSize.x*copy.y + copy.x];
}


#pragma mark __TouchEvents

- (void) touchesBegan:		(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableArray* newPressedNotes = [[NSMutableArray alloc] init];
	
	for(UITouch* t in touches) {
		NotePosition* notePosition = [self findNotePositionFromPoint:[t locationInView:self]];
		if(![self.touchesWithNotesPositions ifNotePositionAssociatedWithAnyTouch: notePosition]) {
			TouchWithNotePosition* newTNP = [[TouchWithNotePosition alloc] init];
			newTNP.touch = t;
			newTNP.notePosition = notePosition;
			[self.touchesWithNotesPositions.elements addObject:newTNP];
			[newPressedNotes addObject:notePosition];
		}
	}
	
	[self.receiverOfFretboardEvents notesPressed: newPressedNotes];
}

- (void) touchesMoved:		(NSSet *)touches withEvent:(UIEvent *)event {
	NSMutableArray* notesGlided = [[NSMutableArray alloc] initWithCapacity:[touches count]];
	NSMutableArray* values      = [[NSMutableArray alloc] initWithCapacity:[touches count]];

	for(UITouch* t in touches) {
		TouchWithNotePosition* tNP = [self.touchesWithNotesPositions ifTouchExist:t];
		
		GlidingValue *glidingValue = [[GlidingValue alloc] init];
		CGPoint touchPoint = [tNP.touch locationInView:self];
		CGPoint notePoint  = [self findPointAsMiddleOfLayerFromNotePosition: tNP.notePosition];
		glidingValue.x = touchPoint.x - notePoint.x;
		glidingValue.y = touchPoint.y - notePoint.y;
		[notesGlided addObject:tNP.notePosition];
		[values      addObject:glidingValue];
	}
	
	[self.receiverOfFretboardEvents notesGlided:notesGlided theirValues:values];
}

- (void) touchesCancelled:	(NSSet *)touches withEvent:(UIEvent *)event {
	/*NSMutableSet* setOfNotes = [[NSMutableSet alloc] init];
	for(UITouch* t in touches) {
		NotePosition* notePosition = [self findNotePositionFromPoint:[t locationInView:self]];
		[setOfNotes addObject: notePosition];
		[self.touchesAndAssociatedNotePosition removeObjectForKey:t];
		
	}
	[self.receiverOfFretboardEvents notesReleased: setOfNotes];*/
}

- (void) touchesEnded:		(NSSet *)touches withEvent:(UIEvent *)event {
	NSMutableArray* setOfNotes = [[NSMutableArray alloc] init];
	
    for(UITouch* t in touches) {
		TouchWithNotePosition* tNP = [self.touchesWithNotesPositions ifTouchExist:t];
		[setOfNotes addObject: tNP.notePosition];
		[self.touchesWithNotesPositions.elements removeObject:tNP];
	}
	
	[self.receiverOfFretboardEvents notesReleased: setOfNotes];
}

@end