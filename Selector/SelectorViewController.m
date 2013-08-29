//
//  SelectorViewController.m
//  Selector
//
//  Created by Yoshihisa Miyamoto on 4/23/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//
#import "SelectorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FlowingController.h"
#import "BBFImageStore.h"
#import "UIColor+JP.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SelectorViewController ()
@property (nonatomic, weak)ShapeViewController * shapeVC;
@property (nonatomic, weak)ColorViewController * colorVC;
@property (nonatomic, weak)FlowingController * flowVC;
@property (nonatomic, weak)UIImage * myShape;
@property (nonatomic, weak)UIColor * myColor;
@property (nonatomic, weak)UIImage * coloredShape;
@end

@implementation SelectorViewController 
@synthesize btnShape;
@synthesize resultView;
@synthesize btnColor;
@synthesize shapeVC;
@synthesize btnReady;
@synthesize colorVC;
@synthesize imageBackGround;
@synthesize myShape;
@synthesize myColor;
@synthesize flowVC;
@synthesize adView;
@synthesize coloredShape;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.


    //wallpaper
    [imageBackGround setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"washi-01-swans-640.png"]]];
    
    //shape button
    UIImage * bg = [UIImage imageNamed:@"candy2.jpeg"];
    [btnShape setBackgroundImage:bg forState:UIControlStateNormal];
    btnShape.layer.borderColor = [UIColor colorWithR:238 G:130 B:238 A:1].CGColor;
    btnShape.layer.borderWidth = 5.0f;
    btnShape.layer.cornerRadius = 40.0f;
    
    //color button
    bg = [UIImage imageNamed:@"colorful2.png"];
    [btnColor setBackgroundImage:bg forState:UIControlStateNormal];
    btnColor.layer.borderColor = [UIColor colorWithR:30 G:144 B:255 A:1].CGColor;
    btnColor.layer.borderWidth = 5.0f;
    btnColor.layer.cornerRadius = 40.0f;
    
    //go button
    UIImage * readyImage = [UIImage imageNamed:@"go.png"];
    
    //for iphone display size
    float btnYOrigin = resultView.frame.origin.y + resultView.bounds.size.height;

    //for iPad Landscape display
    if(btnYOrigin +imageBackGround.bounds.size.width/4 > imageBackGround.bounds.size.height - btnColor.bounds.size.height + 20)
    {
        btnYOrigin = resultView.frame.origin.y + 80;
    }
    
    //ready go button
    CGRect btnFrame = CGRectMake((imageBackGround.bounds.size.width/2 - (imageBackGround.bounds.size.width/4)/2), btnYOrigin, imageBackGround.bounds.size.width/4, imageBackGround.bounds.size.width/4);
    btnReady = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnReady setImage:readyImage forState:UIControlStateNormal];
    [btnReady setFrame:btnFrame];
    [btnReady addTarget:self action:@selector(flowy:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnReady];
    btnReady.hidden = YES;
    
    
    //MoPub Ad
    self.adView = [[MPAdView alloc] initWithAdUnitId:@"ee8e981869a24bbe92d464e31df9efa7"
                                                 size:MOPUB_BANNER_SIZE];
    self.adView.delegate = self;
    CGRect frame = self.adView.frame;
    CGSize size = [self.adView adContentViewSize];
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
    frame.origin.y = btnShape.bounds.size.height;
    }
    else{
        frame.origin.y = self.view.bounds.size.width - size.height*2;
        frame.origin.x = size.width;
    }
    self.adView.frame = frame;
    [self.view addSubview:self.adView];
    [self.adView loadAd];
    
}


#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}


#pragma mark - segue to Flowing Controller
-(void)flowy:(id)sender
{
    [self performSegueWithIdentifier:@"flowing" sender:sender];
}

#pragma mark - prepareForSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AudioServicesPlaySystemSound(0x450);

    if([segue.identifier isEqualToString:@"flowing"]){
        if([segue.destinationViewController isKindOfClass:[FlowingController class]])
        {
            flowVC =(FlowingController*) segue.destinationViewController;
        }
    }
    if([segue.identifier isEqualToString:@"shapeModal"]){
        if([segue.destinationViewController isKindOfClass:[ShapeViewController class]])
        {
            shapeVC =(ShapeViewController*) segue.destinationViewController;
            shapeVC.shapeDelegate = self;            
        }
    }
    
    if([segue.identifier isEqualToString:@"colorModal"]){
        if([segue.destinationViewController isKindOfClass:[ColorViewController class]])
        {
            colorVC =(ColorViewController*) segue.destinationViewController;
            colorVC.colorDelegate = self;            
        }
    }
}


#pragma mark - show the ready button when both shape and color are selected
-(void)viewDidAppear:(BOOL)animated
{
    if (coloredShape) {
        btnReady.hidden = NO;
    }
    else
        btnReady.hidden = YES;

}


#pragma mark - COLORVIEWCONTROLLER DELEGATE
-(void)colorViewController:(ColorViewController *)controller didFinishSelecting:(UIColor *)color
{
    NSLog(@"%@, %s", color, __FUNCTION__);
    myColor = color;
    [resultView setImage:nil];
    if(myShape)
    {
    [resultView setImage:[self colorShape:myColor]];
    }
    [self dismissModalViewControllerAnimated:YES];

}

#pragma mark - SHAPEVIEWCONTROLLER DELEGATE
-(void)shapeViewController:(ShapeViewController *)controller didFinishSelecting:(UIImage *)shape
{    NSLog(@"%s", __FUNCTION__);
    myShape = shape;
    
    [resultView setImage:myShape];
    if(myColor)
    {
        [resultView setImage:[self colorShape:myColor]];
    }
    [self dismissModalViewControllerAnimated:YES];

}

#pragma mark - COLOR THE SELECTED SHAPE
-(UIImage *) colorShape:(UIColor *)color
{
   
    UIGraphicsBeginImageContext(myShape.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    
    CGContextTranslateCTM(context, 0, myShape.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeOverlay);
    CGRect rect = CGRectMake(0, 0, myShape.size.width, myShape.size.height);
    CGContextDrawImage(context, rect, myShape.CGImage);
    CGContextClipToMask(context, rect, myShape.CGImage);
    CGContextAddRect(context, rect);
    CGContextFillPath(context);
    coloredShape = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString * key = @"myColoredShape";
    [[BBFImageStore sharedStore]setImage:coloredShape forKey:key];
    
    return coloredShape;
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
