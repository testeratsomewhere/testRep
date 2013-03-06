//
//  AsyncImageView.h
//  ImageURL
//
//  Created by Apple on 17/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>

@interface AsyncImageView : UIView 
{
	NSURLConnection* connection;
    NSMutableData* data;
	UIActivityIndicatorView *activity;
}

- (void)loadImageFromURL:(NSURL*)url;

@end