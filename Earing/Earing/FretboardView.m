
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
@property (readwrite) CGFloat xMargin;
@property (readwrite) CGFloat yMargin;
@property (strong, readwrite) TouchesWithNotePositions* touchesWithNotesPositions;

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
}


#pragma mark __LayoutNotes

- (void) layoutNotesWithNewSize:(CGRect)newSize {
	while ([self.layer.sublayers count] > 2)
		[[self.layer.sublayers objectAtIndex:2] removeFromSuperlayer];

	
	CGRect screenRect = newSize;
    CGFloat width  = screenRect.size.width;
    CGFloat height = screenRect.size.height;
	
	self.fretboardSize.x  = (width -2*_minXMargin)/_noteLayerSize.width /(_xNotesSpace+1);
	self.fretboardSize.y  = (height-2*_minYMargin)/_noteLayerSize.height/(_yNotesSpace+1);
	self.xMargin = (width -  (_fretboardSize.x) * _noteLayerSize.width  - (_fretboardSize.x-1) * _noteLayerSize.width  * _xNotesSpace)/2;
	self.yMargin = (height - (_fretboardSize.y) * _noteLayerSize.height - (_fretboardSize.y-1) * _noteLayerSize.height * _yNotesSpace)/2;
    
    for(int istr = 0; istr < _fretboardSize.y; ++istr)
        for(int inot = 0; inot < _fretboardSize.x; ++inot )
        {
			UIVisualEffect *blurEffect;
			blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		
			UIView* note = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
			note.frame = CGRectMake(_xMargin  + inot*_noteLayerSize.width *(1+_xNotesSpace) + _noteLayerSize.width/2,
								_yMargin  + istr*_noteLayerSize.height*(1+_yNotesSpace) + _noteLayerSize.height/2,
									NOTE_UNACTIVE_RADIUS*2, NOTE_UNACTIVE_RADIUS*2);
			note.layer.cornerRadius = NOTE_UNACTIVE_RADIUS;
		
			[note setClipsToBounds:true ];
			note.layer.position = CGPointMake(_xMargin  + inot*_noteLayerSize.width *(1+_xNotesSpace) + _noteLayerSize.width/2,
                                        _yMargin  + istr*_noteLayerSize.height*(1+_yNotesSpace) + _noteLayerSize.height/2);
			note.layer.bounds = CGRectMake(0, 0, NOTE_UNACTIVE_RADIUS*2, NOTE_UNACTIVE_RADIUS*2);
		
			[self addSubview:note];
        }
	
	
	
	//[self setNeedsDisplay];
	
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
	return [self.layer.sublayers objectAtIndex:2+ _fretboardSize.x*copy.y + copy.x];
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



#pragma mark __CustomDrawing

/* @TODO Testing appearance of "cut shapes" in a view; propably code should be improved */
/*- (void)drawRect:(CGRect)rect {
	UIColor *backgroundColor = CONTAINERS_BACKGROUND_COLOR;
	[backgroundColor setFill];
	UIRectFill(rect);
	
	CGRect screenRect = self.bounds;
	CGFloat width  = screenRect.size.width;
	CGFloat height = screenRect.size.height;
	
	self.fretboardSize.x  = (width -2*_minXMargin)/_noteLayerSize.width /(_xNotesSpace+1);
	self.fretboardSize.y  = (height-2*_minYMargin)/_noteLayerSize.height/(_yNotesSpace+1);
	self.xMargin = (width -  (_fretboardSize.x) * _noteLayerSize.width  - (_fretboardSize.x-1) * _noteLayerSize.width  * _xNotesSpace)/2;
	self.yMargin = (height - (_fretboardSize.y) * _noteLayerSize.height - (_fretboardSize.y-1) * _noteLayerSize.height * _yNotesSpace)/2;
	
	for(int istr = 0; istr < _fretboardSize.y; ++istr)
		for(int inot = 0; inot < _fretboardSize.x; ++inot )
		{
			CGRect holeRect = CGRectMake(0, 0, 0, 0);
			holeRect.origin = CGPointMake(_xMargin  + inot*_noteLayerSize.width *(1+_xNotesSpace) , _yMargin  + istr*_noteLayerSize.height*(1+_yNotesSpace) );
			holeRect.size = CGSizeMake(_noteLayerSize.width, _noteLayerSize.height);
		
			CGRect holeRectIntersection = CGRectIntersection( holeRect, rect );
			CGContextRef context = UIGraphicsGetCurrentContext();
			CGContextSaveGState(context);
			if( CGRectIntersectsRect( holeRectIntersection, rect ) )
			{
				CGContextAddEllipseInRect(context, holeRectIntersection);
				CGContextClip(context);
				CGContextClearRect(context, holeRectIntersection);
				CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
				CGContextFillRect( context, holeRectIntersection);
				CGContextRestoreGState(context);
			}
		}
}*/

@end