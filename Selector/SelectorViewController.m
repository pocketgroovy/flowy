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
    NSLog(@"%f btnY %s", btnYOrigin, __FUNCTION__);

    //for iPad Landscape display
    if(btnYOrigin +imageBackGround.bounds.size.width/4 > imageBackGround.bounds.size.height - btnColor.bounds.size.height + 20)
    {
        btnYOrigin = resultView.frame.origin.y + 80;
        NSLog(@"ipad %s", __FUNCTION__);
    }
    
    CGRect btnFrame = CGRectMake((imageBackGround.bounds.size.width/2 - (imageBackGround.bounds.size.width/4)/2), btnYOrigin, imageBackGround.bounds.size.width/4, imageBackGround.bounds.size.width/4);
    btnReady = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnReady setImage:readyImage forState:UIControlStateNormal];
    [btnReady setFrame:btnFrame];
    [btnReady addTarget:self action:@selector(flowy:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnReady];
    btnReady.hidden = YES;
}

-(void)flowy:(id)sender
{
    [self performSegueWithIdentifier:@"flowing" sender:sender];
    NSLog(@"%s", __FUNCTION__);
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AudioServicesPlaySystemSound(0x450);

    if([segue.identifier isEqualToString:@"flowing"]){
        if([segue.destinationViewController isKindOfClass:[FlowingController class]])
        {
            flowVC =(FlowingController*) segue.destinationViewController;
            NSLog(@"%s - Flowing Segue", __FUNCTION__);
        }
    }
    if([segue.identifier isEqualToString:@"shapeModal"]){
        if([segue.destinationViewController isKindOfClass:[ShapeViewController class]])
        {
            shapeVC =(ShapeViewController*) segue.destinationViewController;
            shapeVC.shapeDelegate = self;
            NSLog(@"%s - Shape Segue", __FUNCTION__);
            
        }
    }
    
    if([segue.identifier isEqualToString:@"colorModal"]){
        if([segue.destinationViewController isKindOfClass:[ColorViewController class]])
        {
            colorVC =(ColorViewController*) segue.destinationViewController;
            colorVC.colorDelegate = self;
            NSLog(@"%s - Color Segue", __FUNCTION__);
            
        }
    }
    
    
}



-(void)viewDidAppear:(BOOL)animated
{
    if (myShape && myColor) {
        btnReady.hidden = NO;
    }
    else
        btnReady.hidden = YES;

}

//-(IBAction)cancelSelection:(UIStoryboardSegue *)segue
//{
//    AudioServicesPlaySystemSound(0x450);
//
//}
//
//-(IBAction)confirmedShape:(UIStoryboardSegue *)segue
//{
//    AudioServicesPlaySystemSound(0x450);
//
//    shape = segue.sourceViewController;
//    if(shape)
//    [resultView setImage:[self colorShape:colorView.selectedColor]];
//}
//
//
//-(IBAction)confirmedColor:(UIStoryboardSegue *) segue
//{
//    AudioServicesPlaySystemSound(0x450);
//
//    colorView = segue.sourceViewController;
//    if(shape)
//    {
//    [resultView setImage:nil];
//    [resultView setImage:[self colorShape:colorView.selectedColor]];
//    }
//    
//}

-(void)viewWillAppear:(BOOL)animated
{
    
    NSLog(@"%s", __FUNCTION__);
}


#pragma mark - COLORVIEWCONTROLLER DELEGATE
-(void)colorViewController:(ColorViewController *)controller didFinishSelecting:(UIColor *)color
{
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
    UIImage * coloredShape = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString * key = @"myColoredShape";
    [[BBFImageStore sharedStore]setImage:coloredShape forKey:key];
    
    return coloredShape;
}


#pragma mark - For iOS5 and older orientation in iPAD
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
