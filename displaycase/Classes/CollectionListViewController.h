//
//  CollectionListViewController.h
//  displaycase
//
//  Created by Nikhil Patel on 11/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewItemViewController.h"
#import <RestKit/RestKit.h>

@interface CollectionListViewController : UIViewController<RKRequestDelegate> {
	IBOutlet UITableView* tableView;
	NSMutableArray *collections;
	NewItemViewController *objNewItemViewController;
}
@property(nonatomic,retain)NewItemViewController *objNewItemViewController;
- (void)sendRequests;
@end
