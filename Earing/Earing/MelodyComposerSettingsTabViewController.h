
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MelodyComposerBridge.h"

@interface MelodyComposerSettingsTabViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) MelodyComposerBridge* melodyComposer;

@end
