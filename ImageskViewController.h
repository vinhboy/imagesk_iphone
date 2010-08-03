//
//  ImageskViewController.h
//  Imagesk
//
//  Created by vinhboy on 7/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageskViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	UIImageView * _imageView;
	UIImageView * _imageOverlay;
	UIBarButtonItem * _choosePhotoBtn;
	UIBarButtonItem * _takePhotoBtn;
	UIActivityIndicatorView * _activityIndicator;
	
	NSData * _imageData;
	NSURLConnection * _theConnection;
	NSMutableData * _responseData;
}

@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIImageView * imageOverlay;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * choosePhotoBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * takePhotoBtn;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * activityIndicator;

-(IBAction) getPhoto:(id) sender;

@end