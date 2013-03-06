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


#import "AppRecord.h"
#import "Constants.h"
@implementation AppRecord

@synthesize StrappName;
@synthesize StrappIcon;
@synthesize StrimageURL;

- (void)dealloc
{
	DebugLog(@"App Record dealloc");
    [StrappName release];
    [StrappIcon release];
    [StrimageURL release];
    
    [super dealloc];
}

@end

