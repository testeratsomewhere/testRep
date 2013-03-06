//
//  SettingsViewController.m
//  displaycase
//
//  Created by Nikhil Patel on 28/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    //Custom Code For Settings Label
	CGRect frame = CGRectMake(100, 10, 150, 40);
	UILabel *lblTitle = [[[UILabel alloc] initWithFrame:frame] autorelease];
	lblTitle.backgroundColor = [UIColor clearColor];
	[lblTitle setText:@"Settings"];
	lblTitle.textColor =  [UIColor blackColor];
	[lblTitle setFont:[UIFont fontWithName:@"Arial Black" size:15.0]];
	[lblTitle setFont:[UIFont boldSystemFontOfSize:15.0]];
	lblTitle.textAlignment = UITextAlignmentCenter;
	self.navigationItem.titleView = lblTitle;
	
}

- (void)dealloc {
    [super dealloc];
}


@end
