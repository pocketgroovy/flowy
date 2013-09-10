//
//  MainViewController.h
//  Selector
//
//  Created by Yoshihisa Miyamoto on 5/2/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPAdView.h"
#import "SimpleAudioEngine.h"

@interface MainViewController : UIViewController<MPAdViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *photos;
@property (weak, nonatomic) IBOutlet UIButton *stars;
@property (weak, nonatomic) IBOutlet UILabel *instruction;
@property  (strong, nonatomic) UIImage * defaultImage;
@property(nonatomic, retain)MPAdView *adView;
@end
