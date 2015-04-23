
#import "Utils.h"



@implementation Utils

+ (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
	float diff = bigNumber - smallNumber;
	return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

+ (unsigned) randomUnsignedBetween:(unsigned)smallNumber and:(unsigned) bigNumber {
	return arc4random_uniform(bigNumber-smallNumber)+smallNumber;
}

@end
