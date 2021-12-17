//
//  AppDelegate.m
//  Example
//
//  Created by neutronstarer on 2021/10/28.
//

#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [self configureUI];
    return YES;
}


- (void)configureUI{
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithDefaultBackground];
        appearance.shadowImage                = [[UIImage alloc] init];
        appearance.shadowColor                = [UIColor clearColor];
        [[UINavigationBar appearance] setStandardAppearance:appearance];
        [[UINavigationBar appearance] setCompactAppearance:appearance];
        [[UINavigationBar appearance] setScrollEdgeAppearance:appearance];
        if (@available(iOS 15.0, *)) {
            [[UINavigationBar appearance] setCompactScrollEdgeAppearance:appearance];
        } else {
            // Fallback on earlier versions
        }
    } else {
        // Fallback on earlier versions
    }
}

@end
