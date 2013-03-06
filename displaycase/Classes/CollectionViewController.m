
//
//  CollectionViewController.m
//  displaycase
//
//  Created by Nikhil Patel on 17/01/11.
//  Copyright 2011 Complitech Solutions Pvt. Ltd. All rights reserved.
//

#import "CollectionViewController.h"
#import "ItemViewController.h"
#import "NewItemViewController.h"
#import "SettingsManager.h"
#import "MessageView.h"
#import "SBJSON.h"
#import "JSON.h"

#define TOTAL_NO_OF_COLUMNS 4
#define PAGE_WIDTH 320
#define PAGE_HEIGHT 480

static sqlite3_stmt *getStmt = nil;

@implementation CollectionViewController

@synthesize currentCollection;
@synthesize collectionID;
@synthesize collectionArr;
@synthesize messagePopUp;




#pragma mark - Life cycle Method

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    
    CollectionFlag=TRUE;
    
	//imgArray = [[NSMutableArray alloc]init];
    //imageidArr=[[NSMutableArray alloc]init];
    
	//self.title = [NSString stringWithFormat:@"%@",currentCollection.name];

	imgBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
	imgBGView.frame = CGRectMake(0, 0, 320, 367);
	[self.view addSubview:imgBGView];
	
	
	//scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, PAGE_WIDTH, PAGE_HEIGHT)];
	//[scrollView setContentSize: CGSizeMake(PAGE_WIDTH, PAGE_HEIGHT + PAGE_HEIGHT)];	// twice as long as the screen
//	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
//	[scrollView setContentSize: CGSizeMake(320, (367*2))];
//	scrollView.userInteractionEnabled = YES; 
//	scrollView.showsHorizontalScrollIndicator = YES;
//	[self.view addSubview:scrollView];
//	scrollView.backgroundColor = [UIColor clearColor];
//	scrollView.scrollEnabled = YES;
	 //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:nil action:nil]; 
	
	//UIBarButtonItem *rightNewButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(NewItem:)];      
	//self.navigationItem.rightBarButtonItem = rightNewButton;
	
	//[self getItems];
	//[self AddImageView];
    
	//Hide Tab Bar
	//self.tabBarController.tabBar.hidden = YES;
    
    //Code for Display Loader on the screen...
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageView" owner:self options:nil];
	self.messagePopUp = (MessageView *)[nib objectAtIndex:0];
	[self.messagePopUp setup];
	[self.view addSubview:(UIView*)self.messagePopUp];
	
    

}
-(void)viewWillAppear:(BOOL)animated
{
	CGRect frame = CGRectMake(100, 10, 150, 40);
	UILabel *lblTitle = [[[UILabel alloc] initWithFrame:frame] autorelease];
	lblTitle.backgroundColor = [UIColor clearColor];
	//[lblTitle setText:[NSString stringWithFormat:@"%@",currentCollection.name]];
  //  NSLog(@"%@",[collectionArr description]);
    [lblTitle setText:[NSString stringWithFormat:@"%@",[collectionArr valueForKey:@"name"]]];
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
	[rightBarbutton addTarget:self action:@selector(NewItem:) forControlEvents:UIControlEventTouchUpInside];
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
    
    if(CollectionFlag)
    {
        [self.messagePopUp show:@"Please wait..."];
        [self performSelector:@selector(sendRequests) withObject:nil afterDelay:0.01];
    }
    
    
   	
}

#pragma mark - Other method


- (void)sendRequests {  
    
    //get collection by collection id...
    
    NSString *user_auth_token =[[SettingsManager gameSettings]getUserAuthentication]; 
    
    NSString *collectionId=[collectionArr valueForKey:@"id"];
    
    NSString *Str = [NSString stringWithFormat:@"%@%@/items.json?auth_token=%@",kAPIGetCollectionBycollectionId,collectionId,user_auth_token];
    [[RKClient sharedClient] get:Str delegate:self];
    
}  
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{    
    
    if ([request isGET]) 
    { 
        if ([response isOK]) 
        {  
           // NSLog(@"Retrieved XML: %@", [response bodyAsString]); 
            NSString *jsonString=[response bodyAsString];
            NSDictionary *results = [jsonString JSONValue];
            
            total_res=[[results valueForKey:@"total_results"]intValue];
            if(total_res > 0)
            {
                
                imgArray=nil;
                imageidArr=nil;
                imgArray = [[NSMutableArray alloc]init];
                imageidArr=[[NSMutableArray alloc]init];
                
                NSMutableArray *itemArr=[results objectForKey:@"items"];
                for(int i=0; i<[itemArr count]; i++)
                {
                    [imgArray addObject:[[[itemArr objectAtIndex:i] valueForKey:@"item"]valueForKey:@"latest_photo_url"]];
                    [imageidArr addObject:[[[itemArr objectAtIndex:i] valueForKey:@"item"]valueForKey:@"id"]];
                }
                [self AddImageView];
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
    [self.messagePopUp hide];
}  


- (void) AddImageView
{
    
    [scrollView removeFromSuperview];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	[scrollView setContentSize: CGSizeMake(320, (367*2))];
	scrollView.userInteractionEnabled = YES; 
	scrollView.showsHorizontalScrollIndicator = YES;
	[self.view addSubview:scrollView];
	scrollView.backgroundColor = [UIColor clearColor];
	scrollView.scrollEnabled = YES;
    
	NSLog(@"In Add Item View............");
	//NSLog(@"Item Array Details............%@",currentCollection.items);
	float xPosition,yPosition,imageWidth,imageHeight,xIncrement,yIncrement;
	int counter;
	xPosition = 15;
	yPosition = 15;
	imageWidth = 60;
	imageHeight = 60;
	xIncrement = 75;
	yIncrement = 70;
	
	counter = 1;
	//for (int i = 0;i < currentCollection.items.count; i++) 
	for (int i = 0;i < [imgArray count]; i++) 
	{
		NSString *urlStr=[NSString stringWithFormat:@"%@",[imgArray objectAtIndex:i]];
        if(![urlStr isEqualToString:@""])
        {
            
            
            if([urlStr isEqualToString:@""])
            {
               // imgview1.image=[UIImage imageNamed:@"thumb_1.png"]; 
            }
               
            else
            {
                UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
                AsyncImageView* oldImage = (AsyncImageView*)[itemButton viewWithTag:999];
                [oldImage removeFromSuperview];
                CGRect frame;
                frame.size.width=imageWidth; frame.size.height=imageHeight;
                frame.origin.x=xPosition; frame.origin.y=yPosition;
                
                AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
                asyncImage.backgroundColor=[UIColor clearColor];
                asyncImage.tag = 999;
                
                CALayer *layer = [asyncImage layer];
                [layer setMasksToBounds:YES];
                [layer setCornerRadius:5.0];
                
                NSURL* url;
                url = [NSURL URLWithString:urlStr];
                [asyncImage loadImageFromURL:url];
                
                itemButton.frame = CGRectMake(xPosition,yPosition,imageWidth,imageHeight);
                [itemButton addTarget:self action:@selector(ItemSelected:) forControlEvents:UIControlEventTouchUpInside];
                
                [scrollView addSubview:asyncImage];
                [scrollView addSubview:itemButton];
                
                 itemButton.tag=i;
               // itemButton.tag=[[imageidArr objectAtIndex:i]intValue];
                
                
                
                
            }
            
            
           
                        
            xPosition += xIncrement;
                        
            //For set image in total no of columns
            if (counter == TOTAL_NO_OF_COLUMNS) 
            {
                 yPosition += yIncrement;
                 xPosition = 15;
                 counter = 1;
            }
            else 
            {
               //Check to set scrollview contentsize
               if(i == collectionData.count - 1) 
               {
                   yPosition += yIncrement;
               }
                counter++;
            }
                        
        }
    }	
	
	//Setting scrollview size after adding images
	scrollView.contentSize = CGSizeMake(PAGE_WIDTH, yPosition + yIncrement + 40);
    
}


//getting the images from db
-(void) getItems
{
	appDelegate = (displaycaseAppDelegate *)[[UIApplication sharedApplication] delegate];
	database = appDelegate.database;
	
	if(!getStmt)
	{
		NSString *queryStr = [NSString stringWithFormat:@"select title, tags, photo_1 from items where collection_id = %d", collectionID];
		const char *sql = (char *) [queryStr UTF8String];
		//const char *sql = "select title, tags, photo_1 from items where collection_id = 1";
		if(sqlite3_prepare_v2(database, sql, -1, &getStmt, NULL) != SQLITE_OK)
		{
			getStmt = nil;
		}
	}
	if(!getStmt)
	{
		NSAssert1(0, @"Cant read data from db [%s]", sqlite3_errmsg(database));
	}
	
	int ret;
	while((ret = sqlite3_step(getStmt)) == SQLITE_ROW)
	{
		NSString *strTitle1;
		NSString *strTags1;
		
		char *s = (char *) sqlite3_column_text(getStmt, 0);
		if(s == NULL)
			s = "";			
		strTitle1 = [NSString stringWithUTF8String:(char *)s];
		NSLog(@"Title ::::-- %@", strTitle1);
		
		s=(char *) sqlite3_column_text(getStmt, 1);
		if(s == NULL)
			s = "";
		strTags1 = [NSString stringWithUTF8String:(char *)s];
		NSLog(@"tags ::::-- %@", strTags1);
		
		//sqlite3_column_blob(getStmt, 2);
		NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(getStmt, 2) length:sqlite3_column_bytes(getStmt, 2)];
		
		if([data length] == 0 )
		{
			NSLog (@"Inside if.... >>>>");
			UIImage *image = [UIImage imageNamed:@"image3.png"];
			[imgArray addObject:image];
			[image release];
		}
		else
		{
			
			NSLog (@"Inside else.... >>>>");
			UIImage *image = [UIImage imageWithData:data];
			[imgArray addObject:image];
			[image release];
			[data release];
			
		}
		
		/*NSData *data1 = [[NSData alloc] initWithBytes:sqlite3_column_blob(getStmt, 3) length:sqlite3_column_bytes(getStmt, 3)];
         
         if([data1 length] == 0 )
         {
         NSLog (@"Inside if.... >>>>");
         UIImage *image = [UIImage imageNamed:@"image3.png"];
         [imgArray addObject:image];
         [image release];
         }
         else
         {
         
         NSLog (@"Inside else.... >>>>");
         UIImage *image = [UIImage imageWithData:data1];
         [imgArray addObject:image];
         [image release];
         [data1 release];
         
         }*/
	}
	NSLog (@"Image array %@", [imgArray description]);
	sqlite3_reset(getStmt);
	getStmt = nil;
	
}// end of getitems method


#pragma mark - Button Method

- (void)ItemSelected:(id) sender 
{
	NSLog(@"ITem Selected.......");
	
	ItemViewController *itemViewController = [[ItemViewController alloc] init];
	UIButton *button=sender;
    itemViewController.imgCurrentIndex=button.tag;
    //itemViewController.currentItemID = button.tag;
    itemViewController.imageItemidArr = imageidArr;
    //itemViewController.collectionID = collectionID;
	NSLog(@"CurrentItem Id = %d", itemViewController.currentItemID);
	[self.navigationController pushViewController:itemViewController animated:YES];
	[itemViewController autorelease];
}

-(void)back
{
	[self.navigationController popViewControllerAnimated:YES];
}


- (void) NewItem:(id) sender {
	NSLog(@"New Item Button Clicked......");
	NewItemViewController *newItemController = [[NewItemViewController alloc] initWithNibName:@"NewItem" bundle:nil];
    newItemController.selectedCollection=[collectionArr valueForKey:@"name"];
    newItemController.collection_id=[collectionArr valueForKey:@"id"];
	[self.navigationController pushViewController:newItemController animated:YES];
	
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	//self.tabBarController.tabBar.hidden = NO;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
