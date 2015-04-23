#import "BlackoutView.h"

@implementation BlackoutView

- (void)drawRect:(CGRect)rect
{
	[self.fillColor setFill];
	UIRectFill(rect);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
	
	for (NSValue *value in self.framesToCutOut) {
		CGRect pathRect = [value CGRectValue];
		UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:pathRect];
		[path fill];
	}
	
	CGContextSetBlendMode(context, kCGBlendModeNormal);
}

@end