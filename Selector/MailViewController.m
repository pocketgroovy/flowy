//
//  MailViewController.m
//  Selector
//
//  Created by Yoshihisa Miyamoto on 5/12/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "MailViewController.h"
#import "UIColor+JP.h"
#import <QuartzCore/QuartzCore.h>

@interface MailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtSubject;
@property (weak, nonatomic) IBOutlet UITextField *txtAddressOne;
@property (weak, nonatomic) IBOutlet UITextField *txtAddressTwo;
@property (weak, nonatomic) IBOutlet UITextField *txtContents;
@property (nonatomic)UIMenuController * autocomplete;
@property (weak, nonatomic) IBOutlet UIButton *go;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@end

@implementation MailViewController
@synthesize mailSubject;
@synthesize mailAddresses;
@synthesize mailContents;
@synthesize go;
@synthesize cancel;


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
    
          [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"washi-01-swans-640.png"]]];
    mailAddresses = [[NSMutableArray alloc]init];
    [self.txtContents setDelegate:self];
    [self.txtAddressOne setDelegate:self];
    [self.txtAddressTwo setDelegate:self];
    [self.txtSubject setDelegate:self];

    self.txtAddressOne.keyboardType = UIKeyboardTypeEmailAddress;
    self.txtAddressTwo.keyboardType = UIKeyboardTypeEmailAddress;
    
    [go setImage:[UIImage imageNamed:@"iine.png"] forState:UIControlStateNormal];
    go.layer.borderColor =[UIColor colorWithR:238 G:130 B:238 A:1].CGColor;
    go.layer.borderWidth = 10.0f;
    go.layer.cornerRadius = 20.0f;
    
    [cancel setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    cancel.layer.borderColor =[UIColor colorWithR:173 G:255 B:47 A:1].CGColor;
    cancel.layer.borderWidth = 5.0f;
    cancel.layer.cornerRadius = 10.0f;
}



- (IBAction)enterSubject:(id)sender {
    mailSubject = [self.txtSubject text];
}

- (IBAction)enterAddressOne:(id)sender {
    [mailAddresses addObject:[self.txtAddressOne text]];
}

- (IBAction)enterAddressTwo:(id)sender {
    [mailAddresses addObject:[self.txtAddressTwo text]];
}

- (IBAction)enterContents:(id)sender {
    mailContents = [self.txtContents text];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAll;
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
