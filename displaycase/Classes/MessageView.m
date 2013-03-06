//  MessageView.m
//  RateMe
//  Created by Nikhil Patel on 25/03/11.
//  Copyright 2011 w. All rights reserved.

#import "MessageView.h"


@implementation MessageView
@synthesize LblloaderText, activity,loaderHolder, ImgviewloaderBG; 


- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		
	}
    return self;
}


-(void)setup 
{	
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        
        self.frame = CGRectMake(0, -1024, 768, 1024);
        self.backgroundColor = [UIColor clearColor]; 
        self.loaderHolder.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.85];
        loaderHolder.frame = CGRectMake(0,0,176,50);
    }
    else
    {
        self.frame = CGRectMake(0, -480, 320, 480);
        self.backgroundColor = [UIColor clearColor]; 
        //self.loaderHolder.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.85];
        loaderHolder.frame = CGRectMake(0,0,176,50);
    }
    self.loaderHolder.layer.cornerRadius = 10;
    [[self.loaderHolder layer] setBorderWidth:2.0];
    [[self.loaderHolder layer] setBorderColor:[[UIColor grayColor] CGColor]];
}


-(void)setupWithUser:(NSString*)loaderBGcolor:(NSInteger)loaderBorder_width:(NSString*)loaderBorder_color
{
	
	SEL blackSel = NSSelectorFromString([NSString stringWithFormat:@"%@Color",loaderBGcolor]);
	UIColor* BGColor = nil;
	if ([UIColor respondsToSelector: blackSel])
		BGColor  = [UIColor performSelector:blackSel];
	
	SEL blackSel1 = NSSelectorFromString([NSString stringWithFormat:@"%@Color",loaderBorder_color]);
	UIColor* BorderColor = nil;
	if ([UIColor respondsToSelector: blackSel1])
		BorderColor  = [UIColor performSelector:blackSel1];
	
	
	
	self.frame = CGRectMake(0, -480,320, 480);
	self.backgroundColor = [UIColor clearColor]; 
	
	self.loaderHolder.backgroundColor = [BGColor colorWithAlphaComponent:.85];
	self.loaderHolder.frame = CGRectMake(0,-150,320,150);
	self.loaderHolder.layer.cornerRadius = 10;
	[[self.loaderHolder layer] setBorderWidth:loaderBorder_width];
	[[self.loaderHolder layer] setBorderColor:[BorderColor CGColor]];
	
	
}

-(void)show:(NSString *)loadingText 
{ 
	self.LblloaderText.text = loadingText; 
	self.LblloaderText.textColor = [UIColor blackColor];
	
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.frame = CGRectMake(296, 472, 768, 1024);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            loaderHolder.frame = CGRectMake(0,0,176,60);
            [UIView commitAnimations];
        }
        else
        {
            self.frame = CGRectMake(72, 205, 320, 480);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            loaderHolder.frame = CGRectMake(0,0,176,50);
            [UIView commitAnimations];
        }
	
}

-(void)showMessage:(NSString *)loadingText:(NSString *)textColor
{
	
	SEL blackSel1 = NSSelectorFromString([NSString stringWithFormat:@"%@Color",textColor]);
	UIColor* tcolor = nil;
	if ([UIColor respondsToSelector: blackSel1])
		tcolor  = [UIColor performSelector:blackSel1];
	
	self.LblloaderText.text = loadingText; 
	self.LblloaderText.textColor = tcolor;
	
	
	self.frame = CGRectMake(72, 205, 320, 480);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	loaderHolder.frame = CGRectMake(0,0,176,50);
	[UIView commitAnimations];
}


-(void)updateText:(NSString *)newText {
	self.LblloaderText.text = newText; 
}


-(void)hide 
{ 
	[self.loaderHolder setHidden:YES];
	
 	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideComplete)]; 
	
	
	loaderHolder.frame = CGRectMake(0,-150,320,150);
		
	[UIView commitAnimations]; 
    
}



-(void)hideComplete 
{
    self.frame = CGRectMake(0,-480, 320, 480);
}


- (void)dealloc {
    [super dealloc];
	[LblloaderText release]; 
	[ImgviewloaderBG release]; 
	[loaderHolder release]; 
	[activity release]; 
}


@end
