//
//  SignupView.m
//  displaycase
//
//  Created by Dipak Baraiya on 15/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SignupView.h"
#import "Configfile.h"
#import "Popup.h"
#import "SBJSON.h"
#import "JSON.h"
#import "MessageView.h"

@implementation SignupView
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
    // Do any additional setup after loading the view from its nib.
    
    [scroll setContentSize:CGSizeMake(0, 200)];
    self.navigationItem.hidesBackButton=YES;
    
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
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnCreateUserPress:(id)sender
{
    [txtEmail resignFirstResponder];
    [txtUsername resignFirstResponder];
	[txtPassword resignFirstResponder];
    [txtConfirmpassword resignFirstResponder];
    [self checkValidations];
    
	if (allValidationSuccess) 
	{
        [self.messagePopUp show:@"Please wait..."];
		//[self sendRequests];
        [self performSelector:@selector(sendRequests) withObject:nil afterDelay:0.01];
	}
}


#pragma mark - other Method

- (void)sendRequests {  
        
    NSString *Str = [NSString stringWithFormat:@"%@?email=%@&username=%@&password=%@&password_confirmation=%@",kAPISignUp,txtEmail.text,txtUsername.text,txtPassword.text,txtConfirmpassword.text];

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
            
            NSString *email=[NSString stringWithFormat:@"%@",[[results valueForKey:@"user"]valueForKey:@"email"]];
            NSString *username=[NSString stringWithFormat:@"%@",[[results valueForKey:@"user"]valueForKey:@"username"]];
            if(![email isEqualToString:@"<null>"] && ![username isEqualToString:@"<null>"])
            {
                if([email isEqualToString:@"has already been taken"] && [username isEqualToString:@"has already been taken"])
                {
                    NSString *str =[NSString stringWithFormat:@"Email and Username %@",email];
                    NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
                    [dictMsg setObject:str forKey:kPopupMessage];
                    [Popup popUpWithMessage: dictMsg delegate:self withType:nil];
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }
            else if(![email isEqualToString:@"<null>"])
            {
                NSString *str =[NSString stringWithFormat:@"Email %@",email];
                NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
                [dictMsg setObject:str forKey:kPopupMessage];
                [Popup popUpWithMessage: dictMsg delegate:self withType:nil];
            }
            else if(![username isEqualToString:@"<null>"])
            {
                NSString *str =[NSString stringWithFormat:@"Username %@",username];
                NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
                [dictMsg setObject:str forKey:kPopupMessage];
                [Popup popUpWithMessage: dictMsg delegate:self withType:nil];
            }
          
            
           // NSLog(@"%@",results);
                       
           // NSLog(@"Got a JSON response back from our POST!");  
            
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


-(void) checkValidations
{
	
	allValidationSuccess = NO;
	BOOL nameSuccess = NO;
    BOOL nameLength=NO;
	BOOL emailSuccess = NO;
	BOOL passwordSuccess = NO;

	
	if([txtEmail.text isEqualToString:@""])
    {
        NSString *str =[NSString stringWithFormat:@"Please enter your email."];
		NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
		[dictMsg setObject:str forKey:kPopupMessage];
		[Popup popUpWithMessage: dictMsg delegate:self withType:nil];
    }
    else
    {
        NSString *emailString = txtEmail.text; 
		NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
		NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
		if (([emailTest evaluateWithObject:emailString] != YES) || [emailString isEqualToString:@""])
		{
			
			NSString *str =[NSString stringWithFormat:@"Please enter email address in you@example.com format."];
			NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
			[dictMsg setObject:str forKey:kPopupMessage];
			[Popup popUpWithMessage: dictMsg delegate:self withType:nil];
           
		} 
		else {
			emailSuccess = YES;
		}

    }
    if(emailSuccess)
    {
        if ([txtUsername.text isEqualToString:@""]) {
            
            NSString *str =[NSString stringWithFormat:@"Please enter your name."];
            NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
            [dictMsg setObject:str forKey:kPopupMessage];
            [Popup popUpWithMessage: dictMsg delegate:self withType:nil];
            
        }
        else {
            nameSuccess = YES;
        }

        
    }
	    
    if ((emailSuccess) && (nameSuccess)) {
        if (txtUsername.text.length >= 20) {
            NSString *str =[NSString stringWithFormat:@"You have enter Long Name Please Enter less than 20 Character."];
            NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
            [dictMsg setObject:str forKey:kPopupMessage];
            [Popup popUpWithMessage: dictMsg delegate:self withType:nil];
           
        }
        else
            nameLength=YES;
    }
    
	if ((nameSuccess) && (nameLength) && (emailSuccess))
	{
		if ([txtPassword.text isEqualToString:@""]) 
        {
			NSString *str =[NSString stringWithFormat:@"Please enter password."];
			NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
			[dictMsg setObject:str forKey:kPopupMessage];
			[Popup popUpWithMessage: dictMsg delegate:self withType:nil];
           
		}
		else if(txtPassword.text.length < 6 )
        {
            NSString *str =[NSString stringWithFormat:@"Password too short. It should be minimum 6 characters long."];
            NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
            [dictMsg setObject:str forKey:kPopupMessage];
            [Popup popUpWithMessage: dictMsg delegate:self withType:nil];
           
        }
        else {
            passwordSuccess = YES;
			
        }
    }
    
    if((emailSuccess) && (nameSuccess) && (nameLength) && (passwordSuccess))
    {
        if ([txtConfirmpassword.text isEqualToString:@""]) 
        {
			NSString *str =[NSString stringWithFormat:@"Please enter Conf. password."];
			NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
			[dictMsg setObject:str forKey:kPopupMessage];
			[Popup popUpWithMessage: dictMsg delegate:self withType:nil];
            
		}
		else if(![txtPassword.text isEqualToString:txtConfirmpassword.text])
        {
            NSString *str =[NSString stringWithFormat:@"Password and confirm password must be same."];
            NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
            [dictMsg setObject:str forKey:kPopupMessage];
            [Popup popUpWithMessage: dictMsg delegate:self withType:nil];
            
        }
        else {
            passwordSuccess = YES;
            allValidationSuccess = (BOOL *)YES;
			
        }
    }
    
}

#pragma mark - textfield method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField==txtPassword)
    {
        [scroll setContentOffset:CGPointMake(0,textField.center.y-25) animated:YES];	
    }
    if(textField==txtConfirmpassword)
    {
        [scroll setContentOffset:CGPointMake(0,textField.center.y-65) animated:YES];	
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==txtEmail)
    {
        [txtUsername becomeFirstResponder];
    }
    if(textField == txtUsername)
    {
        [txtPassword becomeFirstResponder];
    }
    if(textField == txtPassword)
    {
        [txtConfirmpassword becomeFirstResponder];
    }
    [scroll setContentOffset:CGPointMake(0,0) animated:YES];
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - Memory management Method

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


@end
