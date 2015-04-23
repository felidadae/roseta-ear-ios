//#import <UIKit/UIKit.h>
////
//#import "InstrumentViewController.h"
//#import "FretboardView.h"
//#import "SynthHost.h"
//#import "MelodyComposer.h"
//#import "MidiManager.h"
//
//
//
//@interface InstrumentViewController ()
//
//@property (weak, nonatomic) IBOutlet FretboardView*	fretboard;
//
//@property (weak, nonatomic) IBOutlet UIView*     	synthControlsView;
///**/@property (weak, nonatomic) IBOutlet UIButton*	nuwMelodyButton;
///**/@property (weak, nonatomic) IBOutlet UIButton*	repeatMelodyButton;
///**/@property (weak, nonatomic) IBOutlet UILabel*	standaloneLabel;
///**/@property (weak, nonatomic) IBOutlet UILabel*	midiControllerLabel;
///**/@property (weak, nonatomic) IBOutlet UISwitch*	wifiStandaloneSwitch;
//
//@property MidiManager*     midiManager;
//@property SynthHost*       synthHost;
//
//
//
//@end
//
//
//
//@implementation InstrumentViewController
//
//#pragma mark Initialization
//
//- (void) viewDidLoad {
//	[super viewDidLoad];
//	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"burzu.png"]];
//	
//	[self prepareControls];
//	[self prepareFretboard];
//	[self prepareSynthHost];
//	[self prepareMelodyComposer];
//	self.midiManager = [[MidiManager alloc] init];
//}
//
//- (void) viewWillAppear:(BOOL)animated {
//	[self animateMainViews];
//}
//
//
//#pragma mark ___Appearance
//
//- (void) prepareFretboard {
//	_fretboard.receiverOfFretboardEvents = self;
//	_fretboard.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.05];
//	/*[_fretboard updateFretboard__withNoteSize:CGSizeMake(70,70)
//							  withXNotesSpace:0.2
//							  withYNotesSpace:0.2
//							   withMinXMargin:5
//							   withMinYMargin:0];*/
//	[self colourNotes];
//}
//
//- (void) colourNotes {
//	NotePosition* fretboardSize = [self.fretboard fretboardSize];
//	
//	NotePosition* iterator = [[NotePosition alloc] init];
//	for(iterator.x=0; iterator.x < fretboardSize.x; ++iterator.x)
//		for(iterator.y=0; iterator.y < fretboardSize.y; ++iterator.y)
//		{
//			CALayer* noteLayer = [self.fretboard findNotesLayer: iterator];
//			noteLayer.backgroundColor = [[self getProperColourForNoteWithPosition:iterator] CGColor];
//			noteLayer.cornerRadius = 10;
//		}
//}
//
//- (UIColor*) getProperColourForNoteWithPosition: (NotePosition*) notePosition {
//	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.05 + [self findNoteMainFrequencyFromNotePosition:notePosition]*0.01];
//}
//
//- (void) prepareControls {
//	self.midiControllerLabel.alpha = 0.1;
//	_synthControlsView.layer.backgroundColor   = [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.05] CGColor];
//	[self prepareControlButtons];
//}
//
//- (void) prepareControlButtons {
//	_nuwMelodyButton.layer.borderWidth = 20.0;
//	_nuwMelodyButton.layer.borderColor       = [[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor];
//	_nuwMelodyButton.layer.backgroundColor   = [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] CGColor];
//	_nuwMelodyButton.alpha = 0.1;
//	_nuwMelodyButton.layer.cornerRadius = _nuwMelodyButton.bounds.size.width/2;
//	
//	/*_nuwMelodyButton.layer.shadowColor = [[UIColor colorWithRed:0.0 green:0.0 blue:0.2 alpha:0.8] CGColor];
//	_nuwMelodyButton.layer.shadowOpacity = 0.5;
//	_nuwMelodyButton.layer.shadowRadius = 0;*/
//	
//	_repeatMelodyButton.layer.borderWidth = 0.0;
//	_repeatMelodyButton.layer.borderColor     = [[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor];
//	_repeatMelodyButton.layer.backgroundColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor];
//	_repeatMelodyButton.alpha = 0.1;
//	_repeatMelodyButton.layer.cornerRadius = _repeatMelodyButton.bounds.size.width/2;
//	
//	/*_repeatMelodyButton.layer.shadowColor = [[UIColor colorWithRed:0.0 green:0.0 blue:0.2 alpha:0.8] CGColor];
//	_repeatMelodyButton.layer.shadowOpacity = 0.5;
//	_repeatMelodyButton.layer.shadowRadius = 0;*/
//}
//
//#pragma mark ___Friends
//
//- (void) prepareSynthHost {
//	_synthHost = [[SynthHost alloc] init];
//	[_synthHost  play];
//}
//
//- (void) prepareMelodyComposer {
//	self.melodyComposer = [[MelodyComposer alloc] init];
//	self.melodyComposer.maxInterval = 5;
//	self.melodyComposer.minimumLengthOfNote = 0.5;
//	self.melodyComposer.phraseLength = 5;
//}
//
//
//
//#pragma mark FretboardIssues
//
//#pragma mark ___FretboardEventsReceiver Protocol
//
//- (void) notesPressed: (NSSet*)    notesPositions {
//	for(NotePosition *notePos in notesPositions)
//	{
//		[self animateNoteWithPosition:notePos ifForward:true];
//		if([self.wifiStandaloneSwitch isOn])
//			_synthHost->synth->attackNote([self findNoteMainFrequencyFromNotePosition:notePos]);
//		else
//			[self.midiManager midiSendOnNoteInForeground: [self findNoteMainFrequencyFromNotePosition:notePos]+50];
//	}
//	
//}
//
//- (void) notesGlided:  (NSArray *) notesPositions theirValues:(NSArray *)values {
//	unsigned i = 0;
//	for(NotePosition *notePos in notesPositions)
//	{
//		GlidingValue* glidingValue = [values objectAtIndex: i];
//		[self animateNoteWithPosition:notePos withGlidingValue: glidingValue];
//		if([self.wifiStandaloneSwitch isOn])
//			_synthHost->synth->bendNote((unsigned int)[self findNoteMainFrequencyFromNotePosition:notePos], (float)glidingValue.x, (float)glidingValue.y);
//		else
//			;//[self.midiManager midiSendOnNoteInForeground: [self findNoteMainFrequencyFromNotePosition:notePos]+50];
//		
//		++i;
//	}
//}
//
//- (void) notesReleased:(NSSet *)   notesPositions {
//	for(NotePosition *notePos in notesPositions)
//	{
//		[self animateNoteWithPosition:notePos ifForward:false];
//		if([self.wifiStandaloneSwitch isOn])
//			_synthHost->synth->realeaseNote([self findNoteMainFrequencyFromNotePosition:notePos]);
//		else
//			[self.midiManager midiSendOffNoteInForeground: [self findNoteMainFrequencyFromNotePosition:notePos]+50];
//	}
//	
//}
//
//#pragma mark ___FretboardTuning
//
//- (NSUInteger) findNoteMainFrequencyFromNotePosition: (NotePosition*) notePosition {
//	return (self.fretboard.fretboardSize.y-notePosition.y-1)*5+notePosition.x;
//}
//
//- (NSUInteger) getNoteMainMaxFrequency {
//	return (self.fretboard.fretboardSize.y-1)*5+self.fretboard.fretboardSize.x;
//}
//
//
//
//#pragma mark MainViewController
//
//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscape;
//}
//
//
//
//#pragma mark ControllsEventsHandling
//
//- (IBAction)changeMidiControllerStandaloneSlider:(id)sender {
//	if([self.wifiStandaloneSwitch isOn])
//		[UIView animateWithDuration:1.0 animations:^{
//			self.standaloneLabel.alpha = 0.25;
//			self.midiControllerLabel.alpha = 0.1;
//		}];
//	else
//		[UIView animateWithDuration:1.0 animations:^{
//			self.standaloneLabel.alpha = 0.1;
//			self.midiControllerLabel.alpha = 0.25;
//		}];
//}
//
//#pragma mark ___MelodyComposer
//
//- (IBAction)newMolodyAc:(id)sender {
//	[self.nuwMelodyButton setEnabled:FALSE];
//	[self.repeatMelodyButton setEnabled:FALSE];
//	[self.wifiStandaloneSwitch setEnabled:FALSE];
//	[self animateOnNuwMelodyButton];
//	[self.melodyComposer newMelodyWithMin:0 withMaxFrequencyIndexes: [self getNoteMainMaxFrequency]];
//	[self playMelodyFromMelodyComposer];
//}
//
//- (IBAction)repeatMelodyAction:(id)sender {
//	[self.nuwMelodyButton setEnabled:FALSE];
//	[self.repeatMelodyButton setEnabled:FALSE];
//	[self.wifiStandaloneSwitch setEnabled:FALSE];
//	[self animateOnNuwMelodyButton];
//	[self playMelodyFromMelodyComposer];
//}
//
//- (void) playMelodyFromMelodyComposer {
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
//											 (unsigned long)NULL), ^(void) {
//		NSArray* melody = [self.melodyComposer lastMelody];
//		for (NSUInteger i = 0; i < [melody count]; i+=2) {
//			self.synthHost->synth->attackNote  ([[melody objectAtIndex:i] unsignedIntegerValue]);
//			[NSThread sleepForTimeInterval:    [[melody objectAtIndex:i+1] floatValue]];
//			self.synthHost->synth->realeaseNote([[melody objectAtIndex:i] unsignedIntegerValue]);
//		}
//		dispatch_sync(dispatch_get_main_queue(), ^{
//			[self animateOffNuwMelodyButton];
//		});//end block
//	});
//}
//
//
//
//#pragma mark Animations
//
//- (void) animateNoteWithPosition: (NotePosition*) notePosition ifForward: (BOOL) ifForward {
//	CALayer* noteLayer = [self.fretboard findNotesLayer: notePosition];
//	noteLayer.backgroundColor = [[self getProperColourForNoteWithPosition: notePosition] CGColor];
//	if(ifForward) {
//		CGFloat r, g, b, a;
//		UIColor* color = [UIColor colorWithCGColor:noteLayer.backgroundColor];
//		[color getRed:&r green:&g blue:&b alpha:&a];
//		float deltaAlpha = 0;
//		if(ifForward) deltaAlpha = 0.1; else deltaAlpha = 0;
//		noteLayer.backgroundColor=  [[UIColor colorWithRed:r
//													 green:g
//													  blue:b
//													 alpha: a + deltaAlpha] CGColor];
//	}
//}
//	
//- (void) animateNoteWithPosition: (NotePosition*) notePosition withGlidingValue: (GlidingValue*) glidingValue {
//	CALayer* noteLayer = [self.fretboard findNotesLayer: notePosition];
//	CGFloat r, g, b, a;
//	UIColor* color = [self getProperColourForNoteWithPosition: notePosition];
//	[color getRed:&r green:&g blue:&b alpha:&a];
//	noteLayer.backgroundColor=  [[UIColor colorWithRed:r
//										      green:g
//											   blue:b
//											  alpha:a + 0.1 + glidingValue.x * 0.001] CGColor];
//}
//
//- (void) animateMainViews {
//	CGPoint beginPositionOfFretboardView = self.fretboard.center;
//	self.fretboard.center = CGPointMake(beginPositionOfFretboardView.x, beginPositionOfFretboardView.y - self.fretboard.bounds.size.height);
//	[UIView animateWithDuration:2
//						  delay:0.5
//		 usingSpringWithDamping:0.6
//		  initialSpringVelocity:0.5
//						options:0
//					 animations:^{
//						self.fretboard.center = beginPositionOfFretboardView;
//					 }
//					 completion:^(BOOL finished) {
//						 //Completion Block
//					 }];
//	
//	
//	
//	
//	
//	
//	CGPoint beginPositionOfControlView = self.synthControlsView.center;
//	self.synthControlsView.center = CGPointMake(beginPositionOfControlView.x, beginPositionOfControlView.y + self.synthControlsView.bounds.size.height);
//	[UIView animateWithDuration:2
//						  delay:0.5
//		 usingSpringWithDamping:0.6
//		  initialSpringVelocity:0.5
//						options:0
//					 animations:^{
//						 self.synthControlsView.center = beginPositionOfControlView;
//					 }
//					 completion:^(BOOL finished) {
//						 //Completion Block
//					 }];
//}
//
//- (void) animateOnNuwMelodyButton {
//#define K 3
//	[UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
//		self.nuwMelodyButton.alpha /= K;
//		self.repeatMelodyButton.alpha /= K;
//		self.midiControllerLabel.alpha /= K;
//		self.standaloneLabel.alpha /= K;
//		self.wifiStandaloneSwitch.alpha /= K;
//	} completion:^(BOOL finished) {
//	}];
//}
//
//- (void) animateOffNuwMelodyButton {
//	[UIView animateKeyframesWithDuration:1.0 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
//		self.nuwMelodyButton.alpha *= K;
//		self.repeatMelodyButton.alpha *= K;
//		self.midiControllerLabel.alpha *= K;
//		self.standaloneLabel.alpha *= K;
//		self.wifiStandaloneSwitch.alpha *= K;
//	} completion:^(BOOL finished) {
//		;
//	}];
//	
//	[self.nuwMelodyButton setEnabled:TRUE];
//	[self.repeatMelodyButton setEnabled:TRUE];
//	[self.wifiStandaloneSwitch setEnabled:TRUE];
//}
//
//@end
//
//
//
//
