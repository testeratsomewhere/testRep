//  AppRecord.h
//  SmartDate
//  Created by Ashwin Jumani on 26/01/11.
//   Copyright 2010, 2011 VisionSync Inc.   All Rights Reserved
//   Revision History:
//       2011-02-24:  Initial v1.0 Submit to apple
//       2011-02-26:  Cleanup by Ash
//   Purpose:
// Define App DownloaderClass.
//This class is used for downloading images of user

@interface AppRecord : NSObject
{
    NSString *StrappName;
    UIImage *StrappIcon;
    NSString *StrimageURL;
}

@property (nonatomic, retain) NSString *StrappName;
@property (nonatomic, retain) UIImage *StrappIcon;
@property (nonatomic, retain) NSString *StrimageURL;

@end