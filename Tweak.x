#import "Tweak.h"

static NSString *plistPath = @"/var/mobile/Library/Preferences/xyz.henryli17.pauseonmute.prefs.plist";
static BOOL resumeOnUnmute;

%group Tweak
	%hook SBVolumeControl
	- (void)_effectiveVolumeChanged:(id)arg1 {
		float volumeBeforeChange = [self _effectiveVolume];
		%orig;
		float volumeAfterChange = [self _effectiveVolume];

		if (
			volumeBeforeChange > volumeAfterChange &&
			volumeAfterChange == 0 &&
			[[%c(SBMediaController) sharedInstance] isPlaying]
		) {
			[[%c(SBMediaController) sharedInstance] pauseForEventSource: 0];
		} else if (
			resumeOnUnmute &&
			volumeAfterChange > volumeBeforeChange &&
			volumeBeforeChange == 0 &&
			[[%c(SBMediaController) sharedInstance] isPaused]
		) {
			[[%c(SBMediaController) sharedInstance] playForEventSource: 0];
		}
	}
	%end
%end

%ctor {
	NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
	NSFileManager *fileManager = [NSFileManager defaultManager];

	if ([[plistDict objectForKey:@"enabled"] boolValue] || ![fileManager fileExistsAtPath:plistPath]) {
		%init(Tweak);
		resumeOnUnmute = [[plistDict objectForKey:@"resumeOnUnmute"] boolValue];
	}
}
