//
//  AppDelegate.m
//  project#1
//
//  Created by Зульфат Мифтахутдинов on 08.11.13.
//  Copyright (c) 2013 Зульфат Мифтахутдинов. All rights reserved.
//

#import "AppDelegate.h"
#import "loginController.h"

@implementation AppDelegate
@synthesize userInfo,icons;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    icons = [[NSUserDefaults standardUserDefaults] objectForKey:@"icons"];
    if (!icons) {
        icons = [[NSMutableDictionary alloc] init];
    }
    if (!userInfo) {
        userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setValue:[NSNumber numberWithBool:NO] forKey:@"status"];
        @try {
          self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]
                        instantiateViewControllerWithIdentifier:@"loginView"];
        }
        
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if (userInfo)
        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"userInfo"];
    if (icons) {
        [[NSUserDefaults standardUserDefaults] setObject:icons forKey:@"icons"];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
