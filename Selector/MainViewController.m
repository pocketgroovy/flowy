//
//  MainViewController.m
//  Selector
//
//  Created by Yoshihisa Miyamoto on 5/2/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "MainViewController.h"
#import "BBFViewController.h"
#import "SelectorViewController.h"
#import "BBFImageStore.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+JP.h"
#import <AudioToolbox/AudioToolbox.h>

@interface MainViewController ()<UISplitViewControllerDelegate>
@property   BBFViewController * picVC;

@end

@implementation MainViewController
@synthesize picVC;
@synthesize photos;
@synthesize stars;
@synthesize instruction;
@synthesize defaultImage;
@synthesize adView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)awakeFromNib
{
    self.splitViewController.delegate=self;
}


#pragma mark - UISplitViewControllerDelegate
-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithR:255 G:248 B:220 A:1]];
    defaultImage = [UIImage imageNamed:@"camera2.png"];

    [[BBFImageStore sharedStore]setImage:defaultImage forKey:@"defaultImage"];

    //main photo button
    [photos setImage:defaultImage  forState:UIControlStateNormal];
    photos.layer.borderColor =[UIColor colorWithR:238 G:130 B:238 A:1].CGColor;
    photos.layer.borderWidth = 20.0f;
    photos.layer.cornerRadius = 50.0f;
    
    UIImage * defaultImage2 = [UIImage imageNamed:@"stars.png"];
    
    [[BBFImageStore sharedStore]setImage:defaultImage2 forKey:@"defaultImage2"];

    //particles button
    [stars setImage:defaultImage2  forState:UIControlStateNormal];
    stars.layer.borderColor =[UIColor colorWithR:173 G:255 B:47 A:1].CGColor;
    stars.layer.borderWidth = 20.0f;
    stars.layer.cornerRadius = 50.0f;
    
    NSLog(@"%s", __FUNCTION__);
    
    self.adView = [[MPAdView alloc] initWithAdUnitId:@"ee8e981869a24bbe92d464e31df9efa7"
                                                 size:MOPUB_BANNER_SIZE];
    self.adView.delegate = self;
    CGRect frame = self.adView.frame;
    frame.origin.y = 0;
    self.adView.frame = frame;
    [self.view addSubview:self.adView];
    [self.adView loadAd];

    
}

#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}


#pragma mark - get selected photo from BBFImageStore

-(void)viewWillAppear:(BOOL)animated
{
    if([[BBFImageStore sharedStore]imageForKey:@"mySelectedPhoto"] )
    {
        defaultImage = [[BBFImageStore sharedStore]imageForKey:@"mySelectedPhoto"];
        instruction.text = NSLocalizedString(@"INSTRUCTION2", nil);
        
    }
    
    else
    {
        instruction.text = NSLocalizedString(@"INSTRUCTION1", nil);
    }

    
    [photos setImage:defaultImage  forState:UIControlStateNormal];

    
}


#pragma mark - For iOS5 and older orientation in iPAD
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - For iOS6
-(BOOL)shouldAutorotate
{

    return NO;
}

#pragma mark - For iOS6 bug
-(NSUInteger)supportedInterfaceOrientations
{

    return UIInterfaceOrientationMaskLandscape;
}


#pragma mark

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
