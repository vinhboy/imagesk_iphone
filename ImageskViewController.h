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
	UIButton * choosePhotoBtn;
	UIButton * takePhotoBtn;
	NSData * imageData;
	NSMutableData * responseData;
}

@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIButton * choosePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * takePhotoBtn;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSMutableData * responseData;

-(IBAction) getPhoto:(id) sender;

@end
