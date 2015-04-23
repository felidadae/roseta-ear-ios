#import "MidiSettingsTabViewController.h"



@interface MidiSettingsTabViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *wifiStandaloneSwitch;
@property (weak, nonatomic) IBOutlet UILabel *midiControllerLabel;
@property (weak, nonatomic) IBOutlet UILabel *standaloneLabel;

@end



@implementation MidiSettingsTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.midiControllerLabel.alpha = 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)changeMidiControllerStandaloneSlider:(id)sender {
	if([self.wifiStandaloneSwitch isOn])
		[UIView animateWithDuration:1.0 animations:^{
			self.standaloneLabel.alpha = 0.25;
			self.midiControllerLabel.alpha = 0.1;
		}];
	else
		[UIView animateWithDuration:1.0 animations:^{
			self.standaloneLabel.alpha = 0.1;
			self.midiControllerLabel.alpha = 0.25;
		}];
}

@end
