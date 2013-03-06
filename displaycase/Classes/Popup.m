//
//  Popup.h
//  SmartDate
//
//  Created by Zsolt B on 1/28/11.
//
//   Copyright 2010, 2011 VisionSync Inc.   All Rights Reserved
//
//   Revision History:
//       2011-02-24:  Initial v1.0 Submit to apple
//       2011-02-26:  Cleanup by Ash
//
//   Purpose:
// Define Popup Class.
//This class is used for Popup Message when any error or any message will be display popup object will be called


#import "Popup.h"
#import "UIView-AlertAnimations.h"
#import "displaycaseAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
@implementation Popup

@synthesize message = Dicm_message;
@synthesize delegate = m_delegate;
@synthesize LblpopupMessage,StradditionalMessage;
@synthesize bgView;
@synthesize Strtype;
@synthesize View_holder_background;
@synthesize button1, button2;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		nib_name = @"Popup-ipad";
	}
	else {
		nib_name = @"Popup";
	}
    if ( self == [super initWithNibName: nib_name bundle: nibBundleOrNil] )
	{
		self.wantsFullScreenLayout = YES;
    }
    return self;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		return NO;
}

#pragma mark - Animation
- (void)startBorderedViewAnimation2
{
	[UIView beginAnimations: @"Border View Animation 2" context: NULL];
	[UIView setAnimationDuration: 0.1];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	Imgview_m_background.frame = m_normalFrame;
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context
{
	if ( [animationID isEqualToString: @"Border View Animation 1"] )
		[self startBorderedViewAnimation2];
}

- (void)animateFadeOut
{
	[UIView beginAnimations: @"fade out" context: NULL];
	[UIView setAnimationDuration: 0.5];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: @selector(animateFadeOutEnded)];
	self.view.alpha = 0.0;
	[UIView commitAnimations];
	
}

- (void) animateFadeOutEnded {
	[self.view removeFromSuperview];
	[self release];
}

- (void)close:(id)sender
{ 
	BOOL answer;
	answer = NO;
	if ([sender class] == [UIButton class]) {
		DebugLog(@"sender was uibutton");
		if (((UIButton*)sender).tag == 0) {//X mark on the popup
			answer = NO;
		} else if (((UIButton*)sender).tag == 1) {//the first on the bottom
			answer = YES;
		} else if (((UIButton*)sender).tag == 2) {//the second button on the bottom - not yet used
			answer = YES;
		} 		
	}
	
	if ( [m_delegate respondsToSelector: @selector(popupViewControllerDidClose:withResponse:)] ){
		[(id<PopupViewControllerDelegate>) m_delegate popupViewControllerDidClose: self.Strtype withResponse:answer];
	} else {
	}
	[self animateFadeOut];
}


#pragma mark -

- (IBAction)decide:(id)sender
{
	
	if (self.delegate == nil) {
		[self dismissAndStop:sender];
	} else {
		[self dismissAndNotify:sender];
	}
	 
	
}

- (IBAction)dismissAndStop:(id)sender
{
	[self animateFadeOut];
	
}

- (IBAction)dismissAndNotify:(id)sender
{
	[self close:(id)sender];
	
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	//[self.button1 setCenter:CGPointMake(self.view.center.x, self.button1.frame.origin.y + self.button1.frame.size.height / 2)];
	self.button2.hidden = YES;
	
	if ([self.Strtype isEqualToString:kPopupMessageTakePicture]) {
		if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
			} else {//no camera is available, display the 'Choose Existing' button
			}


	} else if ([self.Strtype isEqualToString:kPopupMessageLocation] || [self.Strtype isEqualToString:kPopupMessageSuspend]) {
		[self.button1 setImage:[UIImage imageNamed:@"opt_search_profile_with_photo_off.png"] forState: UIControlStateNormal];
		[self.button1 setImage:[UIImage imageNamed:@"opt_search_profile_with_photo_on.png"] forState: UIControlStateHighlighted];
	}
	else if ([self.Strtype isEqualToString:kPopupYesMessage]) {
		[self.button1 setImage:[UIImage imageNamed:@"btn_yes.png"] forState: UIControlStateNormal];
		[self.button1 setFrame:CGRectMake(104, 315, 111, 44)];
	}
	else if ([self.Strtype isEqualToString:kPopupOkMessage]) {
		[self.button1 setImage:[UIImage imageNamed:@"btn_ok_popup.png"] forState: UIControlStateNormal];
	}
	else if ([self.Strtype isEqualToString:kPopupYesNoSuspendMessage]) {
		[self.button1 setImage:[UIImage imageNamed:@"btn_popup_yes.png"] forState:UIControlStateNormal];
		[self.button2 setImage:[UIImage imageNamed:@"btn_popup_no.png"] forState:UIControlStateNormal];
		[self.button1 setFrame:CGRectMake(69, 323, 93, 31)];
		[self.button2 setFrame:CGRectMake(161, 323, 93, 31)];
		self.button2.hidden = NO;
	}
	
	self.button1.contentMode = UIViewContentModeCenter;
	m_normalFrame = Imgview_m_background.frame;	

	CGRect frame = self.view.frame;
	////////////////////////////// BG /////////////////////////
	self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height + 20.0)];
	self.bgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
	[self.view addSubview:self.bgView];
	
	[self.view addSubview:View_holder_background];
	
	self.LblpopupMessage.text = [Dicm_message objectForKey:kPopupMessage];

		
	// "Pop in X" animation for alert
	[View_holder_background doPopInAnimationX];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	DebugLog(@"Popup dealloc");
	self.message = nil;
	self.delegate = nil;
	
	[super dealloc];
	
	}

#pragma mark -

+ (void)popUpWithMessage:(NSDictionary*)message delegate:(id)delegate withType:(NSString*) type
{
	DebugLog(@"Message=%@",message);
	DebugLog(@"Delegate=%@",delegate);
	DebugLog(@"Popup type=%@",type);
	
	displaycaseAppDelegate* appDelegate = (displaycaseAppDelegate*)[UIApplication sharedApplication].delegate;
	UIWindow* win = appDelegate.window;

	// Display the view.
	Popup* viewCtrl = nil;
	if (YES) {
			viewCtrl = [[Popup alloc] initWithNibName: @"Popup" bundle: nil];		
	} 
	viewCtrl.Strtype = type;
	viewCtrl.message = message;
	viewCtrl.delegate = delegate;
	[win addSubview: viewCtrl.view];
}

@end
