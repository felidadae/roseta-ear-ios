#import "TabChooserButton.h"
#include "UIParams.h"



@implementation TabChooserButton

- (void)awakeFromNib {
	[super awakeFromNib];
	self.layer.borderColor       = [[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor];
	self.layer.backgroundColor   = [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:BUTTON_ALPHA] CGColor];
	self.layer.cornerRadius = self.bounds.size.width/2;
}

@end
