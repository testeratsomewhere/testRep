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

#define kPopupMessage				@"Popup Message"
#define kPopupMessageTakePicture	@"Popup Message Take Picture"
#define kPopupMessageSuspend		@"Popup Message Suspend"
#define kPopupMessageLocation		@"Popup Message Location"
#define kPopupMessageError          @"Popup Message Error"
#define kPopupYesMessage			@"Popup Yes Message"
#define kPopupOkMessage				@"Popup Ok Message"
#define kPopupYesNoSuspendMessage	@"Popup Yes No Suspend Message"
#import <UIKit/UIKit.h>

@interface Popup : UIViewController
{
	IBOutlet UIImageView*	Imgview_m_background;
	IBOutlet UIView* View_holder_background;
	IBOutlet UILabel* LblpopupMessage;
	IBOutlet UIButton* button1;
	IBOutlet UIButton* button2;
	NSString *StradditionalMessage;
	
	NSDictionary*			Dicm_message;
	CGRect					m_normalFrame;
	id						m_delegate;
	
	UIView *bgView;
	NSString *Strtype;
	NSString *nib_name;
}

@property (nonatomic, assign) NSDictionary* message;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) IBOutlet UILabel* LblpopupMessage;
@property (nonatomic, assign) UIView *bgView;
@property (nonatomic, assign) NSString *StradditionalMessage;
@property (nonatomic, assign) NSString* Strtype;
@property (nonatomic, assign) IBOutlet UIView* View_holder_background;
@property (nonatomic, assign) IBOutlet UIButton* button1;
@property (nonatomic, assign) IBOutlet UIButton* button2;


- (IBAction)dismissAndNotify:(id)sender;
- (IBAction)dismissAndStop:(id)sender;
+ (void)popUpWithMessage:(NSDictionary*)message delegate:(id)delegate withType:(NSString*)type;
- (IBAction)decide:(id)sender;
@end


@protocol PopupViewControllerDelegate

- (void)popupViewControllerDidClose:(NSString*)actionType withResponse:(BOOL)response;

@end


//usage
//#import "Constants.h"
/*
 NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
 [dictMsg setObject:@"Please Enter User Name." forKey:popupMessage];
 
 [Popup popUpWithMessage: dictMsg delegate:self withType:kType];

*/