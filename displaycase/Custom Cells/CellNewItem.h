//
//  CellNewItem.h
//  displaycase
//
//  Created by Nikhil Patel on 11/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CellNewItem : UITableViewCell {
		
	UILabel *label;

	UITextField* textField;
		
	UIButton *btnImage1,*btnImage2,*btnImage3,*btnImage4;
	UIButton *btnAccesory;
		
	}
	
	@property(nonatomic,retain)UILabel *label;
	
	@property(nonatomic,retain)UITextField* textField;

	@property(nonatomic,retain)	UIButton *btnImage1,*btnImage2,*btnImage3,*btnImage4;
	@property (nonatomic,retain) 	UIButton *btnAccesory;
	

@end
