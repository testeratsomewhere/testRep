//
//  Configfile.h
//  displaycase
//
//  Created by Dipak Baraiya on 15/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAPISignUp @"/accounts.json"
#define kAPIForgotPassword @"/accounts/password"
#define kAPIGetCollection @"/collections.json"
#define kAPIPostColletion @"/collections.json"
#define kAPISearch @"/search.json"
#define kAPIGetItemDetail @"/items/"
#define kAPIGetCollectionBycollectionId @"/collections/"


@interface Configfile : NSObject {
    
}

@end
