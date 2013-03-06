//
//  collection.h
//  displaycase
//
//  Created by Nikhil Patel on 25/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Collection : NSObject {
	sqlite3 *database;
	NSInteger primaryKey;
	NSString *name;
	NSMutableArray *items;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *items;

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;
- (int)addCollection:(NSString *) collectionName;
@end
