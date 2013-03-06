//
//  Item.m
//  displaycase
//
//  Created by Nikhil Patel on 17/01/11.
//  Copyright 2011 Complitech Solutions Pvt. Ltd. All rights reserved.
//

#import "Item.h"
#import <sqlite3.h>

static sqlite3_stmt *init_statement = nil;

@implementation Item

@synthesize primaryKey, title, collection_id, photo_1, description, tags;

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db {
	
	if (self ==[super init]) {
        primaryKey = pk;
		sqlite3 *database;
        database = db;
        // Compile the query for retrieving collection data. See insertNewItemIntoDatabase: for more detail.
        if (init_statement == nil) {
            // Note the '?' at the end of the query. This is a parameter which can be replaced by a bound variable.
            // This is a great way to optimize because frequently used queries can be compiled once, then with each
            // use new variable values can be bound to placeholders.
            const char *sql = "SELECT * FROM items WHERE pk=? ";
			
            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
        // For this query, we bind the primary key to the first (and only) placeholder in the statement.
        // Note that the parameters are numbered from 1, not from 0.
        sqlite3_bind_int(init_statement, 1, primaryKey);
      
	   
		if (sqlite3_step(init_statement) == SQLITE_ROW) {
			//TODO set all item attributes here with data from database
            self.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 1)];
		
			} else {
            self.title = @"No items found";
        }
		
	    // Reset the statement for future reuse.
        sqlite3_reset(init_statement);
    }
    return self;
}

-(BOOL)UpdateORInsertDataInItems:(NSMutableDictionary*)objDic :(NSInteger)pk
{
	NSString* TABLE_NAME=@"items";
	sqlite3 *database;
	database = (sqlite3 *)@"displaycase.sqlite";
	NSString* PrimaryKey=[NSString stringWithFormat:@"%d",pk];
    NSAutoreleasePool* pool=[[NSAutoreleasePool alloc]init];
	
    NSString* SQLColumns=@"";   
    NSString* SQLValues=@"";
    NSString* SQL=@"";
	
    //Chekc Wheather Insert or update?
    BOOL IsNew=NO;;
    if([[objDic valueForKey:PrimaryKey] intValue]==0)
    {
        IsNew=YES;
    }
	
    NSArray* Keys=[objDic allKeys];
	
    if(IsNew)
    {
        for(int i=0;i<Keys.count;i++)
        {
            if(![[Keys objectAtIndex:i] isEqual:PrimaryKey])
            {
                SQLColumns=[NSString stringWithFormat:@"%@%@,",SQLColumns,[Keys objectAtIndex:i]];
                SQLValues=[NSString stringWithFormat:@"%@?,",SQLValues];
            }
        }
		
        if([SQLColumns length]>0)
        {
            SQLColumns=[SQLColumns substringToIndex:[SQLColumns length]-1];
            SQLValues=[SQLValues substringToIndex:[SQLValues length]-1];
        }
		
        SQL=[NSString stringWithFormat:@"INSERT INTO %@ (%@) Values(%@)",TABLE_NAME,SQLColumns,SQLValues];
    }
    else
    {
        for(int i=0;i<Keys.count;i++)
        {
            if(![[Keys objectAtIndex:i] isEqual:PrimaryKey])
            {
                SQLColumns=[NSString stringWithFormat:@"%@%@=?,",SQLColumns,[Keys objectAtIndex:i]];
            }
        }
		
        if([SQLColumns length]>0)
        {
            SQLColumns=[SQLColumns substringToIndex:[SQLColumns length]-1];
        }
		
        SQL=[NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@=?",TABLE_NAME,SQLColumns,PrimaryKey];
    }
	
    sqlite3_stmt *insert_statement=nil; 
	
    if (sqlite3_prepare_v2(database, [SQL UTF8String], -1, &insert_statement, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }                
	
    int intBindIndex=1;
    for(int i=0;i<Keys.count;i++)
    {
        if(![[Keys objectAtIndex:i] isEqual:PrimaryKey])
        {
            sqlite3_bind_text(insert_statement,intBindIndex,[[objDic valueForKey:[Keys objectAtIndex:i]] UTF8String],-1, SQLITE_STATIC);
            intBindIndex++;
        }
    }
	
    if(!IsNew)
    {
        sqlite3_bind_text(insert_statement,Keys.count,[[objDic valueForKey:PrimaryKey] UTF8String],-1, SQLITE_STATIC);
    }
	
    int result;
    result=sqlite3_step(insert_statement);
	
    if(IsNew)
    {
        [objDic setObject:[NSString stringWithFormat:@"%d",sqlite3_last_insert_rowid(database)] forKey:PrimaryKey];     
    }
	
    sqlite3_finalize(insert_statement); 
	
    [pool release];
	
    if(result==SQLITE_DONE)
        return YES;
    else    
        return NO;
}



@end
