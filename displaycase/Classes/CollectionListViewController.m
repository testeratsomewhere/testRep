//
//  CollectionListViewController.m
//  displaycase
//
//  Created by Nikhil Patel on 11/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CollectionListViewController.h"
#import "displaycaseAppDelegate.h"
#import "SBJSON.h"
#import "JSON.h"
#import "SettingsManager.h"

@implementation CollectionListViewController
@synthesize objNewItemViewController;


#pragma mark - Life cycle Method

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	displaycaseAppDelegate *app = (displaycaseAppDelegate *)[[UIApplication sharedApplication] delegate];
	collections = app.collections_Array;
}

-(void)viewWillAppear:(BOOL)animated
{
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
	
	CGRect btnFrame = CGRectMake(0, 0, 29, 30);
	UIButton *rightBarbutton = [[UIButton alloc] initWithFrame:btnFrame];
	[rightBarbutton setBackgroundImage:[UIImage imageNamed:@"nav_bar_add_button.png"] forState:UIControlStateNormal];
	[rightBarbutton setBackgroundImage:[UIImage imageNamed:@"nab_bar_add_button_tapped.png"] forState:UIControlStateSelected];
	[rightBarbutton addTarget:self action:@selector(addNewCollection) forControlEvents:UIControlEventTouchUpInside];
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
	
	tableView.backgroundColor = [UIColor clearColor];
    
    [self sendRequests];
	
}

#pragma mark - Button Method

-(void)back
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)addNewCollection
{
    
    
}


#pragma mark - other method

- (void)sendRequests {  
    
    NSString *user_auth_token =[[SettingsManager gameSettings]getUserAuthentication]; 
    NSString *Str = [NSString stringWithFormat:@"%@?auth_token=%@",kAPIGetCollection,user_auth_token];
    [[RKClient sharedClient] get:Str delegate:self];
    
}  
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{    
    
    if ([request isGET]) 
    { 
        if ([response isOK]) 
        {  
            NSString *jsonString=[response bodyAsString];
            NSDictionary *results = [jsonString JSONValue];
            int total_res=[[results valueForKey:@"total_results"]intValue];
            if(total_res>0)
            {
                NSMutableArray *collectionArr=[results objectForKey:@"collections"];
                collections=[[NSMutableArray alloc]initWithArray:collectionArr];
                [tableView reloadData];
            }
        }  
        
    } 
    else if ([request isPOST]) 
    {  
        if ([response isJSON]) 
        {  
            NSLog(@"Retrieved XML: %@", [response bodyAsString]); 
            
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



#pragma mark -
#pragma mark Table View Methods
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSLog(@"IN TABLE SECTION");
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"IN TABLE ITEM COUNT=%d",collections.count);
    return [collections count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	NSLog(@"IN TABLE ADDING A CELL");
	
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
        if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.textLabel.text= [NSString stringWithFormat:@"%@",[[[collections objectAtIndex:indexPath.row]valueForKey:@"collection"]valueForKey:@"name"]];
	cell.textLabel.textColor = [UIColor colorWithRed:200/255.0f green:221/255.0f blue:239/255.0f alpha:1.0];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    
    return cell;
}



#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString *collectionSelected = [[[collections objectAtIndex:indexPath.row]valueForKey:@"collection"]valueForKey:@"name"]; 
	NSLog(@"%@",collectionSelected);
	objNewItemViewController.selectedCollection=collectionSelected;
	//objNewItemViewController.intCollections=[[collections objectAtIndex:indexPath.row] primaryKey]; 
	[self.navigationController popViewControllerAnimated:YES];
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}
@end
