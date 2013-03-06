//
//  ItemViewController.h
//  displaycase
//
//  Created by Nikhil Patel on 18/01/11.
//  Copyright 2011 Complitech Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "displaycaseAppDelegate.h"
#import "CustomTabBar.h"
#import "GrayPageControl.h"
#import <RestKit/RestKit.h>

@interface ItemViewController : UIViewController <UIScrollViewDelegate,RKRequestDelegate>
{
	IBOutlet UIImageView *itemImageView;
	IBOutlet UILabel *itemTitle;
	int nextItemID;
	int prevItemID;
	int currentItemID;
	
	int  collectionID; 
	
	sqlite3 *database;
	displaycaseAppDelegate *appDelegate;
	UIImage *img;
	NSMutableArray *imgArray;
	int imageCount;
	NSMutableArray *itemIdArray;
	
	IBOutlet UIScrollView *scrollView;
	IBOutlet GrayPageControl *pageControl;
	
	BOOL pageControlIsChangingPage;
	NSMutableArray *specifiedImageArray;
	
	CustomTabBar *appTabBar;
	
	UIImageView *imgView;
	UIImageView *arrowView;
	UIButton *leftArrow;
	UIButton *rightArrow;
	
	UILabel *lblNum;
    
    int nextCount;
    

    int imgCurrentIndex;
    NSMutableArray *imageItemidArr;
}
@property (nonatomic, assign)int imgCurrentIndex;
@property (nonatomic,retain)NSMutableArray *imageItemidArr;


@property (nonatomic, assign) int nextItemID;
@property (nonatomic, assign) int prevItemID;
@property (nonatomic, assign) int currentItemID;

@property (nonatomic, assign) int collectionID;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *itemIdArray;

@property (nonatomic, retain) UILabel *lblNum;

- (IBAction) ShowNextItemDetails;
- (IBAction) ShowPrevItemDetails;
- (IBAction)changePage:(id)sender ;
-(void)getImages;
-(void)getSpecifiedImages:(int)itemId;

- (void)sendRequests;

@end
