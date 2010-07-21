//
//  ImageskViewController.h
//  Imagesk
//
//  Created by vinhboy on 7/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageskViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	UIImageView * imageView;
	UIImageView * imageOverlay;
	UIBarButtonItem * choosePhotoBtn;
	UIBarButtonItem * takePhotoBtn;
	UILabel * imageLabel;
	UIActivityIndicatorView * activityIndicator;
	NSData * imageData;
	NSMutableData * responseData;
}

@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIImageView * imageOverlay;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * choosePhotoBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * takePhotoBtn;
@property (nonatomic, retain) IBOutlet UILabel * imageLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * activityIndicator;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSMutableData * responseData;

-(IBAction) getPhoto:(id) sender;

@end