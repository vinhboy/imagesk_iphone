//
//  ImageskAppDelegate.h
//  Imagesk
//
//  Created by vinhboy on 7/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageskViewController;

@interface ImageskAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	ImageskViewController *imageskViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) ImageskViewController *imageskViewController;

@end

