//
//  CellNewItem.m
//  displaycase
//
//  Created by Nikhil Patel on 11/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CellNewItem.h"


@implementation CellNewItem
@synthesize label,textField,btnImage1,btnImage2,btnImage3,btnImage4,btnAccesory;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		
		// Initialization code
		
		label = [[UILabel alloc]init];
		label.textAlignment = UITextAlignmentLeft;
		label.font = [UIFont boldSystemFontOfSize:15];
		
		textField=[[UITextField alloc]init];
		textField.font=[UIFont systemFontOfSize:13];
		textField.autocorrectionType=UITextAutocorrectionTypeNo;
		textField.textAlignment=UITextAlignmentLeft;
		textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		
		btnImage1 = [UIButton buttonWithType:UIButtonTypeCustom]; btnImage1.tag=1;
		btnImage2 = [UIButton buttonWithType:UIButtonTypeCustom];btnImage2.tag=2;
		btnImage3 = [UIButton buttonWithType:UIButtonTypeCustom];btnImage3.tag=3;
		btnImage4 = [UIButton buttonWithType:UIButtonTypeCustom];btnImage4.tag=4;
		btnAccesory= [UIButton buttonWithType:UIButtonTypeContactAdd];
		
		btnImage1.hidden=YES;
		btnImage2.hidden=YES;
		btnImage3.hidden=YES;
		btnImage4.hidden=YES;
		btnAccesory.hidden=YES;
		
		[self.contentView addSubview:label];
		
		[self.contentView addSubview:textField];
		
		[self.contentView addSubview:btnImage1];
		[self.contentView addSubview:btnImage2];
		[self.contentView addSubview:btnImage3];
		[self.contentView addSubview:btnImage4];
		[self.contentView addSubview:btnAccesory];
		
		
		[label release];
		[textField release];
				
	}
	
	return self;
	
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
    label.frame=CGRectMake(5, 12,85, 21);
	
	textField.frame=CGRectMake(89, 1, 232, 44);	
	int x=80;
	int y=2;
	int width=40;
	int height=40;
	int gap=10;
	btnImage1.frame=CGRectMake(x, y, width,height);
	x+=width+gap;
	btnImage2.frame=CGRectMake(x, y, width,height);
	x+=width+gap;
	btnImage3.frame=CGRectMake(x, y, width,height);
	x+=width+gap;
	btnImage4.frame=CGRectMake(x, y, width,height);
	btnAccesory.frame=CGRectMake(290, 0, 30, 44);	
	
	
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
	
}

@end