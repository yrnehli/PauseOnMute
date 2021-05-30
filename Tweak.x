#import "Tweak.h"

%hook SBVolumeControl
- (void)increaseVolume {
	%orig;

	if([self _effectiveVolume] > 0 && [[%c(SBMediaController) sharedInstance] isPaused]) {
		[[%c(SBMediaController) sharedInstance] playForEventSource: 0];
	}
}

- (void)decreaseVolume {
	%orig;

	if ([self _effectiveVolume] < 0.1 && ![[%c(SBMediaController) sharedInstance] isPaused]) {
		[[%c(SBMediaController) sharedInstance] pauseForEventSource: 0];
	}
}
%end