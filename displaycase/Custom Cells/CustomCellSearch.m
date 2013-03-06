//
//  CustomCellSearch.m
//  displaycase
//
//  Created by Dipak Baraiya on 26/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomCellSearch.h"


@implementation CustomCellSearch

@synthesize imgThumb;
@synthesize lblTitle;
@synthesize txtDesc;
@synthesize lblUserName;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
        
		imgThumb = [[UIImageView alloc] init];
		
		lblTitle = [[UILabel alloc]init];
		lblTitle.backgroundColor =[UIColor clearColor];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:13.5];
		lblTitle.font = [UIFont boldSystemFontOfSize:13.5];
		lblTitle.textColor = [UIColor blackColor];
		lblTitle.textAlignment = UITextAlignmentLeft;
		
		txtDesc = [[UITextView alloc]init];
		txtDesc.font = [UIFont fontWithName:@"Helvetica" size:12.5];
		txtDesc.textColor =[UIColor blackColor];
		txtDesc.editable=FALSE;
		txtDesc.scrollEnabled=FALSE;
		txtDesc.backgroundColor=[UIColor clearColor];
		txtDesc.textAlignment = UITextAlignmentLeft;
		txtDesc.userInteractionEnabled = NO;
        
		lblUserName = [[UILabel alloc]init];
		lblUserName.backgroundColor =[UIColor clearColor];
		lblUserName.font = [UIFont fontWithName:@"Helvetica" size:13.5];
		lblUserName.font = [UIFont boldSystemFontOfSize:13.5];
		lblUserName.textColor = [UIColor lightGrayColor];
		lblUserName.textAlignment = UITextAlignmentLeft;
		
		[self.contentView addSubview:imgThumb];
		[self.contentView addSubview:lblTitle];
		[self.contentView addSubview:txtDesc];
		[self.contentView addSubview:lblUserName];

    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;
	
	frame= CGRectMake(boundsX+5, 0, 90, 75);
	imgThumb.frame = frame;
	
	frame= CGRectMake(boundsX+105 ,5, 200, 20);
	lblTitle.frame = frame;
    
	frame= CGRectMake(boundsX+97, 20, 200, 40);
	txtDesc.frame = frame;
	
	frame = CGRectMake(boundsX+105, 60, 200, 20);
    lblUserName.frame = frame;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
