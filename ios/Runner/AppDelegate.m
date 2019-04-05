#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
