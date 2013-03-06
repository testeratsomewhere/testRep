//
//  AsyncImageView.m
//  ImageURL
//
//  Created by Apple on 17/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.


#import "AsyncImageView.h"

@implementation AsyncImageView

- (void)loadImageFromURL:(NSURL*)url 
{
	
	activity=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(15, 20, 30, 30)];
	[activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[activity startAnimating];
	[self addSubview:activity];
	
    if (connection!=nil) 
		[connection release]; 

    if (data!=nil) 
		[data release]; 
	
    NSURLRequest* request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
																				timeoutInterval:60.0];

    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData 
{
    
	if (data==nil) 
	{
		data =
		[[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection 
{
	
    [connection release];
    connection=nil;
	
    if ([[self subviews] count]>0) 
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
	
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageWithData:data]] autorelease];
    imageView.contentMode = UIViewContentModeScaleToFill;
	
	[activity stopAnimating];
	[activity hidesWhenStopped];
    [self addSubview:imageView];
    imageView.frame = self.bounds;
    [imageView setNeedsLayout];
    [self setNeedsLayout];
    [data release];
    data=nil;
	
}

- (UIImage*) image 
{
    UIImageView *iv = [[self subviews] objectAtIndex:0];
    return [iv image];
}

- (void)dealloc 
{
    [connection cancel];
    [connection release];
    [data release];
    [super dealloc];
}



@end
