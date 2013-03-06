//
//  SearchViewController.m
//  displaycase
//
//  Created by Nikhil Patel on 22/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "SettingsManager.h"
#import "Configfile.h"
//#import "SBJSON.h"
//#import "JSON.h"


@implementation SearchViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad 
{
    [super viewDidLoad];
	CGRect frame = CGRectMake(100, 10, 150, 40);
	UILabel *lblTitle = [[[UILabel alloc] initWithFrame:frame] autorelease];
	lblTitle.backgroundColor = [UIColor clearColor];
	[lblTitle setText:@"Search"];
	lblTitle.textColor =  [UIColor blackColor];
	[lblTitle setFont:[UIFont fontWithName:@"Arial Black" size:15.0]];
	[lblTitle setFont:[UIFont boldSystemFontOfSize:15.0]];
	lblTitle.textAlignment = UITextAlignmentCenter;
	self.navigationItem.titleView = lblTitle;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    DictResponse = [[NSMutableDictionary alloc]init];
    ArrayRecords = [[NSMutableArray alloc]init];
}


- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	searchTable.backgroundColor = [UIColor clearColor];
    //[self sendRequests];
}

#pragma mark - other method


- (void)sendRequests 
{  
    
    NSString *user_auth_token =[[SettingsManager gameSettings]getUserAuthentication]; 
    
    NSString *strSearch=searchBarItem.text;
    
    NSString *Str = [NSString stringWithFormat:@"%@?auth_token=%@&search=%@",kAPISearch,user_auth_token,strSearch];
    
    [[RKClient sharedClient] get:Str delegate:self];
//  [[RKClient sharedClient] post:Str params:nil delegate:self];

}  


- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{    
    
    if ([request isGET]) 
    { 
        if ([response isOK]) 
        {  
            DictResponse =(NSMutableDictionary*)[[response bodyAsString] JSONValue];
            ArrayRecords = [DictResponse valueForKey:@"items"];
            [ArrayRecords retain];
            [searchTable reloadData];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    if (![searchBarItem.text isEqualToString:@""]) 
    {
        [self sendRequests];
    }
    else
    {
        if ([ArrayRecords count]>0) 
        {
            [ArrayRecords removeAllObjects];
            [searchTable reloadData];
        }
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    // return 5;
    return [ArrayRecords count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    CustomCellSearch *cell = (CustomCellSearch*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CustomCellSearch alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
   
    
    NSLog(@"Title :- %@",cell.lblTitle.text);
    NSLog(@"Desc :- %@",cell.txtDesc.text);
    
    if ([[[ArrayRecords objectAtIndex:indexPath.row] valueForKey:@"item"] valueForKey:@"description"] != [NSNull null]) 
    {
        cell.txtDesc.text = [[[ArrayRecords objectAtIndex:indexPath.row] valueForKey:@"item"] valueForKey:@"description"];
    }
    
    cell.lblTitle.text = [[[ArrayRecords objectAtIndex:indexPath.row] valueForKey:@"item"] valueForKey:@"title"];
    cell.lblUserName.text = [[[[[ArrayRecords objectAtIndex:indexPath.row] valueForKey:@"item"] valueForKey:@"collection"] valueForKey:@"user"] valueForKey:@"username"];
    
    
    
    
    NSString *imageString=[[[ArrayRecords objectAtIndex:indexPath.row] valueForKey:@"item"] valueForKey:@"latest_photo_url"];
    
	if([imageString isEqualToString:@""])
    {
//		cell.imgThumb.image=[UIImage imageNamed:@"Estateloc.png"];
    }   
	else
	{
		AsyncImageView* oldImage = (AsyncImageView*)[cell.contentView viewWithTag:999];
		[oldImage removeFromSuperview];
		CGRect frame;
		frame.size.width=90; frame.size.height=75;
		frame.origin.x=0; frame.origin.y=0;
		
		AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
		asyncImage.backgroundColor=[UIColor clearColor];
		asyncImage.tag = 999;
		
		NSURL* url;
		url = [NSURL URLWithString:imageString];
		[asyncImage loadImageFromURL:url];
        
		[cell.imgThumb addSubview:asyncImage];
        
	}


    
    return cell;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

