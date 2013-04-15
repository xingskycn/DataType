//
//  AppDelegate.m
//  DataType
//
//  Created by tju tju on 13-3-30.
//  Copyright (c) 2013年 tju. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
@implementation AppDelegate

@synthesize window = _window;
@synthesize mainVC = _mianVC;


- (void)dealloc
{
    [_window release];
    [_mianVC release];
   
    [super dealloc];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.mainVC = [[[MainViewController alloc] initWithNibName:@"View" bundle:nil]autorelease];
    [self.window addSubview:[_mianVC view]];
    [self.window makeKeyAndVisible];
  
    return YES;
}



@end
