//
//  Popup.h
//  SmartDate
//
//  Created by Zsolt B on 1/28/11.
//
//   Copyright 2010, 2011 VisionSync Inc.   All Rights Reserved
//
//   Revision History:
//       2011-02-24:  Initial v1.0 Submit to apple
//       2011-02-26:  Cleanup by Ash
//
//   Purpose:
// Define AlertAnimations Class.
//This class is used for Animate Popup view
#import <Foundation/Foundation.h>

@interface UIView(AlertAnimations)

- (void)doPopInAnimationX;
- (void)doPopInAnimationY;
- (void)doPopInAnimationXWithDelegate:(id)animationDelegate;
- (void)doPopInAnimationYWithDelegate:(id)animationDelegate;
- (void)doFadeInAnimation;
- (void)doFadeInAnimationWithDelegate:(id)animationDelegate;

@end
