//
//  CollectionsViewController.m
//  displaycase
//
//  Created by Nikhil Patel on 17/01/11.
//  Copyright 2011 Complitech Solutions Pvt. Ltd. All rights reserved.
//

#import "CollectionsViewController.h"
#import "Item.h"
#import "CollectionViewController.h"
#import "displaycaseAppDelegate.h"
#import "CollectionAddViewController.h"
#import "CustomTabBar.h"
#import "SettingsManager.h"
#import "SBJSON.h"
#import "JSON.h"
#import "MessageView.h"

#import "AppRecord.h"





//static sqlite3_stmt *getStmt = nil;


@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect 
{
    UIImage *image = [UIImage imageNamed: @"nav_bar_bg.png"];
	[image drawInRect:CGRectMake(0, 0, 320, 44)];
}
@end

@implementation CollectionsViewController
@synthesize messagePopUp;
@synthesize imageDownloadsInProgress, entries;


#pragma mark - Life cycle method

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	entries = [[NSMutableArray alloc] init];
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
	
	recivingArray = [[NSMutableArray alloc] init];
	imgArray = [[NSMutableArray alloc] init];
    appDelegate = (displaycaseAppDelegate  *) [UIApplication sharedApplication].delegate;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    //Code for Display Loader on the screen...
    appDelegate.collectionFlag = appDelegate.collectionFlag + 1;
    NSLog(@"flag count :- %d", appDelegate.collectionFlag);
    if(appDelegate.collectionFlag == 2)
    {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageView" owner:self options:nil];
	self.messagePopUp = (MessageView *)[nib objectAtIndex:0];
	[self.messagePopUp setup];
	[self.view addSubview:(UIView*)self.messagePopUp];
    
	CGRect btnFrame = CGRectMake(0, 0, 29, 30);
	UIButton *rightBarbutton = [[UIButton alloc] initWithFrame:btnFrame];
	[rightBarbutton setBackgroundImage:[UIImage imageNamed:@"nav_bar_add_button.png"] forState:UIControlStateNormal];
	[rightBarbutton setBackgroundImage:[UIImage imageNamed:@"nab_bar_add_button_tapped.png"] forState:UIControlStateSelected];
	[rightBarbutton addTarget:self action:@selector(addNewCollection) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightBarbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarbutton];
	self.navigationItem.rightBarButtonItem = rightBarbuttonItem;
	[rightBarbuttonItem release];
	
	[self populateCollections];

	tblCollections.backgroundColor = [UIColor clearColor];
    }
    //[tblCollections reloadData];
}

#pragma mark - Other Method


// This populates the collections table view with user's collections
- (void)populateCollections {
	
 	/*displaycaseAppDelegate *app = (displaycaseAppDelegate *)[[UIApplication sharedApplication] delegate];
     [app initializeCollections];
     collections = app.collections_Array;*/
    
    [self.messagePopUp show:@"Please Wait..."];
    
    [self performSelector:@selector(sendRequests) withObject:nil afterDelay:0.01];
   
}


- (void)sendRequests 
{  
    
    NSString *user_auth_token =[[SettingsManager gameSettings]getUserAuthentication]; 
    NSString *Str = [NSString stringWithFormat:@"%@?auth_token=%@",kAPIGetCollection,user_auth_token];
   [[RKClient sharedClient] get:Str delegate:self];
} 


- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{    
    [self.messagePopUp hide];
    if ([request isGET]) 
    { 
        NSLog(@"Retrieved XML: %@", [response bodyAsString]); 
        if ([response isOK]) 
        {  
            NSString *jsonString=[response bodyAsString];
            NSDictionary *results = [jsonString JSONValue];
            int total_res=[[results valueForKey:@"total_results"]intValue];
            if(total_res>0)
            {
                NSMutableArray *collectionArr=[results objectForKey:@"collections"];
                collections=[[NSMutableArray alloc]initWithArray:collectionArr];
                //[tblCollections reloadData];
                
                [self fillTheIconArray];
                [tblCollections reloadData];
            }
            else
            {
                
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

#pragma mark - Button Method

-(void)addNewCollection
{
	CollectionAddViewController *collectionAddViewController = [[CollectionAddViewController alloc] init];
	[self.navigationController pushViewController:collectionAddViewController animated:YES];
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
	NSLog(@"IN TABLE ITEM COUNT");
    return [collections count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString *CellIdentifier = @"Cell";
    
     NSString *CellIdentifier =[NSString stringWithFormat:@"%d",indexPath.row];
    

	NSLog(@"IN TABLE ADDING A CELL");

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
//    if (cell!=nil) {
//        cell=nil;
//    }
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			   UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(120, 30, 250, 40)];
			   lbl.text= [NSString stringWithFormat:@"%@ (%@)",[[[collections objectAtIndex:indexPath.row]valueForKey:@"collection"]valueForKey:@"name"],[[[collections objectAtIndex:indexPath.row] valueForKey:@"collection"]valueForKey:@"item_count"]];
               lbl.textColor = [UIColor colorWithRed:200/255.0f green:221/255.0f blue:239/255.0f alpha:1.0]; 
		       [lbl setFont: [UIFont fontWithName:@"Trebuchet MS" size:14.0]];
			   [lbl setFont:[UIFont boldSystemFontOfSize:14.0]];
			   [lbl setBackgroundColor:[UIColor clearColor]];
			 lbl.adjustsFontSizeToFitWidth = YES;
			   [cell addSubview:lbl];
			   [lbl release];
		
				
		cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg.png"]] autorelease];
		
		UIImageView *selectedBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320,100)];
		[selectedBackground setImage:[UIImage imageNamed:@"cell_bg_tapped.png"]];
		[cell setSelectedBackgroundView:selectedBackground];
		
		UIImageView *imgview=[[UIImageView alloc]initWithFrame:CGRectMake(15, 4, 92,92)];
		[imgview setImage: [UIImage imageNamed:@"display_list_photo_mask.png"]];
		[cell addSubview:imgview];
		
       // UIImageView *imgview1=[[UIImageView alloc]initWithFrame:CGRectMake(14, 13, 65,65)];
        
      // NSString *urlStr=[[[collections objectAtIndex:indexPath.row]valueForKey:@"collection"]valueForKey:@"latest_item_latest_photo_url"];
        
//        if([urlStr isEqualToString:@""])
//            imgview1.image=[UIImage imageNamed:@"thumb_1.png"];
//        else
//        {
//            AsyncImageView* oldImage = (AsyncImageView*)[cell.contentView viewWithTag:999];
//            [oldImage removeFromSuperview];
//            CGRect frame;
//            frame.size.width=65; frame.size.height=65;
//            frame.origin.x=0; frame.origin.y=0;
//            
//            AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
//            asyncImage.backgroundColor=[UIColor clearColor];
//            asyncImage.tag = 999;
//            
//            NSURL* url;
//            url = [NSURL URLWithString:urlStr];
//            [asyncImage loadImageFromURL:url];
//            
//            [imgview1 addSubview:asyncImage];
//            
//        }
//        [imgview addSubview:imgview1];
//        [imgview1 release];
//        [selectedBackground release];
//        [imgview release];
        
        
        
        AppRecord *appRecord = [self.entries objectAtIndex:indexPath.row];
        // Only load cached images; defer new downloads until scrolling ends
        if (!appRecord.StrappIcon && appRecord.StrimageURL!=nil && ((NSNull *)appRecord.StrimageURL != [NSNull null]))
        {
            if (![appRecord.StrimageURL isEqualToString:@""]) {
                if (tblCollections.dragging == NO && tblCollections.decelerating == NO)
                {
                    [self startIconDownload:appRecord forIndexPath:indexPath];
                }
                // if a download is deferred or in progress, return a placeholder image
                //cell.imageView.image = [UIImage imageNamed:@"no_photo.png"];  
                UIImageView *imgview1=[[UIImageView alloc]initWithFrame:CGRectMake(14, 13, 65,65 )];
                
                [imgview1 setImage:[UIImage imageNamed:@"thumb_1.png"]];
                [imgview addSubview:imgview1];
                [cell addSubview:imgview];
                [imgview release];
            }
        }
        else
        {
            if (appRecord.StrimageURL!=nil && ((NSNull *)appRecord.StrimageURL != [NSNull null])) {
                //cell.imageView.image = appRecord.appIcon;
                UIImageView *imgview1=[[UIImageView alloc]initWithFrame:CGRectMake(14, 13, 65,65)];
                
                [imgview1 setImage:appRecord.StrappIcon];
                [imgview addSubview:imgview1];
                [cell addSubview:imgview];
                [imgview release];
            } else {
                UIImageView *imgview1=[[UIImageView alloc]initWithFrame:CGRectMake(14, 13, 65,65)];
                
                [imgview1 setImage:[UIImage imageNamed:@"thumb_1.png"]];
                [imgview addSubview:imgview1];
                [cell addSubview:imgview];
                [imgview release];
            }
            
            
        }
        

    }
		   
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	CollectionViewController *collectionViewController = [[CollectionViewController alloc] init];
	//collectionViewController.currentCollection = [collections objectAtIndex:indexPath.row];
	//collectionViewController.collectionID = indexPath.row + 1;
    collectionViewController.collectionArr=[[collections objectAtIndex:indexPath.row]valueForKey:@"collection"];
	[self.navigationController pushViewController:collectionViewController animated:YES];
   	
}


- (void) fillTheIconArray {
    for (int i = 0; i<[collections count]; i++) 
    {
        AppRecord *appRecord = [[AppRecord alloc] init];
        //NSMutableDictionary *photoUrl= [[NSMutableDictionary alloc] init];
        //photoUrl = [[[self.ArrayFavourites objectAtIndex:i] objectForKey:@"user"] valueForKey:@"primary_photo"];
        //appRecord.StrimageURL = [photoUrl objectForKey:@"thumb_photo_url"];
        appRecord.StrimageURL = [[[collections objectAtIndex:i]valueForKey:@"collection"]valueForKey:@"latest_item_latest_photo_url"];
        [self.entries addObject:appRecord];
    } 
   
    
   // [tblCollections reloadData];
}



-(void) cleanup 
{
	NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}


#pragma mark Downloading logo

- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"________indexpath.row=%d",indexPath.row);
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
        [appRecord release];
    }
    
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.entries count] > 0)
    {
        NSArray *visiblePaths = [tblCollections indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            AppRecord *appRecord = [self.entries objectAtIndex:indexPath.row];
            
            if (!appRecord.StrappIcon) // avoid the app icon download if the app already has an icon
            {
				if (appRecord.StrimageURL==nil || ((NSNull *)appRecord.StrimageURL == [NSNull null])) {
				}else {
					[self startIconDownload:appRecord forIndexPath:indexPath];
				}                
            } else {
				UITableViewCell *cell = [tblCollections cellForRowAtIndexPath:indexPath];
				cell.imageView.image = appRecord.StrappIcon;
			}
			
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [tblCollections cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        //cell.imageView.image = iconDownloader.appRecord.appIcon;
        //-------
        //for hiding the previous default log
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(14, 13, 65,65)];
        [img2 setImage:[UIImage imageNamed:@"listlogoclear.png"]];
        [cell addSubview:img2];
        [img2 release];
        
        //--------
        UIImageView *imgview=[[UIImageView alloc]initWithFrame:CGRectMake(14, 13, 65,65 )];
        [imgview setImage:iconDownloader.appRecord.StrappIcon];
        [cell addSubview:imgview];
        [imgview release];
        
        //		AppRecord *appRecord = [self.entries objectAtIndex:indexPath.row];
        //		appRecord.appIcon = iconDownloader.appRecord.appIcon;
        //		[appRecord release];
    }
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (!decelerate)
	{
		[self loadImagesForOnscreenRows];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self loadImagesForOnscreenRows];
}


#pragma mark - Memory Method


-(void)viewWillDisappear:(BOOL)animated
{
	//self.title=@"Collections";
}
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
	
}

- (void)viewDidUnload {
	
}


- (void)dealloc {
	[tblCollections release];
    [super dealloc];
}



@end
