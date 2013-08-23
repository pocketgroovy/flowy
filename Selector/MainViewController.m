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
    
}




#pragma mark - Set selected photo from BBFViewController

-(void)viewWillAppear:(BOOL)animated
{
    if([[BBFImageStore sharedStore]imageForKey:@"mySelectedPhoto"] )
    {
        defaultImage = [[BBFImageStore sharedStore]imageForKey:@"mySelectedPhoto"];
        instruction.text = @"2nd Step! Select Your Shape and Color!";
        
    }
    
    else
    {
        instruction.text = @"1st Step! Take or Choose a Photo! ➡";
    }

    
    [photos setImage:defaultImage  forState:UIControlStateNormal];

    
}


#pragma mark - For iOS5 and older orientation in iPAD
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    NSLog(@"%s", __FUNCTION__);

    return YES;
}

#pragma mark - For iOS6
-(BOOL)shouldAutorotate
{
    NSLog(@"%s", __FUNCTION__);

    return NO;
}

#pragma mark - For iOS6 bug
-(NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"%s", __FUNCTION__);

    return UIInterfaceOrientationMaskLandscape;
}


#pragma mark

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
