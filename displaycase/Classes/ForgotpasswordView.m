//
//  ForgotpasswordView.m
//  displaycase
//
//  Created by Dipak Baraiya on 18/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ForgotpasswordView.h"
#import "Popup.h"

@implementation ForgotpasswordView

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
    
    
    CGRect btnFrame2 = CGRectMake(0, 0, 52, 30);
	UIButton *leftBarbutton = [[UIButton alloc] initWithFrame:btnFrame2];
	[leftBarbutton setBackgroundImage:[UIImage imageNamed:@"nav_bar_back_button.png"] forState:UIControlStateNormal];
	[leftBarbutton setBackgroundImage:[UIImage imageNamed:@"nab_bar_back_button_tapped.png"] forState:UIControlStateSelected];
	[leftBarbutton setTitle:@"Back" forState:UIControlStateNormal];
	[leftBarbutton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -10.0)];
	[leftBarbutton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
	[leftBarbutton setTitleColor:[UIColor colorWithRed:97/255.0f green:75/255.0f blue:48/255.0f alpha:1.0f] forState:UIControlStateNormal];
	[leftBarbutton setTitleColor:[UIColor colorWithRed:238/255.0f green:227/255.0f blue:198/255.0f alpha:1.0f] forState:UIControlStateSelected];
	[leftBarbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBarbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarbutton];
	self.navigationItem.leftBarButtonItem = leftBarbuttonItem;
	[leftBarbuttonItem release];


}

#pragma mark - Button Method

-(IBAction)btnGoPress:(id)sender
{
    [self emailVallidation];
	
	if (emailSuccess) {
        [self sendRequests];
	}
}
-(void)back
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - other Method

- (void)sendRequests {  
    
    NSString *Str = [NSString stringWithFormat:@"%@.json?email=%@",kAPIForgotPassword,txtEmail.text];
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
            
            NSString *responseString=[response bodyAsString];
            NSLog(@"%@",responseString);
            
            NSString *notFount = [NSString alloc];
            notFount=@"{'error':'email is not found'}";
            
            if ([responseString isEqual:notFount]) 
            {
                NSString *str =[NSString stringWithFormat:@"Email not found.."];
                NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
                [dictMsg setObject:str forKey:kPopupMessage];
                [Popup popUpWithMessage: dictMsg delegate:nil withType:nil];
            }
            else
            {
                NSString *str =[NSString stringWithFormat:@"Email is send to your email id. please check it."];
                NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
                [dictMsg setObject:str forKey:kPopupMessage];
                [Popup popUpWithMessage: dictMsg delegate:self withType:nil];
            }

            
            //NSLog(@"Retrieved XML: %@", [response bodyAsString]); 
            //NSLog(@"Got a JSON response back from our POST!");  
            
        }  
       
    } 
    else if ([request isDELETE]) 
    {  
        if ([response isNotFound]) 
        {  
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);  
        }  
        
    }  
} 

- (void)popupViewControllerDidClose:(NSString*)actionType withResponse:(BOOL)response
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) emailVallidation
{
	NSString *emailString = txtEmail.text; // storing the entered email in a string.
	// Regular expression to checl the email format.
	NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
	if (([emailTest evaluateWithObject:emailString] != YES) || [emailString isEqualToString:@""])
	{
		NSString *str =[NSString stringWithFormat:@"Please enter email address in you@example.com format."];
		NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
		[dictMsg setObject:str forKey:kPopupMessage];
		[Popup popUpWithMessage: dictMsg delegate:nil withType:nil];
	} 
	else {
		emailSuccess = (BOOL *) YES;
	}
}

#pragma mark - textfield method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
