
#import <Foundation/Foundation.h>
//
#import "FretboardView.h"
#import "Synth.h"
#import "ConvolutionFilter.h"

@interface SynthHost : NSObject {
	@public
	Synth* synth;
	ConvolutionFilter* convolutionFilter;
}

- (id) initWithTuner: (Tuner*) tuner;
- (void) play;
- (void) stop;

@end
