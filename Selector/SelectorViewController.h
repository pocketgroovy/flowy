
//  SelectorViewController.h
//  Selector
//
//  Created by Yoshihisa Miyamoto on 4/23/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//
#import "ShapeViewController.h"
#import "ColorViewController.h"
#import <UIKit/UIKit.h>
#import "MPAdView.h"
@interface SelectorViewController : UIViewController<ShapeViewControllerDelegate, ColorViewControllerDelegate, MPAdViewDelegate>
@property (strong, nonatomic) UIButton *btnReady;
@property (weak, nonatomic) IBOutlet UIButton *btnShape;
@property (weak, nonatomic) IBOutlet UIImageView *resultView;
@property (weak, nonatomic) IBOutlet UIButton *btnColor;
@property (weak, nonatomic) IBOutlet UIImageView *imageBackGround;
@property (nonatomic, retain) MPAdView *adView;

-(void)shapeViewController:(ShapeViewController *)controller didFinishSelecting:(UIImage *)shape;


@end
