#import "Tweak.h"

static NSString *plistPath = @"/var/mobile/Library/Preferences/xyz.henryli17.pauseonmute.prefs.plist";

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
	NSFileManager *fileManager = [NSFileManager defaultManager];

	if ([[plistDict objectForKey:@"enabled"] boolValue] || ![fileManager fileExistsAtPath:plistPath]) {
		%init(PauseOnMute);
		
		if ([[plistDict objectForKey:@"resumeOnUnmute"] boolValue]) {
			%init(ResumeOnUnmute);
		}
	};
}