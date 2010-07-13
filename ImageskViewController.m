//
//  ImageskViewController.m
//  Imagesk
//
//  Created by vinhboy on 7/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageskViewController.h"


@implementation ImageskViewController

@synthesize imageView,choosePhotoBtn,takePhotoBtn,imageData,responseData;

-(IBAction) getPhoto:(id) sender {
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	if((UIButton *) sender == choosePhotoBtn) {
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	
	[self presentModalViewController:picker animated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
	imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	UIImage* image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    
	self.imageData = UIImageJPEGRepresentation(image, 0.85f);
	
	responseData = [NSMutableData data];
	
	NSLog(@"%@", @"HI");
	//[s release];	
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080/?upload_url=true"]];
	// NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080/?upload_url=true"]];
	[NSURLConnection connectionWithRequest:request delegate:self];
	
	// NSString *song = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	NSLog(@"%@", responseData);
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"nothing"]];
	[urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", @"0xKhTmLbOuNdArY"] forHTTPHeaderField:@"Content-Type"];
	
    NSMutableData *postData = [NSMutableData dataWithCapacity:[self.imageData length] + 512];
    [postData appendData: [[NSString stringWithFormat:@"--%@\r\n", @"0xKhTmLbOuNdArY"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData: [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"file.jpg\"; Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData: self.imageData];
    [postData appendData: [[NSString stringWithFormat:@"\r\n--%@--\r\n", @"0xKhTmLbOuNdArY"] dataUsingEncoding:NSUTF8StringEncoding]];
	
    [urlRequest setHTTPBody:postData];
	
	[NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
