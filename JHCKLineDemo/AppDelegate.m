//
//  AppDelegate.m
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#import "AppDelegate.h"
#import "JHCViewController.h"
#import "TestViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UITabBar appearance] setTranslucent:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
        
    JHCViewController *vc0 = [[JHCViewController alloc] init];
    UINavigationController *nav0 = [[UINavigationController alloc] initWithRootViewController:vc0];
    vc0.title = @"第一页";
    TestViewController *vc1 = [[TestViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    vc1.title = @"第二页";
    
    UITabBarController *rootController = [[UITabBarController alloc] init];
    rootController.viewControllers = @[nav0, nav1];
    
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
