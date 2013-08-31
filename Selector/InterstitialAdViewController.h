//
//  InterstitialAdViewController.h
//  Flowy
//
//  Created by Yoshihisa Miyamoto on 8/31/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPInterstitialAdController.h"
#import "MPAdView.h"
@interface InterstitialAdViewController : UIViewController<MPInterstitialAdControllerDelegate, MPAdViewDelegate>

@property (nonatomic, retain) MPAdView *adView;

@property (nonatomic, strong)MPInterstitialAdController *interstitialAd;

@end
