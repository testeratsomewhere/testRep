//
//  GrayPageControl.m
//  pageControlSample
//
//  Created by Nikhil Patel on 08/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GrayPageControl.h"


@implementation GrayPageControl


#pragma mark Added methods

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
	
    activeImage = [[UIImage imageNamed:@"item_image_pagination_on.png"] retain];
    inactiveImage = [[UIImage imageNamed:@"item_image_pagination_off.png"] retain];
	
    return self;
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) 
			dot.image = activeImage;
        else 
			dot.image = inactiveImage;
    }
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

- (void)dealloc 
{
    [super dealloc];
}


@end
