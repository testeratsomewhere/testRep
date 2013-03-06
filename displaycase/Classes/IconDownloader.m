//  IconDownloader.h
//  SmartDate
//  Created by Ashwin Jumani on 26/01/11.
//   Copyright 2010, 2011 VisionSync Inc.   All Rights Reserved
//   Revision History:
//       2011-02-24:  Initial v1.0 Submit to apple
//       2011-02-26:  Cleanup by Ash
//   Purpose:
// Define Icon Downloader Delegate and Class.
//This class is used for downloading images of user


#import "IconDownloader.h"
#import "Constants.h"

#define kAppIconHeight 48


@implementation IconDownloader

@synthesize appRecord;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;

#pragma mark

- (void)dealloc
{
    [appRecord release];
    [indexPathInTableView release];
    
    [activeDownload release];
    
    [imageConnection cancel];
    [imageConnection release];
    
    [super dealloc];
}

- (void)startDownload
{
	appRecord.StrimageURL = [appRecord.StrimageURL stringByAppendingString:@"-thumbnail"];
    self.activeDownload = [NSMutableData data];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:appRecord.StrimageURL]] delegate:self];
    self.imageConnection = conn;
    [conn release];
}

- (void)cancelDownload
{
	self.delegate = nil;
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

	UIImage *image;
    
	//detect retina
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
		// Set appIcon and clear temporary data/image
		image = [[UIImage alloc] initWithCGImage:[[UIImage imageWithData:self.activeDownload] CGImage] 
													scale:2.0 orientation:UIImageOrientationUp];
	} else {
		image = [[UIImage alloc] initWithData:self.activeDownload];
	}
    	
    if (image.size.width != kAppIconHeight && image.size.height != kAppIconHeight)
	{
        CGSize itemSize = CGSizeMake(kAppIconHeight, kAppIconHeight);
//		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
        self.appRecord.StrappIcon = image;
//		self.appRecord.StrappIcon = UIGraphicsGetImageFromCurrentImageContext();
//		UIGraphicsEndImageContext();
        
        //ABOVE CODE IS COMMENTED BECAUSE OF BLURRED IMAGE OUTPUT IN THE FAVORITEVIEW === TARAK PAREKH
    }
    else
    {
        self.appRecord.StrappIcon = image;
    }
    
    self.activeDownload = nil;
    [image release];
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
	
	if (self.delegate) 
	{
		[self.delegate appImageDidLoad:self.indexPathInTableView];
	}
    
}

@end

