#import "MainViewController.h"
#import "felidadaeAppDelegate.h"
#import "FretboardViewController.h"
#import "FretboardDestinationBridge.h"
#import "TabsContainerViewController.h"
#import "UIParams.h"



@interface MainViewController ()

@property (weak, nonatomic) IBOutlet 	UIView* fretboardContainer;
@property (weak, nonatomic) IBOutlet 	UIView* tabsContainer;
@property (strong, nonatomic) 			UIView* background;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfTabsContainerConstraint;

@property (strong, nonatomic) 		FretboardViewController* 	  fretboardVC;
@property (strong, nonatomic)  TabsContainerViewController*   tabsContainerVC;


@property (strong, readwrite) id<DestinationDelegate> destinationDelegate;
@property (strong, readwrite) id<TunerDelegate> tunerDelegate;

@end



@implementation MainViewController

#pragma mark Creation

- (void) viewDidLoad {
	[super viewDidLoad];
	[self prepareBackground];
	self.heightOfTabsContainerConstraint.constant = HEIGHT_OF_TABS_CONTAINER;
	[self animateMainViews];
	//self.fretboardContainer.alpha=0.0;
	//self.tabsContainer.alpha=0.0;
}

- (void) prepareBackground {
	felidadaeAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	self.background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
	self.background.backgroundColor = BACKGROUND_COLOR;
	self.background.autoresizingMask = UIViewAutoresizingNone;
	if(self.view.bounds.size.width < self.view.bounds.size.height) {
		CGFloat width = self.view.frame.size.width;
		CGFloat height = self.view.frame.size.height;
		self.background.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI / 2), CGAffineTransformMakeTranslation((width-height)/2, +(height-width)/2)) ;
	}
	//[delegate.window insertSubview:self.background  belowSubview:self.view];
	//[self.view insertSubview:self.background belowSubview:self.view];
	self.view.backgroundColor = BACKGROUND_COLOR;
}

- (void) viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	//[self prepareLigtenBase];
	/*UIVisualEffect *blurEffect;
	blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
	UIVisualEffectView *visualEffectView;
	visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
	visualEffectView.frame = self.view.frame;
	[self.view insertSubview: visualEffectView atIndex:0];*/
	
}

- (void)viewWillTransitionToSize:(CGSize)size
	   withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	
	[UIView animateWithDuration:0.25 animations:^{
		self.fretboardContainer.alpha = 0.0;
		self.tabsContainer.alpha = 0.0;
	}];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.25]];
	
	[coordinator animateAlongsideTransitionInView:self.background
									 animation:^(id<UIViewControllerTransitionCoordinatorContext> context)
		{
			if (size.width > size.height) {
				self.background.transform = CGAffineTransformMakeRotation(0.0);
				self.fretboardContainer.alpha=0.0;
			}
			else {
				CGFloat width = self.view.frame.size.width;
				CGFloat height = self.view.frame.size.height;
				self.view.transform = CGAffineTransformIdentity;
				self.background.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI / 2), CGAffineTransformMakeTranslation((width-height)/2, +(height-width)/2)) ;
			}
		} completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
			[UIView animateWithDuration:0.25 animations:^{
				self.fretboardContainer.alpha=1.0;
				self.tabsContainer.alpha=1.0;
			}];
		}];
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue
				 sender:(id)sender
{
	if(!self.destinationDelegate)
	{
		self.destinationDelegate = [[FretboardDestinationBridge alloc] init];
		self.tunerDelegate = (id<TunerDelegate>)self.destinationDelegate;
	}
	
	if ([segue.identifier isEqualToString:@"fretboard"]) {
		self.fretboardVC  = segue.destinationViewController;
		self.fretboardVC.destinationDelegate 	= self.destinationDelegate;
		self.fretboardVC.tunerDelegate 			= self.tunerDelegate;
		
		if(self.tabsContainerVC != nil) //if tabsContainer seque was evoked first
			self.tabsContainerVC.fretboardVC = self.fretboardVC;
	}
	
	if ([segue.identifier isEqualToString:@"tabsContainer"]) {
		self.tabsContainerVC  = segue.destinationViewController;
		self.tabsContainerVC.destinationDelegate 	= self.destinationDelegate;
		self.tabsContainerVC.tunerDelegate 			= self.tunerDelegate;
		self.tabsContainerVC.fretboardVC 			= self.fretboardVC;
	}
}


#pragma mark Animations

- (void) animateMainViews {
	CGPoint beginPositionOfFretboardView = self.fretboardContainer.center;
	CGPoint beginPositionOfControlView = self.tabsContainer.center;
	//self.fretboardContainer.center 	= CGPointMake(beginPositionOfFretboardView.x, 	beginPositionOfFretboardView.y 	- self.fretboardContainer.bounds.size.height);
	//self.tabsContainer.center 		= CGPointMake(beginPositionOfControlView.x, 	beginPositionOfControlView.y 	+ self.tabsContainer.bounds.size.height);
	
	self.view.alpha = 0.0;
	[UIView animateWithDuration:2
						  delay:1
		 usingSpringWithDamping:0.6
		  initialSpringVelocity:0.5
						options:0
					 animations:^{
						 self.view.alpha = 1.0;
						 self.fretboardContainer.center = beginPositionOfFretboardView;
						 self.tabsContainer.center = beginPositionOfControlView;
					 }
					 completion:^(BOOL finished) {
					 }];
}

@end
