//
//  ItemViewController.m
//  displaycase
//
//  Created by Nikhil Patel on 18/01/11.
//  Copyright 2011 Complitech Solutions Pvt. Ltd. All rights reserved.
//

#import "ItemViewController.h"
#import "CustomTabBar.h"
#import "SettingsManager.h"
#import "SBJSON.h"
#import "JSON.h"


static sqlite3_stmt *getStmt = nil;
static sqlite3_stmt *getStmt2 = nil;

@implementation ItemViewController

@synthesize nextItemID;
@synthesize prevItemID;
@synthesize currentItemID;
@synthesize collectionID;
@synthesize lblNum;
@synthesize pageControl, scrollView, itemIdArray,imageItemidArr,imgCurrentIndex;

- (void)ShowCurrentItemDetails 
{
	self.pageControl.numberOfPages = [specifiedImageArray count];

    [scrollView removeFromSuperview];
     scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 272)];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
	
	scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
	scrollView.canCancelContentTouches = YES;
    
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(0, 0);
    
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
     
    int x=0;
    int width=320;
	for(int i =0; i<[specifiedImageArray count]; i++)
	{
       
        NSURL *url=[NSURL URLWithString:[specifiedImageArray objectAtIndex:i]];
        
        UIImageView * imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(x+28, 25, 263,263)];
        
        AsyncImageView* oldImage = (AsyncImageView*)[imgView1 viewWithTag:999];
        [oldImage removeFromSuperview];
        CGRect frame;
        frame.size.width=263; frame.size.height=263;
        frame.origin.x=x+28; frame.origin.y=25;
            
        AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
        asyncImage.backgroundColor=[UIColor clearColor];
        asyncImage.tag = 999;
        [asyncImage loadImageFromURL:url];
		[scrollView addSubview:asyncImage];
		[imgView1 release];
        
        
        scrollView.contentSize = CGSizeMake(width, 0);
        width=width+320;
		x = x+29;
        
		x = x+263+28;
		
	}
}

-(void)ShowNextItemDetails1
{
    if(imgCurrentIndex < [imageItemidArr count])
    {
        imgCurrentIndex++;
        [self sendRequests];
    }
}
-(void)ShowPrevItemDetails1
{
    if(imgCurrentIndex > 0 )
    {
        imgCurrentIndex--;
        [self sendRequests];
    }
}

- (void) ShowNextItemDetails
{
	if(currentItemID != (imageCount - 1))
	{
		
		currentItemID ++;
		scrollView.contentSize = CGSizeMake(0, 0);
		//[specifiedImageArray removeAllObjects];
		//[self getSpecifiedImages:[[self.itemIdArray objectAtIndex:currentItemID] intValue] ];
		if([specifiedImageArray count] == 1)
		{
			scrollView.contentSize = CGSizeMake(320, 0);
		}
		else if([specifiedImageArray count] == 2)
		{
			scrollView.contentSize = CGSizeMake(640, 0);
		}
		else 
		{
			scrollView.contentSize = CGSizeMake(1220, 0);
		}

		self.pageControl.numberOfPages = [specifiedImageArray count];
		CGSize size=CGSizeMake(263, 263);
		UIGraphicsBeginImageContext(size);
		[[imgArray objectAtIndex:currentItemID] drawInRect:CGRectMake(0, 0, size.width,size.height)];
		UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		[itemImageView setImage:scaledImage];
		int x = 291;
		for(int i =0; i<[specifiedImageArray count]; i++)
		{
			x = x+29;
			CGSize size=CGSizeMake(263, 263);
			UIGraphicsBeginImageContext(size);
			[[specifiedImageArray objectAtIndex:i] drawInRect:CGRectMake(0, 0, size.width,size.height)];
			UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			
			UIImageView * imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(x+28, 25, 263,206)];
			[imgView1 setImage:scaledImage];
			[scrollView addSubview:imgView1];
			[imgView1 release];
			x = x+263;
			
		}

	}
	else 
	{
		 
	}

}


- (void) ShowPrevItemDetails
{
	
	if(currentItemID != 0)
	{
		currentItemID --;
		scrollView.contentSize = CGSizeMake(0, 0);
		[specifiedImageArray removeAllObjects];
		[self getSpecifiedImages:[[self.itemIdArray objectAtIndex:currentItemID]intValue]];
		
		if([specifiedImageArray count] == 1)
		{
			scrollView.contentSize = CGSizeMake(320, 0);
		}
		else if([specifiedImageArray count] == 2)
		{
			scrollView.contentSize = CGSizeMake(640, 0);
		}
		else 
		{
			scrollView.contentSize = CGSizeMake(1220, 0);	
		}

				
		self.pageControl.numberOfPages = [specifiedImageArray count];
		CGSize size=CGSizeMake(263, 263);
		UIGraphicsBeginImageContext(size);
		[[imgArray objectAtIndex:currentItemID] drawInRect:CGRectMake(0, 0, size.width,size.height)];
		UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		[itemImageView setImage:scaledImage];
		int x = 291;
		for(int i =0; i<[specifiedImageArray count]; i++)
		{
			x = x+29;
			CGSize size=CGSizeMake(263, 263);
			UIGraphicsBeginImageContext(size);
			[[specifiedImageArray objectAtIndex:i] drawInRect:CGRectMake(0, 0, size.width,size.height)];
			UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			
			UIImageView * imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(x+28, 25, 263,206)];
			[imgView1 setImage:scaledImage];
			[scrollView addSubview:imgView1];
			[imgView1 release];
			x = x+263;
			
		}
		
	}
	else 
	{
		
	}

}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	appDelegate = (displaycaseAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    appTabBar = (CustomTabBar *)appDelegate.tabBarController;
	[appTabBar hideTabBar];
	
//	[self.scrollView setBackgroundColor:[UIColor clearColor]];
//	
//	scrollView.pagingEnabled = YES;
//    scrollView.contentSize = CGSizeMake(1220, 0);
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.showsVerticalScrollIndicator = NO;
//	scrollView.canCancelContentTouches = YES;
//
//    scrollView.scrollsToTop = NO;
//    scrollView.delegate = self;
	
	//specifiedImageArray = [[NSMutableArray alloc] init];
	itemIdArray = [[NSMutableArray alloc] init];	
	imgArray = [[NSMutableArray alloc]init];
	//[self getImages];
    [self sendRequests];
	imageCount = [imgArray count];
    
	//[self ShowCurrentItemDetails];
	
	
	imgView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 424, 320.0,56)];
	[imgView setImage:[UIImage imageNamed:@"background.png"]];
	[appTabBar.view addSubview: imgView];
	
	arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 442, 320, 36)];
	[arrowView setImage:[UIImage imageNamed:@"item_arrow_bar_bg.png"]];
	[appTabBar.view addSubview:arrowView];
	
	
	leftArrow = [UIButton buttonWithType:UIButtonTypeCustom];
	leftArrow.frame = CGRectMake(10, 452, 17, 20);
	[leftArrow setImage:[UIImage imageNamed:@"item_arrow_bar_arrow_left.png"] forState:UIControlStateNormal];
	[leftArrow addTarget:self action:@selector(ShowPrevItemDetails1) forControlEvents:UIControlEventTouchUpInside];
	[appTabBar.view addSubview:leftArrow];
	
	rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
	rightArrow.frame = CGRectMake(295, 452, 17, 20);
	[rightArrow setImage:[UIImage imageNamed:@"item_arrow_bar_arrow_right.png"] forState:UIControlStateNormal];
	[rightArrow addTarget:self action:@selector(ShowNextItemDetails1) forControlEvents:UIControlEventTouchUpInside];
	[appTabBar.view addSubview:rightArrow];
	
    
    if([imageItemidArr count]<=1)
    {
        leftArrow.hidden=YES;
        rightArrow.hidden=YES;
    }
       
	lblNum = [[UILabel alloc] initWithFrame:CGRectMake(30, 444, 250, 30)];
	//[lblNum setText:@"1 of 4"];
	[lblNum setBackgroundColor:[UIColor clearColor]];
	lblNum.textAlignment = UITextAlignmentCenter;
	[lblNum setTextColor:[UIColor colorWithRed:97/255.0f green:75/255.0f blue:48/255.0f alpha:1.0f]];
	[lblNum setFont:[UIFont boldSystemFontOfSize:20.0]];
	[appTabBar.view addSubview:lblNum];
	
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
   nextCount=1;

}



-(void)viewWillAppear:(BOOL)animated
{
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


- (void)sendRequests {  
    
    
   // kAPIGetItemDetail http://192.168.1.200:3004/items/:id?auth_token=somekey
    
    
    currentItemID=[[imageItemidArr objectAtIndex:imgCurrentIndex]intValue];
    

    NSString *user_auth_token =[[SettingsManager gameSettings]getUserAuthentication]; 
    NSString *Str = [NSString stringWithFormat:@"%@%d.json?auth_token=%@",kAPIGetItemDetail,currentItemID,user_auth_token];
    [[RKClient sharedClient] get:Str delegate:self];
    
}  
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{    
    
    if ([request isGET]) 
    { 
        if ([response isOK]) 
        {  
            NSLog(@"Retrieved XML: %@", [response bodyAsString]); 
            NSString *jsonString=[response bodyAsString];
            NSDictionary *results = [jsonString JSONValue];
            NSMutableArray *itemArr=[[[results objectForKey:@"item"] objectForKey:@"photos"]valueForKey:@"photo_url"];
            
            specifiedImageArray = [[NSMutableArray alloc] init];
            for(int i=0; i<[itemArr count]; i++)
            {
                [specifiedImageArray addObject:[itemArr objectAtIndex:i]];
            }
            
            if(imgCurrentIndex+1 >= [imageItemidArr count])
            {
                [rightArrow setHidden:YES];
            }
            else
            {
                [rightArrow setHidden:NO];
            }
            if(imgCurrentIndex > 0)
            {
                [leftArrow setHidden:NO];
            }
            else
            {
                [leftArrow setHidden:YES];
            }
            
            [self.lblNum setText:[NSString stringWithFormat:@"%d of %d",imgCurrentIndex+1,[imageItemidArr count]]];
            [self ShowCurrentItemDetails];
            
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



- (void)viewWillDisappear:(BOOL)animated
{
	[lblNum removeFromSuperview];
	[rightArrow removeFromSuperview];
	[leftArrow removeFromSuperview];
	[arrowView removeFromSuperview];
	[imgView removeFromSuperview];
	[appTabBar showTabBar];
}
-(void)back
{
    CollectionFlag=FALSE;
	[self.navigationController popViewControllerAnimated:YES];
}


-(void) getImages
{
	database = appDelegate.database;
	
	if(!getStmt)
	{
		NSString *queryStr = [NSString stringWithFormat:@"select pk, photo_1 from items where collection_id = %d",collectionID];
		const char *sql = (char *) [queryStr UTF8String];
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
		
		
		int item = sqlite3_column_int(getStmt, 0);
		[self.itemIdArray addObject:[NSNumber numberWithInt:item]];
		
		NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(getStmt, 1) length:sqlite3_column_bytes(getStmt, 1)];
		
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
			[imgArray addObject:[UIImage imageWithData:data]];
			[data release];
			
		}
		
	}
	NSLog (@"Image array %@", [imgArray description]);
	NSLog(@"Image array count %d", [imgArray count]);
	sqlite3_reset(getStmt);
	getStmt = nil;
	
}// end of getImages method




-(void)getSpecifiedImages:(int)itemId
{
	database = appDelegate.database;
	
	if(!getStmt2)
	{
		NSString *queryStr = [NSString stringWithFormat:@"select photo_1, photo_2, photo_3, photo_4 from items where pk = %d",itemId];
		const char *sql = (char *) [queryStr UTF8String];
		if(sqlite3_prepare_v2(database, sql, -1, &getStmt2, NULL) != SQLITE_OK)
		{
			getStmt2 = nil;
		}
	}
	if(!getStmt2)
	{
		NSAssert1(0, @"Cant read data from db [%s]", sqlite3_errmsg(database));
	}
	
	int ret;
	while((ret = sqlite3_step(getStmt2)) == SQLITE_ROW)
	{
		
		for(int i =0; i<4; i++)
		{
			NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(getStmt2, i) length:sqlite3_column_bytes(getStmt2, i)];
			
			if([data length] == 0 )
			{
				NSLog (@"Inside if.... >>>>");
				break;
			}
			else
			{
			
				NSLog (@"Inside else.... >>>>");
				[specifiedImageArray addObject:[UIImage imageWithData:data]];
				[data release];
			
			}
		
		}
	}
	NSLog (@"specifiedImageArray array %@", [specifiedImageArray description]);
	NSLog(@"specifiedImageArray count %d", [specifiedImageArray count]);
	sqlite3_reset(getStmt2);
	getStmt2 = nil;
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate stuff


- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    
	
	if (pageControlIsChangingPage) 
	{
        return;
    }
	
	
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	
	
	//[self.lblNum setText:[NSString stringWithFormat:@"%d of %d", page+1,[specifiedImageArray count]]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
    pageControlIsChangingPage = NO;
    
//    CGFloat pageWidth = _scrollView.frame.size.width;
//    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    nextCount=page;
}
 

#pragma mark -
#pragma mark PageControl stuff
- (IBAction)changePage:(id)sender 
{
	/*
	 *	Change the scroll view
	 */
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
	
    [scrollView scrollRectToVisible:frame animated:YES];
    
	/*
	 *	When the animated scrolling finishings, scrollViewDidEndDecelerating will turn this off
	 */
    pageControlIsChangingPage = YES;
    
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
