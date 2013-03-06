//
//  displaycaseAppDelegate.h
//  displaycase
//
//  Created by Nikhil Patel on 17/01/11.
//  Copyright 2011 Complitech Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "CollectionsViewController.h"
#import "ActivityViewController.h"
#import "SearchViewController.h"
#import "SettingsViewController.h"
#import "LoginView.h"


#import <RestKit/RestKit.h>

@class Reachability;
@class CollectionViewController;
@interface displaycaseAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	UIImageView *imgTab ,*imgDisplay, *imgActivity, *imgSearch, *imgSettings;
    UINavigationController *navigationController;
	UITabBarController *tabBarController;
	sqlite3 *database;
	NSMutableArray *collections_Array;
    
    //Rechability data memeber
    Reachability* internetReachable;
    BOOL *isReachable;
    int collectionFlag;
    
}
@property (nonatomic, assign) BOOL *isReachable;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSMutableArray *collections_Array;
@property (nonatomic) sqlite3 *database;
@property (nonatomic, readwrite) int collectionFlag;

-(void)createDirectoryNamed:(NSString*)nameOfDirectory;
- (void)initializeCollections;

-(void)TabbarMakeVisible;

- (void) checkNetworkStatus:(NSNotification *)notice;
- (BOOL *) returnInternetActive;

@end

