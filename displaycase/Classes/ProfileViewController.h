//
//  ProfileViewController.h
//  displaycase
//
//  Created by Nikhil Patel on 18/01/11.
//  Copyright 2011 Complitech Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tblProfileOptions;
	NSMutableArray *profileTable;
}

@end
