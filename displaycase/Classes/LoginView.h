//
//  LoginView.h
//  displaycase
//
//  Created by Yaseen Mansuri on 22/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "displaycaseAppDelegate.h"
#import "CustomTabBar.h"
#import "SignupView.h"
#import "ForgotpasswordView.h"
#import <RestKit/RestKit.h>

@class CustomTabBar;
@class MessageView;
@interface LoginView : UIViewController <RKRequestDelegate>{
    
    MessageView *messagePopUp;
    
    displaycaseAppDelegate *appDelegate;
    CustomTabBar *appTabBar;
    BOOL hiddenTabBar;
  
    
    
    
    //text field
    
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    
    //Button
    IBOutlet UIButton *btnSignin;
    IBOutlet UIButton *btnForgotpassword;
    IBOutlet UIButton *btnCreateAcc;
    
    BOOL *allValidationDone;
    
    UIImageView *imgView;
    
    
}
@property (nonatomic,retain) MessageView *messagePopUp;
-(IBAction)btnSigninPress:(id)sender;
-(IBAction)btnForgotpasswordPress:(id)sender;
-(IBAction)btnCreateAccPress:(id)sender;
- (void)sendRequests;
-(void) checkValidation;
- (void) hidetabbarOriginal1;
@end
