#import "NotePosition.h"


@implementation NotePosition
-(id) copyWithZone:(NSZone *)zone {
	NotePosition* n = [[NotePosition alloc] init];
	n.x = self.x;
	n.y = self.y;
	return n;
}
@end
