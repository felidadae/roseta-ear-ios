
#import "MelodyComposerSettingsTabViewController.h"



@interface MelodyComposerSettingsTabViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *maxIntervalPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *phraseLengthPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *minimumNoteLengthPicker;

@end



@implementation MelodyComposerSettingsTabViewController

#pragma mark Creation

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.preferredContentSize = CGSizeMake(768, 300); //@TODO center popover and set size in function of available space;
	self.popoverPresentationController.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
	self.popoverPresentationController.containerView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
	
	self.maxIntervalPicker.delegate 		= self;
	self.maxIntervalPicker.dataSource 		= self;
	self.phraseLengthPicker.delegate 		= self;
	self.phraseLengthPicker.dataSource 		= self;
	self.minimumNoteLengthPicker.dataSource = self;
	self.minimumNoteLengthPicker.delegate 	= self;
	
	[self.maxIntervalPicker 		selectRow:[self.melodyComposer maxInterval]-2 		inComponent:0 animated:false ];
	[self.minimumNoteLengthPicker 	selectRow:[self.melodyComposer minNoteLength]*10-1 	inComponent:0 animated:false ];
	[self.minimumNoteLengthPicker 	selectRow:3 										inComponent:0 animated:false ];
} 


#pragma mark UIPickerViewDataSource, UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (pickerView == self.maxIntervalPicker)
	{
		[self.melodyComposer setMaxInterval:row+2];
	}
	if (pickerView == self.minimumNoteLengthPicker)
	{
		[self.melodyComposer setMinNoteLength: ((float)row+1)*0.1];
	}
	if (pickerView == self.phraseLengthPicker)
	{
		[self.melodyComposer setPhraseSize:row+1];
	}
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 50;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 50;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
	attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *title = @"";
	if (pickerView == self.maxIntervalPicker)
		title = [NSString stringWithFormat:@"%d", (int)(row+2)];
	if (pickerView == self.minimumNoteLengthPicker)
		title = [NSString stringWithFormat:@"%.01f", (float)((float)(row+1)*0.1)];
	if (pickerView == self.phraseLengthPicker)
		title = [NSString stringWithFormat:@"%d", (int)(row+2)];
	NSAttributedString *attString =
		[[NSAttributedString alloc] initWithString:title
			attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
	return attString;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSInteger row = 0;
	if (pickerView == self.maxIntervalPicker)
	{
		row = 10;
	}
	if (pickerView == self.minimumNoteLengthPicker)
	{
		row = 10;
	}
	if (pickerView == self.phraseLengthPicker)
	{
		row = 10;
	}
	return row;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}



@end
