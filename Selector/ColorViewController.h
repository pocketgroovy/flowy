//
//  ColorViewController.h
//  Selector
//
//  Created by Yoshihisa Miyamoto on 4/23/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorViewController;

@protocol ColorViewControllerDelegate <NSObject>

-(void)colorViewController:(ColorViewController *)controller didFinishSelecting:(UIColor*)color;
@end

@interface ColorViewController : UIViewController

@property (nonatomic) UIColor * selectedColor;
@property (nonatomic) id<ColorViewControllerDelegate>colorDelegate;
@end
