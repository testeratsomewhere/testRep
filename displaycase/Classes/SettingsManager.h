//  SettingsManager.h
//  Created by Renuka Shah on 22/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.



@interface SettingsManager : NSObject {
	NSUserDefaults *prefs;
}
+ (SettingsManager *) gameSettings;




-(void) saveAuthenticationToken: (NSString *) UserAuthentication_Token;
-(NSString *) getUserAuthentication;


@end
