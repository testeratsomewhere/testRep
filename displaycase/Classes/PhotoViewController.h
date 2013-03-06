//
//  PhotoViewController.h
//  displaycase
//
//  Created by Nikhil Patel on 22/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewItemViewController;
@interface PhotoViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
	IBOutlet UIImageView *imageView;
	NewItemViewController *objNewItemViewController;
}

@property(nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain)NewItemViewController *objNewItemViewController;
@end
