//
//  ForgotpasswordView.h
//  displaycase
//
//  Created by Dipak Baraiya on 18/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configfile.h"
#import <RestKit/RestKit.h>
#import "SBJSON.h"

@interface ForgotpasswordView : UIViewController<RKRequestDelegate> {
    
    IBOutlet UITextField *txtEmail;
    IBOutlet UIButton *btnGo;
    
    BOOL *emailSuccess;
}
- (void)sendRequests;
-(void) emailVallidation;
-(IBAction)btnGoPress:(id)sender;

@end
