#import "Tweak.h"

static NSString *plistPath = @"/var/mobile/Library/Preferences/xyz.henryli17.pauseonmutepreferences.plist";

%group PauseOnMute
	%hook SBVolumeControl
	- (void)decreaseVolume {
		%orig;

		if ([self _effectiveVolume] < 0.1 && ![[%c(SBMediaController) sharedInstance] isPaused]) {
			[[%c(SBMediaController) sharedInstance] pauseForEventSource: 0];
		}
	}
	%end
%end

%group ResumeOnUnmute
	%hook SBVolumeControl
	- (void)increaseVolume {
		%orig;

		if([self _effectiveVolume] < 0.1 && [[%c(SBMediaController) sharedInstance] isPaused]) {
			[[%c(SBMediaController) sharedInstance] playForEventSource: 0];
		}
	}
	%end
%end

%ctor {
	NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];

	if ([[plistDict objectForKey:@"enabled"] boolValue]) {
		%init(PauseOnMute);
		
		if ([[plistDict objectForKey:@"resumeOnUnmute"] boolValue]) {
			%init(ResumeOnUnmute);
		}
	};
}