//
//  CollectionAddViewController.h
//  displaycase
//
//  Created by Nikhil Patel on 16/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>


@interface CollectionAddViewController : UIViewController <RKRequestDelegate>
{
	IBOutlet UITextField *txtCollectionName;
	IBOutlet UILabel *lblCollectionName;
}

- (void)sendRequests;

@end
