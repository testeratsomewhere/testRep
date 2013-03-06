//
//  NewItemViewController.m
//  displaycase
//
//  Created by Nikhil Patel on 22/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewItemViewController.h"
#import "PhotoViewController.h"
#import "CellNewItem.h"
#import "CollectionListViewController.h"
#import "SettingsManager.h"
#import "Base64.h"
#import "MessageView.h"
#import "Popup.h"

static sqlite3_stmt *insertStmt = nil;

@implementation NewItemViewController

@synthesize imageArr;
@synthesize messagePopUp;
@synthesize userPhotos;
@synthesize noOfPhoto,imageSelected,selectedCollection,intCollections;
@synthesize strTitle, strTags, strDesc, textView;
@synthesize img;
@synthesize selectedImageArray;

@synthesize collection_id;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}




#pragma Mark - Life cycle method


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	//self.selectedCollection=@"";
	strTitle = [[NSString alloc] init];
	strTags = [[NSString alloc] init];
	strDesc = [[NSString alloc] init];
	selectedImageArray = [[NSMutableArray alloc] init];
    
    imageArr=[[NSMutableArray alloc]init];
    
	//selectedCollection=@"";
	
	//self.navigationItem.leftBarButtonItem.title = @"Cancel";	
	//self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style: UIBarButtonItemStyleBordered target:nil action:nil];
	self.navigationItem.title = @"New Item";
	
	//UIBarButtonItem *rightSaveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(SaveItem:)];      
	//self.navigationItem.rightBarButtonItem = rightSaveButton;
	
	
	
	textView.text = @"Tap here to enter Details";
	textView.textColor = [UIColor colorWithRed:200/255.0f green:221/255.0f blue:239/255.0f alpha:1.0];
	[textView setFont:[UIFont boldSystemFontOfSize:15.0]];
	
}
- (void)viewWillAppear:(BOOL)animated
{
	
    //Code for Display Loader on the screen...
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageView" owner:self options:nil];
	self.messagePopUp = (MessageView *)[nib objectAtIndex:0];
	[self.messagePopUp setup];
	[self.view addSubview:(UIView*)self.messagePopUp];
    
    
    
    CGRect frame = CGRectMake(100, 10, 150, 40);
    UILabel *lblTitle = [[[UILabel alloc] initWithFrame:frame] autorelease];
    lblTitle.backgroundColor = [UIColor clearColor];
    [lblTitle setText:@"New Item"];
    //lblTitle.textColor =  [UIColor blackColor];
    lblTitle.textColor = [UIColor colorWithRed:67/255.0f green:46/255.0f blue:25/255.0f alpha:1.0]; 
    [lblTitle setFont:[UIFont fontWithName:@"Arial Black" size:20.0]];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:20.0]];
    lblTitle.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = lblTitle;
    
    CGRect btnFrame = CGRectMake(0, 0, 45, 30);
    UIButton *rightBarbutton = [[UIButton alloc] initWithFrame:btnFrame];
    [rightBarbutton setBackgroundImage:[UIImage imageNamed:@"nav_bar_edit_button.png"] forState:UIControlStateNormal];
    [rightBarbutton setBackgroundImage:[UIImage imageNamed:@"nab_bar_edit_button_tapped.png"] forState:UIControlStateSelected];
    [rightBarbutton setTitle:@"Save" forState:UIControlStateNormal];
    [rightBarbutton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [rightBarbutton setTitleColor:[UIColor colorWithRed:97/255.0f green:75/255.0f blue:48/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [rightBarbutton setTitleColor:[UIColor colorWithRed:238/255.0f green:227/255.0f blue:198/255.0f alpha:1.0f] forState:UIControlStateSelected];
    [rightBarbutton addTarget:self action:@selector(SaveItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarbutton];
    self.navigationItem.rightBarButtonItem = rightBarbuttonItem;
    [rightBarbuttonItem release];
    
    
    CGRect btnFrame2 = CGRectMake(0, 0, 52, 30);
    UIButton *leftBarbutton = [[UIButton alloc] initWithFrame:btnFrame2];
    [leftBarbutton setBackgroundImage:[UIImage imageNamed:@"nav_bar_back_button.png"] forState:UIControlStateNormal];
    [leftBarbutton setBackgroundImage:[UIImage imageNamed:@"nab_bar_back_button_tapped.png"] forState:UIControlStateSelected];
    [leftBarbutton setTitle:@"Back" forState:UIControlStateNormal];
    [leftBarbutton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -10.0)];
    [leftBarbutton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [leftBarbutton setTitleColor:[UIColor colorWithRed:97/255.0f green:75/255.0f blue:48/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [leftBarbutton setTitleColor:[UIColor colorWithRed:238/255.0f green:227/255.0f blue:198/255.0f alpha:1.0f] forState:UIControlStateSelected];
    [leftBarbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarbutton];
    self.navigationItem.leftBarButtonItem = leftBarbuttonItem;
    [leftBarbuttonItem release];
    
	tableView.backgroundColor = [UIColor clearColor];
	textView.backgroundColor = [UIColor clearColor];	
	
	//[tableView reloadData];
}

#pragma mark - Button Method


-(void)back
{
    //this flag is declare in pch file because reload the scroll data in collection view controller 
    CollectionFlag=FALSE;
    
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) SaveItem:(id) sender {
	NSLog(@"Save Button Clicked......");
	//NSLog(@"Title=%@\n Collections=%@\n intCollections=%d\nTags=%@\nDescription=%@",strTitle,selectedCollection,intCollections,strTags,textView.text);
	//tableView.frame=CGRectMake(0, 0, 320, 460);
	
    //this flag is declare in pch file because reload the scroll data in collection view controller 
    CollectionFlag=TRUE;
    
    [self checkValidation];
    
    if(allValidationDone)
	{
        [self.messagePopUp show:@"Please Wait..."];
        //[self sendRequests];
        [self performSelector:@selector(sendRequests) withObject:nil afterDelay:0.001];
	}
	//[self insertItem];
	//[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Other Method

-(void) checkValidation
{
	allValidationDone = NO;
	BOOL successTitle = NO;

	
	NSString *titleString =strTitle; 
	
	if ([titleString isEqualToString:@""]) 
    {
		//UIImage *message_back=[UIImage imageNamed:@"background_message.png"];
		//message_back = [message_back stretchableImageWithLeftCapWidth:16 topCapHeight:16];
        
		NSString *str =[NSString stringWithFormat:@"Please enter title."];
		NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
		[dictMsg setObject:str forKey:kPopupMessage];
		[Popup popUpWithMessage: dictMsg delegate:self withType:nil];
	}
	else {
		successTitle=YES;
        
	}
    if(successTitle)
    {
        if(0 >= noOfPhoto)
        {
            NSString *str =[NSString stringWithFormat:@"Please Choose Photo."];
            NSMutableDictionary* dictMsg = [NSMutableDictionary dictionaryWithDictionary: nil];
            [dictMsg setObject:str forKey:kPopupMessage];
            [Popup popUpWithMessage: dictMsg delegate:self withType:nil];
        }
        else
        {
            allValidationDone=(BOOL *) YES;
        }
    }
}

- (void)sendRequests {  
    
    NSString *user_auth_token =[[SettingsManager gameSettings]getUserAuthentication];
    
//    NSLog(@"%@",strTitle);
//    NSLog(@"%@",strDesc);
//    NSLog(@"%@",strTags);
//    NSLog(@"%@",collection_id);
//    NSLog(@"%d",noOfPhoto);
//    NSLog(@"%@",[imageArr description]);
    
    NSString *Str = [NSString stringWithFormat:@"/items.json?auth_token=%@&title=%@&description=%@&tag_list=%@&collection_id=%@&photos=%@&photo_count=%d",user_auth_token,strTitle,strDesc,strTags,collection_id,imageArr,noOfPhoto];
    
    [[RKClient sharedClient] post:Str params:nil delegate:self];
    
} 


- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{    
    
    if ([request isGET]) 
    { 
        if ([response isOK]) 
        {  
            
        }  
        
    } 
    else if ([request isPOST]) 
    {  
        if ([response isJSON]) 
        {  
            NSLog(@"Retrieved XML: %@", [response bodyAsString]); 
            [self.navigationController popViewControllerAnimated:YES];
        }  
    } 
    else if ([request isDELETE]) 
    {  
        if ([response isNotFound]) 
        {  
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);  
        }  
        
    }  
    [self.messagePopUp hide];
}  

#pragma mark -
#pragma mark Table View Methods
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSLog(@"IN TABLE SECTION");
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"IN TABLE ITEM COUNT");
    return 4;
}

NSIndexPath* tempIndexPath;
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *CellIdentifier = @"Cell";
    
	NSLog(@"IN TABLE ADDING A CELL");
	
	CellNewItem *cell = (CellNewItem*)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		
		cell = [[[CellNewItem alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
    }
	tempIndexPath=indexPath;
	cell.textField.delegate=self;
	cell.textField.tag=indexPath.row;
	cell.textField.textColor=[UIColor whiteColor];
	if (indexPath.row==0) 
	{
		cell.label.text=@"Title:";
		cell.label.backgroundColor = [UIColor clearColor];
		cell.label.textColor = [UIColor colorWithRed:200/255.0f green:221/255.0f blue:239/255.0f alpha:1.0]; 
		
	}
	else if(indexPath.row==1) 
	{
		cell.label.text=@"Photos";
		cell.label.backgroundColor = [UIColor clearColor];
		cell.label.textColor = [UIColor colorWithRed:200/255.0f green:221/255.0f blue:239/255.0f alpha:1.0];
		cell.textField.hidden=YES;
		cell.btnImage1.hidden=NO;
		cell.btnImage2.hidden=NO;
		cell.btnImage3.hidden=NO;
		cell.btnImage4.hidden=NO;
		
		//UIImage *selectedImage;
		
		switch (noOfPhoto) {
			case 1:
				[cell.btnImage1 setBackgroundImage:imageSelected.image forState:UIControlStateNormal];
				UIImage *selectedImage1 = imageSelected.image;
				[selectedImageArray addObject:selectedImage1];
				[selectedImage1 release];
                
                 NSData *imgData1 = UIImagePNGRepresentation([selectedImageArray objectAtIndex:0]);
                 base64str1=[Base64 encode:imgData1];
                CFStringRef newString1 = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)base64str1, NULL, CFSTR("!*'();:@&=+@,/?#[]"), kCFStringEncodingUTF8);
                
                [imageArr addObject:(NSString *)newString1];
                
				break;
			case 2:
				[cell.btnImage2 setBackgroundImage:imageSelected.image forState:UIControlStateNormal];
				UIImage *selectedImage2 = imageSelected.image;
				[selectedImageArray addObject:selectedImage2];
				[selectedImage2 release];
                
                NSData *imgData2 = UIImagePNGRepresentation([selectedImageArray objectAtIndex:1]);
                base64str2=[Base64 encode:imgData2];
                CFStringRef newString2 = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)base64str2, NULL, CFSTR("!*'();:@&=+@,/?#[]"), kCFStringEncodingUTF8);
                
                [imageArr addObject:(NSString *)newString2];
                
                
				break;
			case 3:
				[cell.btnImage3 setBackgroundImage:imageSelected.image forState:UIControlStateNormal];
				UIImage *selectedImage3 = imageSelected.image;
				[selectedImageArray addObject:selectedImage3];
				[selectedImage3 release];
                
                NSData *imgData3 = UIImagePNGRepresentation([selectedImageArray objectAtIndex:2]);
                base64str3=[Base64 encode:imgData3];
                CFStringRef newString3 = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)base64str3, NULL, CFSTR("!*'();:@&=+@,/?#[]"), kCFStringEncodingUTF8);
                
                [imageArr addObject:(NSString *)newString3];
                
				break;
			case 4:
				[cell.btnImage4 setBackgroundImage:imageSelected.image forState:UIControlStateNormal];
				UIImage *selectedImage4 = imageSelected.image;
				[selectedImageArray addObject:selectedImage4];
				[selectedImage4 release];
                
                NSData *imgData4 = UIImagePNGRepresentation([selectedImageArray objectAtIndex:3]);
                base64str4=[Base64 encode:imgData4];
                CFStringRef newString4 = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)base64str4, NULL, CFSTR("!*'();:@&=+@,/?#[]"), kCFStringEncodingUTF8);
                
                [imageArr addObject:(NSString *)newString4];
                
				break;
			default:
				break;
		}
		if(noOfPhoto<4)
		{
			cell.btnAccesory.hidden=NO;
		}
        else
        {
            cell.btnAccesory.hidden=YES;
        }
		[cell.btnAccesory addTarget:self action:@selector(ChoosePhotos) forControlEvents:UIControlEventTouchUpInside];
		
		NSLog(@"Array count :- %d", [selectedImageArray count]);
		
	}
	else if(indexPath.row==2) 
	{
		cell.label.text=@"Collections";
		cell.label.backgroundColor = [UIColor clearColor];
		cell.label.textColor = [UIColor colorWithRed:200/255.0f green:221/255.0f blue:239/255.0f alpha:1.0];
		cell.textField.text=selectedCollection;
		cell.textField.userInteractionEnabled=NO;
		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	}
	else if(indexPath.row==3) 
	{
		cell.label.text=@"Tags:";
		cell.label.backgroundColor = [UIColor clearColor];
		cell.label.textColor = [UIColor colorWithRed:200/255.0f green:221/255.0f blue:239/255.0f alpha:1.0];
	}
	
	
	
    
    return cell;
}


- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView1 deselectRowAtIndexPath:indexPath animated:YES];
	if(indexPath.row==2)
	{
		CollectionListViewController *objCollectionListViewController=[[CollectionListViewController alloc]initWithNibName:@"CollectionListViewController" bundle:nil];
		objCollectionListViewController.objNewItemViewController=self;
		[self.navigationController pushViewController:objCollectionListViewController animated:YES];
		[objCollectionListViewController release];
	}
	
}
#pragma mark Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	selectedTextField=textField;
	if(textField.tag==0)
	{
		self.strTitle=@"";
	}
	else if(textField.tag==3)
	{
		self.strTags=@"";
	}
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if(textField.tag==0)
	{
		self.strTitle=textField.text;
	}
	else if(textField.tag==3)
	{
		self.strTags=textField.text;
	}
	[textField resignFirstResponder];
}


- (void)textViewDidBeginEditing:(UITextView *)textView1
{
	
	if ([textView.text isEqualToString:@"Tap here to enter Details"]) {
		textView.text=@"";
	}
	tableView.frame=CGRectMake(0, 0, 320, 200);
	[tableView scrollToRowAtIndexPath:tempIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView1
{
	tableView.frame=CGRectMake(0, 0, 320, 460);
	[tableView scrollToRowAtIndexPath:tempIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	
	if([textView1.text isEqualToString:@""])
	{
		textView1.text = @"Tap here to enter Details";
		textView1.textColor = [UIColor colorWithRed:200/255.0f green:221/255.0f blue:239/255.0f alpha:1.0];
		[textView1 setFont:[UIFont boldSystemFontOfSize:15.0]];
	}
	
	if([textView1.text isEqualToString:@"Tap here to enter Details"])
	{
		self.strDesc = @"";
	}
	else 
	{
		self.strDesc = [[NSString stringWithFormat:@"%@", textView1.text] retain];
	}
    
}

-(BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text 
{ 
	if([text isEqualToString:@"\n"]) 
		[txtView resignFirstResponder]; 
	
	return YES; 
}

#pragma mark User Defined Methods

- (IBAction) ChoosePhotos {
	[selectedTextField resignFirstResponder];
	NSLog(@"In Choose Photos...............");
//	PhotoViewController *photoViewController = [[PhotoViewController alloc] init]; 
//	photoViewController.objNewItemViewController=self;
//	[self.navigationController pushViewController:photoViewController animated:YES];
//    [photoViewController release];
    
    
    UIActionSheet *photoSourceActionSheet;
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
	{ 
		NSLog(@"No camera!");
		photoSourceActionSheet= [[UIActionSheet alloc]
								 initWithTitle:nil
								 delegate:self
								 cancelButtonTitle:@"Cancel"
								 destructiveButtonTitle:nil
								 otherButtonTitles: @"Photo Library", nil];
	}
	else
	{
        
		photoSourceActionSheet= [[UIActionSheet alloc]
                                 initWithTitle:nil
                                 delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles: @"Camera",@"Photo Library", nil];
	}
	photoSourceActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[photoSourceActionSheet showInView:self.view];

}

-(void)getCameraPicture
{
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController: picker animated:YES];
	[picker release];
    
}

-(void)selectExitingPicture
{
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
		UIImagePickerController *picker= [[UIImagePickerController alloc]init];
		picker.delegate = self;
		picker.allowsEditing = YES;
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}
}


#pragma mark UIActionSheetDelegate Methods


- (void)actionSheet:(UIActionSheet *)anActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [anActionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
	if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		buttonIndex+=1;
	}
    if (buttonIndex == [anActionSheet cancelButtonIndex]) {
		
    }
	
    if (buttonIndex == 0) {
		NSLog(@"Camera selected.............");
        [self getCameraPicture];
        
    } else if (buttonIndex == 1) {
        [self selectExitingPicture];
		NSLog(@"Photo Library selected...........");
		
	}
	else {
		//[self.navigationController popViewControllerAnimated:NO];
        [anActionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
	}
    
}


- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    // Do nothing.  Overriding default of simulating clicking cancel, when user hits home button.
	//[self.navigationController popViewControllerAnimated:YES];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

//-(void)imagePickerController:(UIImagePickerController *)picker
//	  didFinishPickingImage : (UIImage *)image
//				 editingInfo:(NSDictionary *)editingInfo
//{
////	imageView.image = image;
////	objNewItemViewController.imageSelected=[imageView retain];
////    objNewItemViewController.noOfPhoto++;
////	NSLog(@"Number of Photos: %d",objNewItemViewController.noOfPhoto);
//    
//    UIImage *cImage = [editingInfo objectForKey:@"UIImagePickerControllerEditedImage"];
//    
//    imageSelected.image=[cImage retain];
//    noOfPhoto++;
//	[picker dismissModalViewControllerAnimated:YES];
//    
//    //[tableView reloadData];
//	
//}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    UIImage *cImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImageView *imgView=[[UIImageView alloc]initWithImage:cImage];
    imageSelected=[imgView retain];
    [imgView release];
    noOfPhoto++;
    [tableView reloadData];
    [picker dismissModalViewControllerAnimated:YES];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
	[picker dismissModalViewControllerAnimated:YES];
}



#pragma mark insert item into database

-(void)insertItem
{
	appDelegate = (displaycaseAppDelegate *)[[UIApplication sharedApplication] delegate];
	database = appDelegate.database;
    
	NSLog(@"Image array :- %@", [selectedImageArray description]);
	
	if(insertStmt == nil) 
	{
		const char *sql = "insert into items(title, collection_id, tags, description, photo_1, photo_2, photo_3, photo_4) values(?,?,?,?,?,?,?,?)";
		//const char *sql = "update Coffee Set CoffeeName = ?, Price = ?, CoffeeImage = ? Where CoffeeID = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &insertStmt, NULL) != SQLITE_OK)
		{
			NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
            
		}
	}
	
	if([self.strTitle isEqualToString:@""])
	{
		self.strTitle = [self.strTitle retain];
	}
	sqlite3_bind_text(insertStmt, 1, [self.strTitle UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(insertStmt, 2, intCollections);
	if([self.strTags isEqualToString:@""])
	{
		self.strTags = [self.strTags retain];
	}
	sqlite3_bind_text(insertStmt, 3, [self.strTags UTF8String], -1, SQLITE_TRANSIENT);
	//NSLog(@"textValue :- %@",[strDesc retain]);
	if([self.strDesc isEqualToString:@""])
	{
		self.strDesc = [self.strDesc retain];
	}
	
	
	sqlite3_bind_text(insertStmt, 4, [self.strDesc UTF8String], -1, SQLITE_TRANSIENT);
	
	/*NSData *imgData = UIImagePNGRepresentation(imageSelected.image);
     
     if(imageSelected.image != nil)
     sqlite3_bind_blob(insertStmt, 5, [imgData bytes], [imgData length], NULL);
     else
     sqlite3_bind_blob(insertStmt, 5, nil, -1, NULL);
     
     */
	/*NSLog(@"count %d", [selectedImageArray count] );
     
     for(int i = 0; i<4; i++)
     {
     NSData *imgData = UIImagePNGRepresentation([selectedImageArray objectAtIndex:i]);
     
     if([selectedImageArray objectAtIndex:i] != nil)
     sqlite3_bind_blob(insertStmt, i+5, [imgData bytes], [imgData length], NULL);
     else
     sqlite3_bind_blob(insertStmt, i+5, nil, -1, NULL);
     
     [imgData release];
     
     }*/
	
	NSData *imgData1 = UIImagePNGRepresentation([selectedImageArray objectAtIndex:0]);
	
	if([selectedImageArray objectAtIndex:0] != nil)
		sqlite3_bind_blob(insertStmt, 5, [imgData1 bytes], [imgData1 length], NULL);
	else
		sqlite3_bind_blob(insertStmt, 5, nil, -1, NULL);
	
	NSData *imgData2 = UIImagePNGRepresentation([selectedImageArray objectAtIndex:1]);
	
	if([selectedImageArray objectAtIndex:1] != nil)
		sqlite3_bind_blob(insertStmt, 6, [imgData2 bytes], [imgData2 length], NULL);
	else
		sqlite3_bind_blob(insertStmt, 6, nil, -1, NULL);
	
	NSData *imgData3 = UIImagePNGRepresentation([selectedImageArray objectAtIndex:2]);
	
	if([selectedImageArray objectAtIndex:2] != nil)
		sqlite3_bind_blob(insertStmt, 7, [imgData3 bytes], [imgData3 length], NULL);
	else
		sqlite3_bind_blob(insertStmt, 7, nil, -1, NULL);
	
//	NSData *imgData4 = UIImagePNGRepresentation([selectedImageArray objectAtIndex:3]);
//	
//	if([selectedImageArray objectAtIndex:3] != nil)
//		sqlite3_bind_blob(insertStmt, 8, [imgData4 bytes], [imgData4 length], NULL);
//	else
//		sqlite3_bind_blob(insertStmt, 8, nil, -1, NULL);
    
	if(SQLITE_DONE != sqlite3_step(insertStmt))
		NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(insertStmt);
	
	
    
	
}

#pragma mark Memory Methods

-(void)viewWillDisappear:(BOOL)animated
{
    [selectedTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[strTags release];
	[strTitle release];
	[strDesc release];
	[imageSelected release];
	[selectedImageArray release];
	
    [super dealloc];
}




@end
