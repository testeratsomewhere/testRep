//
//  CollectionAddViewController.m
//  displaycase
//
//  Created by Nikhil Patel on 16/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CollectionAddViewController.h"
#import "collection.h"
#import "SettingsManager.h"
#import "Configfile.h"
#import "Popup.h"

@implementation CollectionAddViewController


#pragma mark - Life cycle method

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	CGRect frame = CGRectMake(100, 10, 150, 40);
	UILabel *lblTitle = [[[UILabel alloc] initWithFrame:frame] autorelease];
	lblTitle.backgroundColor = [UIColor clearColor];
	[lblTitle setText:@"Add Collection"];
	//lblTitle.textColor =  [UIColor blackColor];
    lblTitle.textColor = [UIColor colorWithRed:67/255.0f green:46/255.0f blue:25/255.0f alpha:1.0]; 
	[lblTitle setFont:[UIFont fontWithName:@"Arial Black" size:20.0]];
	[lblTitle setFont:[UIFont boldSystemFontOfSize:20.0]];
	lblTitle.textAlignment = UITextAlignmentCenter;
	self.navigationItem.titleView = lblTitle;
}

-(void)viewWillAppear:(BOOL)animated
{
		
	CGRect btnFrame = CGRectMake(0, 0, 45, 30);
	UIButton *rightBarbutton = [[UIButton alloc] initWithFrame:btnFrame];
	[rightBarbutton setBackgroundImage:[UIImage imageNamed:@"nav_bar_edit_button.png"] forState:UIControlStateNormal];
	[rightBarbutton setBackgroundImage:[UIImage imageNamed:@"nab_bar_edit_button_tapped.png"] forState:UIControlStateSelected];
	[rightBarbutton setTitle:@"Save" forState:UIControlStateNormal];
	[rightBarbutton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
	[rightBarbutton setTitleColor:[UIColor colorWithRed:97/255.0f green:75/255.0f blue:48/255.0f alpha:1.0f] forState:UIControlStateNormal];
	[rightBarbutton setTitleColor:[UIColor colorWithRed:238/255.0f green:227/255.0f blue:198/255.0f alpha:1.0f] forState:UIControlStateSelected];
	[rightBarbutton addTarget:self action:@selector(createCollection) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightBarbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarbutton];
	self.navigationItem.rightBarButtonItem = rightBarbuttonItem;
	[rightBarbuttonItem release];
	
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
	
	lblCollectionName.textColor = [UIColor colorWithRed:200/255.0f green:221/255.0f blue:239/255.0f alpha:1.0];

}

#pragma mark - Other Method

-(void)createCollection {
	//NSLog(@"Saving collection %@", txtCollectionName.text);
    
	/*Collection *newCollection = [[Collection alloc]init];
	[newCollection addCollection:txtCollectionName.text];*/
    
    [txtCollectionName resignFirstResponder];
    
    if([txtCollectionName.text isEqualToString:@""])
    {
        NSString *str =[NSString stringWithFormat:@"Please enter Collection Name."];
        NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
        [dictMsg setObject:str forKey:kPopupMessage];
        [Popup popUpWithMessage: dictMsg delegate:self withType:nil];
    }
    else
    {
        [self sendRequests];
    }
        
    
}

- (void)sendRequests {  
    
    NSString *user_auth_token =[[SettingsManager gameSettings]getUserAuthentication]; 
    NSString *collectionName=txtCollectionName.text;
    NSString *Str = [NSString stringWithFormat:@"%@?auth_token=%@&name=%@",kAPIPostColletion,user_auth_token,collectionName];
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
            
            [self.navigationController popViewControllerAnimated:YES];
            
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

#pragma mark - Button Method


-(void)back
{
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - textfield method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark - Memory Method

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


@end
