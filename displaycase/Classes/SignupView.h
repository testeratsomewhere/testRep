//
//  SignupView.h
//  displaycase
//
//  Created by Dipak Baraiya on 15/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@class MessageView;
@interface SignupView : UIViewController<RKRequestDelegate>  {
    
    MessageView *messagePopUp;
    
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtUsername;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtConfirmpassword;
    
    IBOutlet UIButton *btnCreateUser;
    IBOutlet UIButton *btnSignin;
    
    IBOutlet UIScrollView *scroll;
    
    BOOL *allValidationSuccess;
}
@property (nonatomic,retain) MessageView *messagePopUp;

-(IBAction)btnCreateUserPress:(id)sender;
-(IBAction)btnSigninPress:(id)sender;
- (void)sendRequests;
-(void) checkValidations;
@end
