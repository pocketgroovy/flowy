//
//  InterstitialAdViewController.m
//  Flowy
//
//  Created by Yoshihisa Miyamoto on 8/31/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "InterstitialAdViewController.h"

@interface InterstitialAdViewController ()

@end

@implementation InterstitialAdViewController
@synthesize interstitialAd;
@synthesize adView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //MoPub Ad
    self.adView = [[MPAdView alloc] initWithAdUnitId:@"ee8e981869a24bbe92d464e31df9efa7"
                                                size:MOPUB_BANNER_SIZE];
    self.adView.delegate = self;
    CGRect frame = CGRectMake(0, 0, 320, 780);
   // CGSize size = [self.adView adContentViewSize];

    self.adView.frame = frame;
    [self.view addSubview:self.adView];
    [self.adView loadAd];
    
}


#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}


#pragma mark - MPInterstitialAdControllerDelegate Method
-(void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial
{
    if(interstitial.ready)
    {
        [interstitialAd showFromViewController:self];
        NSLog(@"ready, %s", __FUNCTION__ );
        
    }
    else{
        NSLog(@"not ready");
    }
}


-(void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
{
    NSLog(@"Failed to load, %s", __FUNCTION__);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
