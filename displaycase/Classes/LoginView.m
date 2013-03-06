//
//  LoginView.m
//  displaycase
//
//  Created by Yaseen Mansuri on 22/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginView.h"
#import "Popup.h"
#import "SBJSON.h"
#import "JSON.h"
#import "CustomTabBar.h"
#import "CollectionsViewController.h"
#import "SettingsManager.h"
#import "MessageView.h"

@implementation LoginView
@synthesize messagePopUp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
   
    
//    appDelegate = (displaycaseAppDelegate *)[[UIApplication sharedApplication] delegate];
//	
//    appTabBar = (CustomTabBar *)appDelegate.tabBarController;
//	[appTabBar hideTabBar];
    
   // [self hidetabbarOriginal1];
    
    CGRect frame = CGRectMake(100, 10, 150, 40);
	UILabel *lblTitle = [[[UILabel alloc] initWithFrame:frame] autorelease];
	lblTitle.backgroundColor = [UIColor clearColor];
	[lblTitle setText:@"Display Case"];
	//lblTitle.textColor =  [UIColor blackColor];
    lblTitle.textColor = [UIColor colorWithRed:67/255.0f green:46/255.0f blue:25/255.0f alpha:1.0]; 
	[lblTitle setFont:[UIFont fontWithName:@"Arial Black" size:20.0]];
	[lblTitle setFont:[UIFont boldSystemFontOfSize:20.0]];
	lblTitle.textAlignment = UITextAlignmentCenter;
	self.navigationItem.titleView = lblTitle;
    // Do any additional setup after loading the view from its nib.
        
    txtEmail.text = @"admin@y.com";
    txtPassword.text = @"admin123";
    
//    imgView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 424, 320.0,56)];
//	[imgView setImage:[UIImage imageNamed:@"background.png"]];
//	[appTabBar.view addSubview:imgView];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    
    //Code for Display Loader on the screen...
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageView" owner:self options:nil];
	self.messagePopUp = (MessageView *)[nib objectAtIndex:0];
	[self.messagePopUp setup];
	[self.view addSubview:(UIView*)self.messagePopUp];
}

#pragma mark - Button Method

-(IBAction)btnSigninPress:(id)sender
{
    
    [self checkValidation];
    
    if(allValidationDone)
	{
        [self.messagePopUp show:@"Please Wait..."];
        //[self sendRequests];
        [self performSelector:@selector(sendRequests) withObject:nil afterDelay:0.001];
	}
}
-(IBAction)btnForgotpasswordPress:(id)sender
{
    ForgotpasswordView *objForgotpwd = [[ForgotpasswordView alloc]initWithNibName:@"ForgotpasswordView" bundle:nil];
    [self.navigationController pushViewController:objForgotpwd animated:YES];
    [objForgotpwd release];
    
}
-(IBAction)btnCreateAccPress:(id)sender
{
    SignupView *objSignup = [[SignupView alloc]initWithNibName:@"SignupView" bundle:nil];
    [self.navigationController pushViewController:objSignup animated:YES];
    [objSignup release];
}


#pragma mark - other Method

- (void)sendRequests {  
    
    
    NSString *Str = [NSString stringWithFormat:@"/accounts/sign_in.json?email=%@&password=%@",txtEmail.text,txtPassword.text];
    // params = [NSDictionary dictionaryWithObject:@"shakira@rate.me",@"shakira" forKey:@"email",@"password"];  
    
    [[RKClient sharedClient] post:Str params:nil delegate:self]; 
    
    
}  
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{    
    
    if ([request isGET]) 
    { 
        if ([response isOK]) 
        {  
            // Success! Let's take a look at the data  
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);  
        }  
        
    } 
    else if ([request isPOST]) 
    {  
        if ([response isJSON]) 
        {  
            NSLog(@"Retrieved XML: %@", [response bodyAsString]); 
            
            NSString *jsonString=[response bodyAsString];
            
            NSDictionary *results = [jsonString JSONValue];
            
            NSString *strmsg=[NSString stringWithFormat:@"%@",[[[results objectForKey:@"message"]objectForKey:@"user"] objectForKey:@"status"]];
           
            if([strmsg isEqualToString:@"fail"])
            {
                txtPassword.text=@"";
                
                NSString *str =[NSString stringWithFormat:@"Invalid email address and/or password. Please try again."];
                NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
                [dictMsg setObject:str forKey:kPopupMessage];
                [Popup popUpWithMessage: dictMsg delegate:self withType:nil];
            }
            else
            {
                NSDictionary *user = [[results objectForKey:@"message"]objectForKey:@"user"];
                
                NSString *user_token=[NSString stringWithFormat:@"%@",[user objectForKey:@"auth_token"]];
                
                [[SettingsManager gameSettings] saveAuthenticationToken:user_token];
                
               // [imgView removeFromSuperview];
               // [appTabBar showTabBar];
                
                CollectionsViewController *objCollection = [[CollectionsViewController alloc]initWithNibName:@"Collections" bundle:nil];
                [self.navigationController pushViewController:objCollection animated:YES];
                [objCollection release];
                
                [((displaycaseAppDelegate*)[[UIApplication sharedApplication]delegate]) TabbarMakeVisible];
//                displaycaseAppDelegate *appDelegate1 = (displaycaseAppDelegate *)[UIApplication sharedApplication].delegate;
//                [appDelegate1.navigationController.view removeFromSuperview];
            }
           
        }        
    } 
    else if ([request isDELETE]) 
    {  
        if ([response isNotFound]) 
        {  
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);  
        }  
        
    }  
    
    [self.messagePopUp hide];
}  


-(void) checkValidation
{
	allValidationDone = NO;
	BOOL successEmail = NO;
	BOOL successPasswd = NO;
	
	
	NSString *emailString = txtEmail.text; // storing the entered email in a string.
	// Regular expression to checl the email format.
	NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    
	if (([emailTest evaluateWithObject:emailString] != YES) || ([emailString isEqualToString:@""])) {
        
       
		UIImage *message_back=[UIImage imageNamed:@"background_message.png"];
		message_back = [message_back stretchableImageWithLeftCapWidth:16 topCapHeight:16];
        
		NSString *str =[NSString stringWithFormat:@"Please enter email address in you@example.com format."];
        txtPassword.text = @"";
		NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
		[dictMsg setObject:str forKey:kPopupMessage];
		[Popup popUpWithMessage: dictMsg delegate:self withType:nil];
	}
	else {
		successEmail=YES;
	}
    
	
	if (successEmail){ 
		if([txtPassword.text isEqualToString:@""]) {
			
			NSString *str =[NSString stringWithFormat:@"Please enter Password."];
            txtPassword.text = @"";
			NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
			[dictMsg setObject:str forKey:kPopupMessage];
          //  forPopup=(BOOL *) YES;
			[Popup popUpWithMessage: dictMsg delegate:self withType:nil];
		}
		else {
			successPasswd = YES;
			allValidationDone=(BOOL *) YES;
		}
	}
}

- (void) hidetabbarOriginal1 {
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.0];
	
    for(UIView *view in appDelegate.tabBarController.view.subviews)
    {
        NSLog(@"%@", view);
		
        if([view isKindOfClass:[UITabBar class]])
        {
			
            if (hiddenTabBar) {
                [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
            }
        } else {
            if (hiddenTabBar) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
            }
			
        }
    }
	
    [UIView commitAnimations];
	
    hiddenTabBar = !hiddenTabBar;
}



#pragma mark - textfield method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==txtEmail) {
        [txtEmail resignFirstResponder];
        [txtPassword becomeFirstResponder];
    }
    if (textField==txtPassword) {
        [txtPassword resignFirstResponder];
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - memory method

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)dealloc
{
    [super dealloc];
}




@end
