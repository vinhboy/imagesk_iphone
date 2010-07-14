//
//  ImageskViewController.m
//  Imagesk
//
//  Created by vinhboy on 7/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageskViewController.h"
#import "XPathQuery.h"

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

	// Create the request.
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080/"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:160.0];
	
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if (theConnection) {
		NSLog(@"Retrieving upload url...");
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable declared elsewhere.
		responseData = [[NSMutableData data] retain];
	} else {
		// Inform the user that the connection failed.
	}
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [responseData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *responseString = [[[NSString alloc] initWithBytes:[self.responseData bytes]
														 length:[self.responseData length]
													   encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"Upload URL: %@",responseString);
	
	NSString *xpathQueryString = @"//div[@id='bd']/form";
	NSArray *results = PerformHTMLXPathQuery(self.responseData, xpathQueryString);
	
	NSLog(@"Libxml Key: %@",[[results objectAtIndex:0] objectForKey:@"nodeAttributeArray"]);
	
	NSArray *result = [[results objectAtIndex:0] objectForKey:@"nodeAttributeArray"];
	
	for(NSDictionary * attr in result) {
		NSLog(@"AttributeName: %@",[attr objectForKey:@"attributeName"]);
		if([[attr objectForKey:@"attributeName"] isEqualToString:@"action"]) {
			NSLog(@"Attr: %@",[attr objectForKey:@"nodeContent"]);
		}
	}
	
//	if (responseString) {
//		NSString *boundary = @"---------------------------iMagesk-mUlTiPaRtFoRm";
//		
//		NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:responseString]];
//		[urlRequest setHTTPMethod:@"POST"];
//		[urlRequest setValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
//		 
//		NSMutableData *postData = [NSMutableData data];
//		[postData appendData: [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"file\"; filename=\"imageskApp.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//		[postData appendData: self.imageData];
//		[postData appendData: [[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//		 
//		[urlRequest setHTTPBody:postData];
//		[NSURLConnection connectionWithRequest:urlRequest delegate:self];
//	}
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    [responseData release];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
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
