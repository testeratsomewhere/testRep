//
//  ActivityViewController.h
//  displaycase
//
//  Created by Nikhil Patel on 22/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ActivityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tblActivity; 
}

@end
