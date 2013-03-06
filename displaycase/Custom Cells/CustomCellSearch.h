//
//  CustomCellSearch.h
//  displaycase
//
//  Created by Dipak Baraiya on 26/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCellSearch : UITableViewCell 
{
    UIImageView *imgThumb;
    UILabel *lblTitle;
	UITextView *txtDesc;
	UILabel *lblUserName;
}

@property(nonatomic,retain)UIImageView *imgThumb;
@property(nonatomic,retain)UILabel *lblTitle;
@property(nonatomic,retain)UITextView *txtDesc;
@property(nonatomic,retain)UILabel *lblUserName;

@end

