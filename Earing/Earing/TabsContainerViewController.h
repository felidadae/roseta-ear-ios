
#import "DestinationDelegate.h"
#import "TunerDelegate.h"
#import "FretboardViewController.h"



@interface TabsContainerViewController : UIViewController

@property (weak, nonatomic) FretboardViewController* 		fretboardVC;
@property (readwrite) id<DestinationDelegate> destinationDelegate;
@property (readwrite) id<TunerDelegate> tunerDelegate;

@end
