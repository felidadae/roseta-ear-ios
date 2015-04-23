
#import "FretboardViewController.h"
#import "FretboardDestinationBridge.h"
#import "UIParams.h"



@interface FretboardViewController ()

@property (strong, nonatomic) IBOutlet FretboardView *fretboardView;

@end



@implementation FretboardViewController

#pragma mark __StandardViewControllerLife

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (void) viewDidLayoutSubviews {
	[self prepareFretboard];
	[self updateTuning];
	//[self colourNotes];
}

- (void) updateTuning {
	/* @TODO add custom tuning*/
	NSMutableArray* tuning = [[NSMutableArray alloc] initWithCapacity:[self getFretboardSize].y];
	for(unsigned i =0; i < [self getFretboardSize].y; ++i) {
		[tuning addObject: [[NSNumber alloc] initWithInteger:5]];
	}
	[self.tunerDelegate setTuning:tuning withBase:0 ];
	[self.tunerDelegate setFretboardSize:  [self getFretboardSize]];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark ___FretboardEventsReceiver

- (void) notesPressed: (NSArray *)    notesPositions {
	for(NotePosition *notePos in notesPositions)
	{
		[self animateNoteWithPosition:notePos ifForward:true];
		[self.destinationDelegate notePressed:notePos];
	}
}

- (void) notesGlided:  (NSArray *) notesPositions theirValues:(NSArray *)values {
	unsigned i = 0;
	for(NotePosition *notePos in notesPositions)
	{
		GlidingValue* glidingValue = [values objectAtIndex: i];
		[self animateNoteWithPosition:notePos withGlidingValue: glidingValue];
		[self.destinationDelegate noteGlided:notePos withValue:glidingValue];
		++i;
	}
}

- (void) notesReleased:(NSArray *)   notesPositions {
	for(NotePosition *notePos in notesPositions)
	{
		[self animateNoteWithPosition:notePos ifForward:false];
		[self.destinationDelegate noteReleased:notePos];
	}
}


#pragma mark ___ColourFretboard

- (void) prepareFretboard {
	self.fretboardView.receiverOfFretboardEvents = self;
	self.fretboardView.backgroundColor = CONTAINERS_BACKGROUND_COLOR;
	
	self.fretboardView.noteLayerSize 	= CGSizeMake(NOTE_DIAMETER,NOTE_DIAMETER);
	self.fretboardView.xNotesSpace 		= X_NOTE_SPACE;
	self.fretboardView.yNotesSpace 		= Y_NOTE_SPACE;
	self.fretboardView.minXMargin  		= CONTAINER_MIN_X_MARGIN;
	self.fretboardView.minYMargin  		= CONTAINER_MIN_Y_MARGIN;
	
	[self.fretboardView layoutNotes];
}

/*Custom colouring of FretboardView notes*/
- (void) colourNotes {
	NotePosition* fretboardSize = [self.fretboardView fretboardSize];
	
	NotePosition* iterator = [[NotePosition alloc] init];
	for(iterator.x=0; iterator.x < fretboardSize.x; ++iterator.x)
		for(iterator.y=0; iterator.y < fretboardSize.y; ++iterator.y)
		{
			CALayer* noteLayer = [self.fretboardView findNotesLayer: iterator];
			noteLayer.backgroundColor = [[self getProperColourForNoteWithPosition:iterator] CGColor];
			//noteLayer.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"kk"]] CGColor];
			//noteLayer.opacity = 0.5;
			noteLayer.cornerRadius = NOTE_ROUNDNESS;
			noteLayer.borderWidth = NOTE_BORDER;
			noteLayer.borderColor = [NOTE_BORDER_COLOUR CGColor];
			noteLayer.shadowColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] CGColor];
			noteLayer.shadowOffset = CGSizeMake(5, 5);
		}
}

- (UIColor*) getProperColourForNoteWithPosition: (NotePosition*) notePosition {
	return [UIColor NOTE_COLOUR alpha:NOTE_BASE_ALPHA + [self.tunerDelegate getFrequencyIndexFromPosition:notePosition]*NOTE_DELTA_STEP_ALPHA];
}

- (void) lightenBaseNote: (NotePosition*) notePosition directionIfForward: (bool) ifForward {
	[self animateNoteWithPosition:notePosition ifForward:ifForward];
}


#pragma mark __AnimationsOfNotes

- (void) animateNoteWithPosition: (NotePosition*) notePosition ifForward: (BOOL) ifForward {
	CALayer* noteLayer = [self.fretboardView findNotesLayer: notePosition];
	//noteLayer.backgroundColor = [[self getProperColourForNoteWithPosition: notePosition] CGColor];
	CGRect current = noteLayer.bounds;
	current.size.height = NOTE_UNACTIVE_RADIUS*2;
	current.size.width = NOTE_UNACTIVE_RADIUS*2;
	noteLayer.cornerRadius = NOTE_ROUNDNESS;
	[noteLayer setBounds:current];
	if(ifForward) {
		CGRect current = noteLayer.bounds;
		current.size.height = NOTE_TOUCHED_DIAMETER;
		current.size.width 	= NOTE_TOUCHED_DIAMETER;
		noteLayer.cornerRadius = NOTE_TOUCHED_RADIUS;
		[noteLayer setBounds:current];
		//CGFloat r, g, b, a;
		//UIColor* color = [UIColor colorWithCGColor:noteLayer.backgroundColor];
		//[color getRed:&r green:&g blue:&b alpha:&a];
		//float deltaAlpha = 0;
		//if(ifForward) deltaAlpha = NOTE_TOUCHED_DELTA_ALPHA; else deltaAlpha = 0;
		//noteLayer.backgroundColor=  [[UIColor colorWithRed:r
		//										 green:g
		//										  blue:b
		//										 alpha: a + deltaAlpha] CGColor];
	}
}

- (void) animateNoteWithPosition: (NotePosition*) notePosition
				withGlidingValue: (GlidingValue*) glidingValue {
	CALayer* noteLayer = [self.fretboardView findNotesLayer: notePosition];
	//CGFloat r, g, b, a;
	//UIColor* color = [self getProperColourForNoteWithPosition: notePosition];
	//[color getRed:&r green:&g blue:&b alpha:&a];
	//noteLayer.backgroundColor=  [[UIColor colorWithRed:r
	//											 green:g
	//											   blue:b
	//										  alpha:a + NOTE_TOUCHED_DELTA_ALPHA + glidingValue.x * NOTE_GLIDING_DELTA_STEP_ALPHA] CGColor];
}

#pragma mark __

- (NotePosition*) getFretboardSize {
	return [self.fretboardView fretboardSize];
}

@end
