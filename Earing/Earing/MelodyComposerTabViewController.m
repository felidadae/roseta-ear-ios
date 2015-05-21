
#import "MelodyComposerTabViewController.h"
#import "FretboardDestinationBridge.h"
#import "MelodyComposer.h"
#include "UIParams.h"
#include "MelodyComposerSettingsTabViewController.h"
#include "DrawView.h"



@interface MelodyComposerTabViewController ()

@property (strong, nonatomic) MelodyComposer* melodyComposer;

@property (weak, nonatomic) IBOutlet UIButton *nwwMelodyButton;
@property (weak, nonatomic) IBOutlet UIButton *repeatMelodyButton;
@property (weak, nonatomic) IBOutlet UIButton *showSettingsButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsHeightConstraint;

@end



@implementation MelodyComposerTabViewController

#pragma mark Creation

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = CONTAINERS_BACKGROUND_COLOR;
	
	self.melodyComposer = [[MelodyComposer alloc] init];
	self.melodyComposer.maxInterval = 5;
	self.melodyComposer.minimumLengthOfNote = 0.5;
	self.melodyComposer.phraseLength = 5;

	[self setSizeOfButtons];
	[self colourButtons];
	[self setDrawBlackForView];
	self.nwwMelodyButton.hidden = NO;
}

- (void) viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	[self.view setNeedsDisplay];
}

- (void) setSizeOfButtons {
	self.buttonsWidthConstraint.constant 	= BUTTON_HEIGHT;
	self.buttonsHeightConstraint.constant   = BUTTON_HEIGHT;
}

- (void) colourButtons {
	self.nwwMelodyButton.layer.borderWidth = 15;
	self.nwwMelodyButton.layer.borderColor       = [BUTTON_BORDER_COLOR CGColor];
	self.nwwMelodyButton.layer.backgroundColor   = [BUTTON_COLOUR CGColor];
	//self.nwwMelodyButton.alpha = BUTTON_ALPHA;
	self.nwwMelodyButton.layer.cornerRadius 	= BUTTON_HEIGHT/2;
	//self.nwwMelodyButton.layer addSublayer:
	
	self.repeatMelodyButton.layer.borderWidth = 0;
	self.repeatMelodyButton.layer.borderColor     = [BUTTON_BORDER_COLOR CGColor];
	self.repeatMelodyButton.layer.backgroundColor = [BUTTON_COLOUR CGColor];
	//self.repeatMelodyButton.alpha = BUTTON_ALPHA;
	self.repeatMelodyButton.layer.cornerRadius 	= BUTTON_HEIGHT/2;
	
	
	self.showSettingsButton.layer.borderWidth = 25;
	self.showSettingsButton.layer.borderColor       = [BUTTON_BORDER_COLOR CGColor];
	self.showSettingsButton.layer.backgroundColor   = [BUTTON_COLOUR CGColor];
	//self.showSettingsButton.alpha = BUTTON_ALPHA;
	self.showSettingsButton.layer.cornerRadius 	= BUTTON_HEIGHT/2;
}

- (void) setDrawBlackForView {
	DrawView* view = (DrawView*) self.view;
	view.drawBlock = ^(UIView* v,CGContextRef context)
	{
		UIColor *backgroundColor = CONTAINERS_BACKGROUND_COLOR;
		[backgroundColor setFill];
		UIRectFill(self.view.bounds);
	
		NSArray* arrayOfButtons = [[NSArray alloc] initWithObjects:self.nwwMelodyButton, self.repeatMelodyButton, self.showSettingsButton, nil];
		for(UIView* button in arrayOfButtons) {
			CGRect holeRect = CGRectMake(0, 0, 0, 0);
			CGRect buttonFrame = [button convertRect:button.bounds toView:self.view];
			holeRect.origin = CGPointMake(buttonFrame.origin.x-10, buttonFrame.origin.y-10);
			holeRect.size = CGSizeMake(buttonFrame.size.width+20,  buttonFrame.size.height+20);
			
			CGRect holeRectIntersection = CGRectIntersection( holeRect, v.bounds );
			CGContextRef context = UIGraphicsGetCurrentContext();
			CGContextSaveGState(context);
			if( CGRectIntersectsRect( holeRectIntersection, v.bounds ) )
			{
				CGContextAddEllipseInRect(context, holeRectIntersection);
				CGContextClip(context);
				CGContextClearRect(context, holeRectIntersection);
				CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
				CGContextFillRect( context, holeRectIntersection);
				CGContextRestoreGState(context);
			}
		}
	};
}


#pragma mark Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"popover"]) {
		MelodyComposerSettingsTabViewController* vc = segue.destinationViewController;
		vc.melodyComposer = self.melodyComposer;
	}
}


#pragma mark FretboardVC Communication

- (NSUInteger) getMaximumFretboardFrequencyIndex {
	NotePosition* note = [[NotePosition alloc] init];
	note.x =[self.fretboardVC getFretboardSize].x;
	note.y =[self.fretboardVC getFretboardSize].y;
	
	--note.x; --note.y;
	NSUInteger maximumFretboardFrequencyIndex =
		[self.tunerDelegate getFrequencyIndexFromPosition: note];
	return maximumFretboardFrequencyIndex;
}

- (void) testWithPosition: (NotePosition*)note {
	[self.fretboardVC lightenBaseNote:note directionIfForward:FALSE];
}


#pragma mark MelodyComposer Communication

- (void) playMelodyFromMelodyComposer {
	NotePosition* note = [[NotePosition alloc] init];
	note.x = 0;
	note.y = 0;
	NSArray* melody = [self.melodyComposer lastMelody];
	NSUInteger interval =  [[melody objectAtIndex:0] unsignedIntegerValue] - 0;
	NotePosition* notePosition = [self.tunerDelegate getNotePositionWithPreviousNotePosition:note withInterval: interval];
	[self.fretboardVC lightenBaseNote:notePosition directionIfForward:TRUE];
	[self performSelector:@selector(testWithPosition:) withObject:notePosition afterDelay:1];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
											 (unsigned long)NULL), ^(void)
				   {
				   
				   NSArray* melody = [self.melodyComposer lastMelody];
				   NotePosition* previousNotePosition = [[NotePosition alloc] init];
				   previousNotePosition.x = 0;
				   previousNotePosition.y = 0;
				   NSUInteger previousFrequencyIndex = 0;
				   for (NSUInteger i = 0; i < [melody count]; i+=2) {
					   NSUInteger interval = [[melody objectAtIndex:i] unsignedIntegerValue] - previousFrequencyIndex;
					   NotePosition* notePosition = [self.tunerDelegate getNotePositionWithPreviousNotePosition:previousNotePosition withInterval: interval];
					   [self.destinationDelegate notePressed:notePosition];
					   [NSThread sleepForTimeInterval:    [[melody objectAtIndex:i+1] floatValue]];
					   [self.destinationDelegate noteReleased:notePosition];
					   previousNotePosition = notePosition;
					   previousFrequencyIndex = [[melody objectAtIndex:i] unsignedIntegerValue];
				   }
				   
				   dispatch_sync(dispatch_get_main_queue(), ^{
					   [self animateOffNuwMelodyButton];
				   });//end block
				   });
}


#pragma mark EventsHandling

- (IBAction)nwwMelodyButtonClicked:(id)sender {
	[self.nwwMelodyButton setEnabled:FALSE];
	[self.repeatMelodyButton setEnabled:FALSE];
	[self animateOnNuwMelodyButton];
	
	[self.melodyComposer newMelodyWithMin:0
				  withMaxFrequencyIndexes: [self getMaximumFretboardFrequencyIndex]];
	[self playMelodyFromMelodyComposer];
}

- (IBAction)repeatMelodyButtonClicked:(id)sender {
	[self.nwwMelodyButton setEnabled:FALSE];
	[self.repeatMelodyButton setEnabled:FALSE];
	[self animateOnNuwMelodyButton];
	[self playMelodyFromMelodyComposer];
}


#pragma mark Animations

- (void) animateOnNuwMelodyButton {
#define K 3
	[UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
		self.nwwMelodyButton.alpha /= K;
		self.repeatMelodyButton.alpha /= K;
	} completion:^(BOOL finished) {
	}];
}

- (void) animateOffNuwMelodyButton {
	[UIView animateKeyframesWithDuration:1.0 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
		self.nwwMelodyButton.alpha *= K;
		self.repeatMelodyButton.alpha *= K;
	} completion:^(BOOL finished) {
		;
	}];

	[self.nwwMelodyButton setEnabled:TRUE];
	[self.repeatMelodyButton setEnabled:TRUE];
}

@end
