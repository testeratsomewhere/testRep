//
//  CollectionsViewController.h
//  displaycase
//
//  Created by Nikhil Patel on 17/01/11.
//  Copyright 2011 Complitech Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <RestKit/RestKit.h>

#import "IconDownloader.h"

#import "AsyncImageView.h"


@class displaycaseAppDelegate;

@class MessageView;
@interface CollectionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,RKRequestDelegate,IconDownloaderDelegate> 
{
    MessageView *messagePopUp;
    
	IBOutlet UITableView *tblCollections; 
	NSMutableArray *collections;
	sqlite3 *database;
	UIImage *img;
	NSMutableArray *imgArray;
	NSMutableArray *recivingArray;
	displaycaseAppDelegate *appDelegate;
    
    NSMutableArray *logoArray;
	NSMutableDictionary *imageDownloadsInProgress;
	
	NSMutableArray *entries; 
    

}
@property (nonatomic,retain) MessageView *messagePopUp;
- (void)populateCollections;
- (void)sendRequests;

-(void)fillTheIconArray;
-(void)cleanup;

@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) NSMutableArray *entries; 
@end
