//
//  MessageView.h
//  RateMe
//
//  Created by Nikhil Patel on 25/03/11.
//  Copyright 2011 w. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface MessageView : UIView 
{
	UILabel *LblloaderText; 
	UIView *loaderHolder; 
	UIImageView *ImgviewloaderBG; 
    UIActivityIndicatorView *activity;
}

@property(nonatomic,retain) IBOutlet UIView *loaderHolder; 
@property(nonatomic,retain) IBOutlet UILabel *LblloaderText; 
@property(nonatomic,retain) IBOutlet UIImageView *ImgviewloaderBG; 
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activity; 

-(void)setup;
-(void)show:(NSString *)loadingText; 
-(void)setupWithUser:(NSString*)loaderBGcolor:(NSInteger)loaderBorder_width:(NSString*)loaderBorder_color;
-(void)showMessage:(NSString *)loadingText:(NSString *)textColor;
-(void)updateText:(NSString *)newText; 
-(void)hide; 
-(void)hideComplete; 

@end