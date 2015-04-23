#import "DrawView.h"

@implementation DrawView

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if(self.drawBlock)
		self.drawBlock(self,context);
}

@end