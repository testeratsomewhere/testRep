//
//  collection.m
//  displaycase
//
//  Created by Nikhil Patel on 25/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Collection.h"
#import "Item.h"
#import "displaycaseAppDelegate.h"

static sqlite3_stmt *init_statement = nil;
//static sqlite3 *database = nil;
//static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *addStmt = nil;

@implementation Collection


@synthesize primaryKey, name, items;

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db {
	
	if (self == [super init]) {
        primaryKey = pk;
        database = db;
        // Compile the query for retrieving collection data. See insertNewCollectionIntoDatabase: for more detail.
        if (init_statement == nil) {
            // Note the '?' at the end of the query. This is a parameter which can be replaced by a bound variable.
            // This is a great way to optimize because frequently used queries can be compiled once, then with each
            // use new variable values can be bound to placeholders.
            //const char *sql = "SELECT name FROM collections where pk=?";
            const char *sql = "SELECT * FROM collections left outer join items on collections.pk = items.collection_id WHERE collections.pk=? ";
			
            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
        // For this query, we bind the primary key to the first (and only) placeholder in the statement.
        // Note that the parameters are numbered from 1, not from 0.
        sqlite3_bind_int(init_statement, 1, primaryKey);
        if (sqlite3_step(init_statement) == SQLITE_ROW) {
			char *collectionName = (char *)sqlite3_column_text(init_statement, 1);
			if (collectionName == NULL)
				self.name = @"";
			else
				self.name = [NSString stringWithUTF8String:collectionName];
        } else {
            self.name = @"No collections found";
        }
        // Reset the statement for future reuse.
        sqlite3_reset(init_statement);
    }
	
	// initializing items for current collection
	NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    self.items = itemsArray;
    [itemsArray release];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"displaycase.sqlite"];
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT * FROM items where collection_id = ?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            // We "step" through the results - once for each row.
			sqlite3_bind_int(statement, 1, pk);
			while (sqlite3_step(statement) == SQLITE_ROW) {
                // The second parameter indicates the column index into the result set.
                int itemPrimaryKey = sqlite3_column_int(statement, 0);
                // We avoid the alloc-init-autorelease pattern here because we are in a tight loop and
                // autorelease is slightly more expensive than release. This design choice has nothing to do with
                // actual memory management - at the end of this block of code, all the book objects allocated
                // here will be in memory regardless of whether we use autorelease or release, because they are
                // retained by the items array.
                Item *item = [[Item alloc] initWithPrimaryKey:itemPrimaryKey database:database];
                [items addObject:item];
			//	[itemsArray addObject:item];
                [item release];
            }
        }
		
		//self.items = itemsArray;
		NSLog(@"Item Array...............%@",items);
		//[itemsArray release];
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        // Additional error handling, as appropriate...
    }
	
	//NSLog(@"size:%@",(NSString *)[collections count]);
	
	
	
    return self;
}
-(int)addCollection:(NSString *)collectionName
{
	displaycaseAppDelegate *app = (displaycaseAppDelegate *)[[UIApplication sharedApplication] delegate];
	database = app.database;

	int collectionID;
	//TODO: save the collection to local database and call API to save collection
	if(addStmt == nil) 
	{
		const char *sql = "insert into collections(name) values(?)";
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK) 
		{
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_text(addStmt, 1, [collectionName UTF8String], -1, SQLITE_TRANSIENT);
	
	if(SQLITE_DONE != sqlite3_step(addStmt)) 
	{
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	}
	else 
	{
		//SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
		collectionID = sqlite3_last_insert_rowid(database);
	}
	
	//Reset the add statement.
	sqlite3_reset(addStmt);
	// "Finalize" the statement - releases the resources associated with the statement.
	sqlite3_finalize(addStmt);

	
	return collectionID;
}
@end
