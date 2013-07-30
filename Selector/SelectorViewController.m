//
//  SelectorViewController.m
//  Selector
//
//  Created by Yoshihisa Miyamoto on 4/23/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "SelectorViewController.h"
#import "ShapeViewController.h"
#import "ColorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FlowingController.h"
#import "BBFImageStore.h"
#import "UIColor+JP.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SelectorViewController ()
@property ShapeViewController * shape;
@property ColorViewController * colorView;
@end

@implementation SelectorViewController
@synthesize btnShape;
@synthesize resultView;
@synthesize btnColor;
@synthesize shape;
@synthesize btnReady;
@synthesize colorView;
@synthesize imageBackGround;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    btnReady.hidden = YES;
    
    [imageBackGround setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"washi-01-swans-640.png"]]];
    UIImage * bg = [UIImage imageNamed:@"candy2.jpeg"];
    [btnShape setBackgroundImage:bg forState:UIControlStateNormal];
    btnShape.layer.borderColor = [UIColor colorWithR:238 G:130 B:238 A:1].CGColor;
    btnShape.layer.borderWidth = 5.0f;
    btnShape.layer.cornerRadius = 40.0f;
    
    bg = [UIImage imageNamed:@"colorful2.png"];
    [btnColor setBackgroundImage:bg forState:UIControlStateNormal];
    btnColor.layer.borderColor = [UIColor colorWithR:30 G:144 B:255 A:1].CGColor;
    btnColor.layer.borderWidth = 5.0f;
    btnColor.layer.cornerRadius = 40.0f;
    
    bg = [UIImage imageNamed:@"go.png"];
    [btnReady setBackgroundImage:bg forState:UIControlStateNormal];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AudioServicesPlaySystemSound(0x450);

    if([segue.identifier isEqualToString:@"flowing"]){
        if([segue.destinationViewController isKindOfClass:[FlowingController class]])
        {
   
            
        }
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    if ([resultView image]&& colorView.selectedColor ) {
        btnReady.hidden = NO;
    }
    else
        btnReady.hidden = YES;

}

-(IBAction)cancelSelection:(UIStoryboardSegue *)segue
{
    AudioServicesPlaySystemSound(0x450);

}

-(IBAction)confirmedShape:(UIStoryboardSegue *)segue
{
    AudioServicesPlaySystemSound(0x450);

    shape = segue.sourceViewController;
    if(shape)
    [resultView setImage:[self colorShape:colorView.selectedColor]];
}


-(IBAction)confirmedColor:(UIStoryboardSegue *) segue
{
    AudioServicesPlaySystemSound(0x450);

    colorView = segue.sourceViewController;
    if(shape)
    {
    [resultView setImage:nil];
    [resultView setImage:[self colorShape:colorView.selectedColor]];
    }
    
}


-(UIImage *) colorShape:(UIColor *)color
{
   
    UIImage * myShape = shape.selectedShape;
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
