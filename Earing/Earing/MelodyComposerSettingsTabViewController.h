
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MelodyComposer.h"

@interface MelodyComposerSettingsTabViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) MelodyComposer* melodyComposer;

@end
