//
//  ImageskAppDelegate.m
//  Imagesk
//
//  Created by vinhboy on 7/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ImageskAppDelegate.h"
#import "ImageskViewController.h"

@implementation ImageskAppDelegate

@synthesize window;
@synthesize imageskViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Override point for customization after application launch
	ImageskViewController *aViewController = [[ImageskViewController alloc]
										 initWithNibName:@"ImageskViewController" bundle:[NSBundle mainBundle]];
	[self setImageskViewController:aViewController];
	[aViewController release];
	
    UIView *controllersView = [imageskViewController view];
    [window addSubview:controllersView];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
	[imageskViewController release];
    [window release];
    [super dealloc];
}


@end

