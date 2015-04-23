
#import "TabsContainerViewController.h"
#import "MelodyComposerTabViewController.h"
#import "LooperTabViewController.h"
#import "MidiSettingsTabViewController.h"
#import "UIParams.h"

#define SegueIdentifier__MidiSettings   @"midiSettings"
#define SegueIdentifier__MelodyComposer @"melodyComposer"
#define SegueIdentifier__Looper         @"looper"
#define SegueIdentifier__DefaultTab     SegueIdentifier__MelodyComposer
#define Button_DefaultTab



@interface TabsContainerViewController ()

@property (assign, nonatomic) BOOL transitionInProgress;
@property (weak, nonatomic) id currentVC;
@property (weak, nonatomic) UIButton* previousB;
@property (weak, nonatomic) UIButton* currentB;

@property (weak, nonatomic) IBOutlet UIButton *melodyComposerButton;
@property (weak, nonatomic) IBOutlet UIButton *midiSettingsButton;
@property (weak, nonatomic) IBOutlet UIButton *looperButton;

@property (strong, nonatomic) MelodyComposerTabViewController *melodyComposerTabVC;
@property (strong, nonatomic) MidiSettingsTabViewController *midiSettingsTabVC;
@property (strong, nonatomic) LooperTabViewController *looperTabVC; //not implemented yet

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabsControllerButtonsViewWidthConstraint;

@end



@implementation TabsContainerViewController

#pragma mark Creation

- (void)viewDidLoad {
	[super viewDidLoad];
	//self.view.backgroundColor = CONTAINERS_BACKGROUND_COLOR;
	self.transitionInProgress = NO;
	[self performSegueWithIdentifier:SegueIdentifier__Looper   			sender:nil];
	[self performSegueWithIdentifier:SegueIdentifier__MelodyComposer 	sender:nil];
	[self performSegueWithIdentifier:SegueIdentifier__MidiSettings 		sender:nil];
	self.midiSettingsButton.alpha 	= BUTTON_ALPHA;
	self.melodyComposerButton.alpha = BUTTON_ALPHA;
	self.currentB.alpha *= DELTA_ALPHA_STATE_CONSTANT;
}


#pragma mark Seque
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:SegueIdentifier__Looper]) {
		self.looperTabVC  = segue.destinationViewController;
		//@Pass necessary data
	}
	
	if ([segue.identifier isEqualToString:SegueIdentifier__MelodyComposer]) {
		self.melodyComposerTabVC  = segue.destinationViewController;
		self.melodyComposerTabVC.destinationDelegate 	= self.destinationDelegate;
		self.melodyComposerTabVC.tunerDelegate 			= self.tunerDelegate;
		self.melodyComposerTabVC.fretboardVC 			= self.fretboardVC;
	}
	
	if ([segue.identifier isEqualToString:SegueIdentifier__MidiSettings]) {
		self.midiSettingsTabVC  = segue.destinationViewController;
		//@Pass necessary data
	}
	
	UIView* destView = ((UIViewController *)segue.destinationViewController).view;
	destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	
	if([segue.identifier isEqualToString:SegueIdentifier__DefaultTab])
	{
		[self addChildViewController:segue.destinationViewController];
		[self.view addSubview:destView];
		[segue.destinationViewController didMoveToParentViewController:self];
		self.currentVC = self.melodyComposerTabVC;
		self.currentB = self.melodyComposerButton;
	}
}


#pragma mark Events
- (IBAction)melodyButtonClicked:(id)sender {
	if(self.currentVC != self.melodyComposerTabVC )
		[self changeViewControllerTo:self.melodyComposerTabVC];
}

- (IBAction)midiSettingsClicked:(id)sender {
	if(self.currentVC != self.midiSettingsTabVC )
		[self changeViewControllerTo:self.midiSettingsTabVC];
}

- (IBAction)looperClicked:(id)sender {
	if(self.currentVC != self.looperTabVC )
		[self changeViewControllerTo:self.looperTabVC];
}


#pragma mark ChangingViewController

- (void)changeViewControllerTo:(UIViewController*) toViewController {
	if (self.transitionInProgress)
		return;
	self.transitionInProgress = YES;
	
	toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	
	self.previousB = self.currentB;
	if([toViewController isKindOfClass:[MelodyComposerTabViewController class]]) {
		self.currentB = self.melodyComposerButton;
	}
	if([toViewController isKindOfClass:[MidiSettingsTabViewController class]]) {
		self.currentB = self.midiSettingsButton;
	}
	if([toViewController isKindOfClass:[LooperTabViewController class]]) {
		//self.currentB = self.looperButton;
	}
	
	[self.currentVC willMoveToParentViewController:nil];
	[self addChildViewController:toViewController];
	
	
	
	[self transitionFromViewController:self.currentVC
					  toViewController:toViewController
							  duration:0.5
							   options:UIViewAnimationOptionTransitionCrossDissolve
							animations:^ {}
							completion:^(BOOL finished)
		{
			[self animateControlButtons];
			[self.currentVC removeFromParentViewController];
			[toViewController didMoveToParentViewController:self];
			self.currentVC =  toViewController;
			self.transitionInProgress = NO;
		}
	];
}


#pragma mark Animations

- (void) animateControlButtons {
	[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
		self.currentB.alpha   *= K;
		self.previousB.alpha  /= K;
	} completion:^(BOOL finished) {
	}];

}

@end
