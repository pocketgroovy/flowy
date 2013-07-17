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

//-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
//{
//    barButtonItem.title = @"Main";
//    id detailViewController = [self.splitViewController.viewControllers lastObject];
//    [detailViewController setSplitViewBarButtonItem:barButtonItem];
//}
//


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithR:255 G:248 B:220 A:1]];
    defaultImage = [UIImage imageNamed:@"camera2.png"];

    [[BBFImageStore sharedStore]setImage:defaultImage forKey:@"defaultImage"];
    if([[BBFImageStore sharedStore]imageForKey:@"mySelectedPhoto"] )
    {
        defaultImage = [[BBFImageStore sharedStore]imageForKey:@"mySelectedPhoto"];
        
    }
    [photos setImage:defaultImage  forState:UIControlStateNormal];
    photos.layer.borderColor =[UIColor colorWithR:238 G:130 B:238 A:1].CGColor;
    photos.layer.borderWidth = 20.0f;
    photos.layer.cornerRadius = 50.0f;
    
    UIImage * defaultImage2 = [UIImage imageNamed:@"stars.png"];
    
    [[BBFImageStore sharedStore]setImage:defaultImage2 forKey:@"defaultImage2"];


    [stars setImage:defaultImage2  forState:UIControlStateNormal];
    stars.layer.borderColor =[UIColor colorWithR:173 G:255 B:47 A:1].CGColor;
    stars.layer.borderWidth = 20.0f;
    stars.layer.cornerRadius = 50.0f;
    instruction.text = @"1st Step! Take or Choose a Photo! ➡";

}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        AudioServicesPlaySystemSound(0x450);
    
    if([segue.identifier isEqualToString:@"SelectImage"]){
        
        if([segue.destinationViewController isKindOfClass:[SelectorViewController class]])
        {
        }
    }
    if([segue.identifier isEqualToString:@"SelectPhoto"]){
        
        if([segue.destinationViewController isKindOfClass:[BBFViewController class]])
        {
//            BBFViewController * dvc = [[BBFViewController alloc]init];
//            
//            dvc.photo = photos.imageView.image;
            
        }
    }
}



-(IBAction)confirmedPhoto:(UIStoryboardSegue *)segue
{
    AudioServicesPlaySystemSound(0x450);

    picVC = segue.sourceViewController;
    if(picVC)
    {
        UIImage * picSelected = [[BBFImageStore sharedStore]imageForKey:@"mySelectedPhoto"];
         [photos setImage:picSelected forState:UIControlStateNormal];
        instruction.text = @"2nd Step! Select your shape and a color!";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
