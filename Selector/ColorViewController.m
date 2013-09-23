//
//  ColorViewController.m
//  Selector
//
//  Created by Yoshihisa Miyamoto on 4/23/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "ColorViewController.h"
#import "UIColor+JP.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <StoreKit/StoreKit.h>
#import "Flurry.h"

@interface ColorViewController ()<UIPickerViewDelegate>



@property (nonatomic) NSMutableArray * colorArray;
@property (nonatomic) UIColor * color;
@property (nonatomic) UILabel * colorFrame;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *go;
@property (assign, nonatomic) NSInteger selectedRow;
@end
@implementation ColorViewController

@synthesize selectedColor;
@synthesize colorArray;
@synthesize color;
@synthesize colorFrame;
@synthesize go;
@synthesize cancel;
@synthesize selectedRow;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) colorList
{
    colorArray = [[NSMutableArray alloc]init];
    float redColor = 1.0f;
    float greenColor = 1.0f;
    float blueColor = 1.0f;


    for (int i = 0; i < 3; i++ )
    {
    colorFrame = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 60)];
    [colorFrame setBackgroundColor:[[UIColor alloc]initWithRed:redColor green:0.0 blue:0.0 alpha:1]];
    [colorArray addObject:colorFrame];
        redColor -= 0.3;
    }
    greenColor = 0.3f;
    redColor = 1.0f;

    for (int i = 0; i < 3; i++ )
    {   
        colorFrame = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 60)];
        [colorFrame setBackgroundColor:[[UIColor alloc]initWithRed:redColor green:greenColor blue:0.0 alpha:1]];
        [colorArray addObject:colorFrame];
        redColor -= 0.3f;
        greenColor+=0.3f;
    }
    
    blueColor = 0.3f;
    greenColor = 1.0f;
    redColor = 0.0f;
    
    for (int i = 0; i < 3; i++ )
    {
        colorFrame = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 60)];
        [colorFrame setBackgroundColor:[[UIColor alloc]initWithRed:redColor green:greenColor blue:blueColor alpha:1]];
        [colorArray addObject:colorFrame];
        greenColor-=0.3f;
        blueColor += 0.3f;
    }
    
    blueColor = 1.0f;
    for (int i = 0; i < 3; i++ )
    {
        colorFrame = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 60)];
        [colorFrame setBackgroundColor:[[UIColor alloc]initWithRed:0.0 green:0.0 blue:blueColor alpha:1]];
        [colorArray addObject:colorFrame];
        blueColor -= 0.3;
    }

    NSString * locColor = NSLocalizedString(@"NO_COLOR", nil);

    colorFrame = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 60)];
    [colorFrame setText:locColor];

    colorFrame.textAlignment = NSTextAlignmentCenter;
    [colorFrame setTextColor:[UIColor brownColor]];
    [colorArray addObject:colorFrame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self colorList];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"colorful.jpeg"]]];
    
    CGRect pickerFrame = CGRectMake(0, 120, 0, 0);
    UIPickerView * pickerView = [[UIPickerView alloc]initWithFrame:pickerFrame];
    
    
    
    float numPicker = self.view.frame.size.height /pickerView.frame.size.width;
    float pickerX;
    
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        
        if(((int)numPicker%2)== 0)
        {
            
            pickerX = (pickerView.frame.size.width *(numPicker/2)) - (pickerView.frame.size.width/2);
            
        }
        else{
            
            pickerX = pickerView.frame.size.width *((float)numPicker/2) - (pickerView.frame.size.width/2);
            
        }
        
        pickerFrame = CGRectMake(pickerX, 120, 0, 0);
        pickerView = [[UIPickerView alloc]initWithFrame:pickerFrame];
        
    }
    
    
    [pickerView setDelegate:self];
    pickerView.showsSelectionIndicator = YES;
    
    selectedColor = [[colorArray objectAtIndex:0]backgroundColor];      //default color
    
    [self.view addSubview:pickerView];
    
    [go setImage:[UIImage imageNamed:@"iine.png"] forState:UIControlStateNormal];
    go.layer.borderColor =[UIColor colorWithR:238 G:130 B:238 A:1].CGColor;
    go.layer.borderWidth = 10.0f;
    go.layer.cornerRadius = 20.0f;
    
    [cancel setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    cancel.layer.borderColor =[UIColor colorWithR:173 G:255 B:47 A:1].CGColor;
    cancel.layer.borderWidth = 5.0f;
    cancel.layer.cornerRadius = 10.0f;
    
}


#pragma mark - UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

#define MARGIN 15

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [colorArray count];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    
    return colorFrame.bounds.size.height + MARGIN;
}

-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    return [colorArray objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    AudioServicesPlaySystemSound(1057);

    if(row!=([colorArray count]-1))
    {
        NSLog(@"%d, -didselectRow, %lu", row, (unsigned long)[colorArray count]);
        
    selectedColor = [[colorArray objectAtIndex:row]backgroundColor];
    }
    else
    {
        selectedColor = [UIColor clearColor];
        NSLog(@"clearcolor,%@, %s", selectedColor, __FUNCTION__);

    }
    selectedRow = row;
     
}

#pragma mark - Send the delegate the selected color
- (IBAction)colorSelected:(id)sender {
    [self.colorDelegate colorViewController:self didFinishSelecting:selectedColor];
    
    
    NSString * selectedColorRowNumber = [NSString stringWithFormat:@"%d", selectedRow];
    NSLog(@"%@, %s", selectedColorRowNumber, __FUNCTION__);
    
    NSDictionary *colorChosenByUser = [NSDictionary dictionaryWithObjectsAndKeys:selectedColorRowNumber, @"Selected Color Row", nil ];
    
    [Flurry logEvent:@"Color_Selected" withParameters:colorChosenByUser];
}

- (IBAction)cancelled:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    
}


#pragma mark - For iOS5 and 5.1 in iPAD
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES; //needs to be YES for iOS5 and 5.1 to stay in Landscape
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
