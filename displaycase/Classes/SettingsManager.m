//  SettingsManager.m
//  Created by Renuka Shah on 22/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.

#import "SettingsManager.h"


@implementation SettingsManager
static SettingsManager *_gameSettings;

+ (SettingsManager *) gameSettings{
	
	if(!_gameSettings){
		
		_gameSettings = [[SettingsManager alloc] init];
	}
	return _gameSettings;
    
    
}

-(void) saveAuthenticationToken:(NSString *) UserAuthentication_Token
{
	prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:UserAuthentication_Token forKey:@"user_authentication_token"];
	[prefs synchronize];
}
-(NSString *) getUserAuthentication
{
	prefs=[NSUserDefaults standardUserDefaults];
	NSString *authenticationtoken = [prefs stringForKey:@"user_authentication_token"];
    
	if (!authenticationtoken) 
    {
		authenticationtoken=@"NULL";
	}
	return authenticationtoken;
}
@end
