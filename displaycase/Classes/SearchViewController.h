//
//  SearchViewController.h
//  displaycase
//
//  Created by Nikhil Patel on 22/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "CustomCellSearch.h"
#import "AsyncImageView.h"
//#import "SBJSON.h"
//#import "JSON.h"


@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,RKRequestDelegate,UIScrollViewDelegate> 
{
	IBOutlet UITableView *searchTable;

    IBOutlet UISearchBar *searchBarItem;
    
    NSMutableDictionary *DictResponse;
    NSMutableArray *ArrayRecords;
}

- (void)sendRequests;
@end
