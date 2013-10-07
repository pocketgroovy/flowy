//
//  FlowySplitViewController.m
//  Flowy
//
//  Created by Yoshihisa Miyamoto on 8/23/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "FlowySplitViewController.h"

@interface FlowySplitViewController ()

@end

@implementation FlowySplitViewController

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
}

-(NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskLandscape;
}

//iOS5 5.1 needs this to stay in Landscape
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
