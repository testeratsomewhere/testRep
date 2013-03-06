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


@protocol IconDownloaderDelegate;

#import "AppRecord.h"

@interface IconDownloader : NSObject
{
    AppRecord *appRecord;
    NSIndexPath *indexPathInTableView;
    id <IconDownloaderDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) AppRecord *appRecord;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <IconDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol IconDownloaderDelegate 

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end