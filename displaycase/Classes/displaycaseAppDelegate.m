//
//  displaycaseAppDelegate.m
//  displaycase
//
//  Created by Nikhil Patel on 17/01/11.
//  Copyright 2011 Complitech Solutions Pvt. Ltd. All rights reserved.
//


#import "displaycaseAppDelegate.h"
#import "Collection.h"
#import "Reachability.h"
#import "CollectionViewController.h"

@interface displaycaseAppDelegate (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
@end


@implementation displaycaseAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize navigationController;

@synthesize collections_Array, database;

@synthesize isReachable;
@synthesize collectionFlag;

- (id)init {
	if (self == [super init]) {
	}
	return self;
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
      
    RKClient* client = [RKClient clientWithBaseURL:@"http://192.168.1.200:3004"];
    
    NSLog(@"%@",client);
    
    // Override point for customization after application launch.
	//[self createEditableCopyOfDatabaseIfNeeded];
    
    //LoginView *login=[[LoginView alloc]init];
	//[self.window addSubview:login.view];
    
    
    
    
    
   
    
    //| RR
    
    
    
    [self.window addSubview:navigationController.view];
    
    collectionFlag = 0;
    
    // Add the tab bar controller's view to the window and display.
	//[self.window addSubview:tabBarController.view];
    
    [self.window makeKeyAndVisible];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [internetReachable startNotifier];
    return YES;
}


-(void)TabbarMakeVisible{
    //two thing hide navigation controller if use it in future or
    // remove from window if no use in feature
   // navigationController.view.hidden=YES;
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
}


// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"displaycase.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"displaycase.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

// Open the database connection and retrieve minimal information for all objects.
- (void)initializeCollections {
    NSMutableArray *collectionsArray = [[NSMutableArray alloc] init];
    self.collections_Array = collectionsArray;
    [collectionsArray release];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"displaycase.sqlite"];
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT * FROM collections";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            // We "step" through the results - once for each row.
            while (sqlite3_step(statement) == SQLITE_ROW) {
                // The second parameter indicates the column index into the result set.
                int primaryKey = sqlite3_column_int(statement, 0);
                // We avoid the alloc-init-autorelease pattern here because we are in a tight loop and
                // autorelease is slightly more expensive than release. This design choice has nothing to do with
                // actual memory management - at the end of this block of code, all the book objects allocated
                // here will be in memory regardless of whether we use autorelease or release, because they are
                // retained by the collections array.
                Collection *coll = [[Collection alloc] initWithPrimaryKey:primaryKey database:database];
                [collections_Array addObject:coll];
                [coll release];
            }
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        // Additional error handling, as appropriate...
    }
	
	//NSLog(@"size:%@",(NSString *)[collections count]);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Internet Connection


- (void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.isReachable = NO;
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.isReachable = (BOOL *) YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.isReachable = (BOOL *) YES;
            
            break;
            
        }
    }
    
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
    //[tabBarController release];
    [window release];
    [super dealloc];
}
-(void)createDirectoryNamed:(NSString*)nameOfDirectory
{
	 NSString*root=@"";
	NSString *rootString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
	root=[rootString stringByAppendingPathComponent:nameOfDirectory];
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:root isDirectory:YES] == NO)
    {
        [fileManager createDirectoryAtPath:root attributes:nil];
    }
	
}
@end

