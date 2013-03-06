//
//  PhotoViewController.m
//  displaycase
//
//  Created by Nikhil Patel on 22/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "NewItemViewController.h"

@implementation PhotoViewController
@synthesize objNewItemViewController;
@synthesize imageView;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
	UIActionSheet *photoSourceActionSheet;
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
	{ 
		NSLog(@"No camera!");
		photoSourceActionSheet= [[UIActionSheet alloc]
								 initWithTitle:nil
								 delegate:self
								 cancelButtonTitle:@"Cancel"
								 destructiveButtonTitle:nil
								 otherButtonTitles: @"Photo Library", nil];
	}
	else
	{

		photoSourceActionSheet= [[UIActionSheet alloc]
											 initWithTitle:nil
											 delegate:self
											 cancelButtonTitle:@"Cancel"
											 destructiveButtonTitle:nil
											 otherButtonTitles: @"Camera",@"Photo Library", nil];
	}
	photoSourceActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[photoSourceActionSheet showInView:self.view];
}



-(void)getCameraPicture
{
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	//picker.allowsImageEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController: picker animated:YES];
	[picker release];
	 
}

-(void)selectExitingPicture
{
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
		UIImagePickerController *picker= [[UIImagePickerController alloc]init];
		picker.delegate = self;
		picker.allowsEditing = YES;
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}
}


#pragma mark UIActionSheetDelegate Methods


- (void)actionSheet:(UIActionSheet *)anActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [anActionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
	if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		buttonIndex+=1;
	}
    if (buttonIndex == [anActionSheet cancelButtonIndex]) {
		
    }
	
    if (buttonIndex == 0) {
		NSLog(@"Camera selected.............");
        [self getCameraPicture];

    } else if (buttonIndex == 1) {
        [self selectExitingPicture];
		NSLog(@"Photo Library selected...........");
		
	}
	else {
		[self.navigationController popViewControllerAnimated:NO];
	}

}


- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    // Do nothing.  Overriding default of simulating clicking cancel, when user hits home button.
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker
	  didFinishPickingImage : (UIImage *)image
				 editingInfo:(NSDictionary *)editingInfo
{
	imageView.image = image;
	objNewItemViewController.imageSelected=[imageView retain];
    objNewItemViewController.noOfPhoto++;
	NSLog(@"Number of Photos: %d",objNewItemViewController.noOfPhoto);
	[picker dismissModalViewControllerAnimated:YES];
	[self.navigationController popViewControllerAnimated:YES];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
	[picker dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(UIImage*)createThumbNailImage:(UIImage*)myThumbNail:(float)width:(float)height
{
	
	// begin an image context that will essentially "hold" our new image
	
	UIGraphicsBeginImageContext(CGSizeMake(width,height));
	
	// now redraw our image in a smaller rectangle.
	[myThumbNail drawInRect:CGRectMake(0.0, 0.0, width, height)];
	
	
	// make a "copy" of the image from the current context
	UIImage *newImage    = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return [newImage autorelease];
	
}


@end
