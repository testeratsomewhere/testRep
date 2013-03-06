//
//  Item.h
//  displaycase
//
//  Created by Nikhil Patel on 17/01/11.
//  Copyright 2011 Complitech Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Item : NSObject {
	NSInteger primaryKey;
	NSString *title;
	NSInteger collection_id;
	UIImage *photo_1;
	NSString *description;
	NSMutableArray *tags;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (nonatomic, retain) NSString *title;
@property (assign, nonatomic, readonly) NSInteger collection_id;
@property (nonatomic, retain) UIImage *photo_1;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSMutableArray *tags;


- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;


@end
