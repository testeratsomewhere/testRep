//
//  CollectionViewController.h
//  displaycase
//
//  Created by Nikhil Patel on 17/01/11.
//  Copyright 2011 Complitech Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Collection.h"
#import "Item.h"
#import <sqlite3.h>
#import "displaycaseAppDelegate.h"
#import <RestKit/RestKit.h>

#import "AsyncImageView.h"

@class MessageView;
@interface CollectionViewController : UIViewController<RKRequestDelegate> {
	
    MessageView *messagePopUp;
    
    NSMutableArray *collectionData;
	UIScrollView *scrollView;
	Collection *currentCollection;
	
	sqlite3 *database;
	displaycaseAppDelegate *appDelegate;
	UIImage *img;
	NSMutableArray *imgArray;
	
	UIImageView *imgBGView;
	
	int collectionID;
    
    NSMutableArray *collectionArr;
    NSMutableArray *imageidArr;
    
    int total_res;
}

@property (nonatomic,retain) MessageView *messagePopUp;

@property (nonatomic,retain)NSMutableArray *collectionArr;

@property (nonatomic, retain) Collection *currentCollection;

@property (nonatomic, readwrite) int collectionID;

-(void) getItems;
- (void)sendRequests;

- (void) AddImageView;
@end
