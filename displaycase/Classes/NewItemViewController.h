//
//  NewItemViewController.h
//  displaycase
//
//  Created by Nikhil Patel on 22/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "displaycaseAppDelegate.h"
#import <RestKit/RestKit.h>

@class MessageView;
@interface NewItemViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate,RKRequestDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> 
{
    MessageView *messagePopUp;
    
	NSMutableArray *userPhotos;
	IBOutlet UITableView *tableView;
	int noOfPhoto;
	BOOL isNewItem;
	UIImageView *imageSelected;
	NSString *selectedCollection;
	int intCollections;
	NSString *strTitle;
	NSString *strTags;
	NSString *strDesc;

    
	IBOutlet UITextView* textView;
	UITextField* selectedTextField;
	
	sqlite3 *database;
	
	displaycaseAppDelegate *appDelegate;
	UIImage *img;
	NSMutableArray *selectedImageArray;
    
    NSString *base64str1;
    NSString *base64str2;
    NSString *base64str3,*base64str4;
    
    NSString *collection_id;
    
    BOOL *allValidationDone;
    
    NSMutableArray *imageArr;
}
@property (nonatomic,retain) NSMutableArray *imageArr;

@property (nonatomic,retain) MessageView *messagePopUp;

@property (nonatomic,retain)NSString *collection_id;

@property (nonatomic, retain) NSMutableArray *userPhotos; 

- (IBAction) ChoosePhotos;

@property(nonatomic)int noOfPhoto;
@property (nonatomic)int intCollections;
@property(nonatomic,retain)NSString* selectedCollection;
@property(nonatomic,retain)UIImageView* imageSelected;
@property (nonatomic, retain)NSString *strTitle;
@property (nonatomic, retain) NSString *strTags;
@property (nonatomic, retain) NSString *strDesc;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIImage *img;
@property (nonatomic, retain) NSMutableArray *selectedImageArray;




-(void)insertItem;
- (void)sendRequests;
-(void) checkValidation;

@end
