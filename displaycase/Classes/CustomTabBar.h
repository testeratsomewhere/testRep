//
//  RumexCustomTabBar.h
//  
//

#import <UIKit/UIKit.h>
#import "CollectionsViewController.h"
#import "displaycaseAppDelegate.h"

@interface CustomTabBar : UITabBarController <UITabBarControllerDelegate>
{
	UIButton *btnDisplays;
	UIButton *btnActivity;
	UIButton *btnSearch;
	UIButton *btnSettings;
	
	UIImageView *imgTab;
	
	UIImageView *imgBg;
	NSArray *navArray;
	NSArray *conArray;
	displaycaseAppDelegate *appDelegate;
	
	UIView *tabView;
    
    
}

@property (nonatomic, retain) UIButton *btnDisplays;
@property (nonatomic, retain) UIButton *btnActivity;
@property (nonatomic, retain) UIButton *btnSearch;
@property (nonatomic, retain) UIButton *btnSettings;
@property (nonatomic, retain) UIImageView *imgBg;
@property (nonatomic, retain) UIImageView *imgTab;
@property (nonatomic, retain) UIView *tabView;

-(void) hideTabBar;
-(void) showTabBar;
-(void) hideOriginalTabBar;
-(void) addCustomElements;
-(void) selectTab:(int)tabID;

@end
