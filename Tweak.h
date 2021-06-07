#import <Foundation/Foundation.h>

@interface SBMediaController
- (BOOL)playForEventSource:(long long)arg1;
- (BOOL)pauseForEventSource: (long long)arg1;
+ (id)sharedInstance;
- (BOOL)isPaused;
- (BOOL)isPlaying;
@end

@interface SBVolumeControl
- (float)_effectiveVolume;
@end