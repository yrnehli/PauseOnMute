#include "POMRootListController.h"

@interface FBSSystemService : NSObject
+ (instancetype)sharedService;
- (void)sendActions:(NSSet *)arg1 withResult:(id)arg2 ;
@end

typedef enum {
	None = 0,
	SBSRelaunchOptionsRestartRenderServer = (1 << 0),
	SBSRelaunchOptionsSnapshot = (1 << 1),
	SBSRelaunchOptionsFadeToBlack = (1 << 2),
} SBSRelaunchOptions;

@interface SBSRelaunchAction : NSObject
+ (SBSRelaunchAction *)actionWithReason:(NSString *)reason options:(SBSRelaunchOptions)options targetURL:(NSURL *)url;
@end

@interface SBSRestartRenderServerAction : NSObject
+ (instancetype)restartActionWithTargetRelaunchURL:(NSURL *)targetURL;
@property(readonly, nonatomic) NSURL *targetURL;
@end

@implementation POMRootListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)respring {
	SBSRelaunchAction *restartAction = [NSClassFromString(@"SBSRelaunchAction") actionWithReason:@"RestartRenderServer" options:SBSRelaunchOptionsFadeToBlack targetURL:nil];
    NSSet *actions = [NSSet setWithObject:restartAction];
    FBSSystemService *frontBoardService = [NSClassFromString(@"FBSSystemService") sharedService];
    [frontBoardService sendActions:actions withResult:nil];
}
@end
