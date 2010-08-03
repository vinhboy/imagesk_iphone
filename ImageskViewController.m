//
//  ImageskViewController.m
//  Imagesk
//
//  Created by vinhboy on 7/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageskViewController.h"

#if (TARGET_IPHONE_SIMULATOR)
	static NSString * upload_url = @"http://localhost:8080/?upload_url=true";
#else
	static NSString * upload_url = @"http://www.imagesk.com/?upload_url=true";
#endif

@interface ImageskViewController()

// Properties that don't need to be seen by the outside world.
@property (nonatomic, readonly) BOOL isSending;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSURLConnection * theConnection;
@property (nonatomic, retain) NSMutableData * responseData;

@end

@implementation ImageskViewController

@synthesize imageView = _imageView;
@synthesize choosePhotoBtn = _choosePhotoBtn;
@synthesize takePhotoBtn = _takePhotoBtn;
@synthesize imageData = _imageData;
@synthesize responseData = _responseData;
@synthesize activityIndicator = _activityIndicator;
@synthesize imageOverlay = _imageOverlay;
@synthesize theConnection = _theConnection;

-(IBAction) getPhoto:(id) sender {
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	if((UIBarButtonItem *) sender == self.choosePhotoBtn) {
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}

	[self presentModalViewController:picker animated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];

	self.activityIndicator.startAnimating;
	self.activityIndicator.hidden = NO;
	self.imageOverlay.hidden = NO;
	self.choosePhotoBtn.enabled = NO;
	self.takePhotoBtn.enabled = NO;
	
	self.imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	self.imageData = UIImageJPEGRepresentation(self.imageView.image, .50f);

	// Create the NSMutableData to hold the received data.
	self.responseData = [[NSMutableData data] retain];

	// Create the request.
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:upload_url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	
	// create the connection with the request
	// and start loading the data
	self.theConnection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
	NSLog(@"Retrieving upload url...");

	[picker release];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
	[picker release];
	
	NSLog(@"Upload cancelled...");
	self.activityIndicator.stopAnimating;
	self.imageOverlay.hidden = YES;
	self.choosePhotoBtn.enabled = YES;
	self.takePhotoBtn.enabled = YES;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [self.responseData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *responseString = [[[NSString alloc] initWithBytes:[self.responseData bytes] length:[self.responseData length] encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"Upload URL: %@",responseString);
	self.theConnection = nil;
	
	if (self.imageData) {
		NSString *boundary = @"---------------------------iMagesk-mUlTiPaRtFoRm";
		
		NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:responseString]];
		[urlRequest setHTTPMethod:@"POST"];
		[urlRequest setValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
		 
		NSMutableData *postData = [NSMutableData data];
		[postData appendData: [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"image_url\"\r\n\r\ntrue\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData: [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"file\"; filename=\"imageskApp.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData: self.imageData];
		[postData appendData: [[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		NSLog(@"Uploading image...");
		self.imageData = nil;
		
		[urlRequest setHTTPBody:postData];
		[NSURLConnection connectionWithRequest:urlRequest delegate:self];
	} else {
		NSLog(@"Uploading complete!");
		self.activityIndicator.stopAnimating;
		self.imageOverlay.hidden = YES;
		self.choosePhotoBtn.enabled = YES;
		self.takePhotoBtn.enabled = YES;		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: responseString]];
		
		[self.theConnection release];
		[self.responseData release];
	}
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
	
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Connection Failed!" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
	[alert show];
	
	// release the connection, and the data object
    self.theConnection = nil;
    [self.responseData release];	
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
		[self getPhoto:self.choosePhotoBtn];
    }
}
- (BOOL)isSending {
    return (self.theConnection != nil);
}
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

- (void)viewWillAppear:(BOOL)animated {
	// to fix the controller showing under the status bar
	self.view.frame = [[UIScreen mainScreen] applicationFrame];
}

- (void)dealloc {
	[self->_imageView release];
	[self->_imageOverlay release];
	[self->_choosePhotoBtn release];
	[self->_takePhotoBtn release];
	[self->_activityIndicator release];

    [super dealloc];
}


@end
