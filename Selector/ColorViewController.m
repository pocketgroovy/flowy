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

@interface ColorViewController ()<UIPickerViewDelegate>



@property (nonatomic) NSMutableArray * colorArray;
@property (nonatomic) UIColor * color;
@property (nonatomic) UILabel * colorFrame;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *go;
@end
@implementation ColorViewController

@synthesize selectedColor;
@synthesize colorArray;
@synthesize color;
@synthesize colorFrame;
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


-(void) colorList
{
    colorArray = [[NSMutableArray alloc]init];

    colorFrame = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    [colorFrame setBackgroundColor:[[UIColor alloc]initWithRed:1.0 green:0.0 blue:0.0 alpha:1]];
    [colorArray addObject:colorFrame];

    colorFrame = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    [colorFrame setBackgroundColor:[[UIColor alloc]initWithRed:1.0 green:0.0 blue:1.0 alpha:1]];
    [colorArray addObject:colorFrame];
    
    colorFrame = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    [colorFrame setBackgroundColor:[[UIColor alloc]initWithRed:0.0 green:1.0 blue:0.0 alpha:1]];
    [colorArray addObject:colorFrame];
    
    colorFrame = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    [colorFrame setBackgroundColor:[[UIColor alloc]initWithRed:0.0 green:1.0 blue:1.0 alpha:1]];
    [colorArray addObject:colorFrame];
    
    colorFrame = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    [colorFrame setBackgroundColor:[[UIColor alloc]initWithRed:0.0 green:0.0 blue:1.0 alpha:1]];
    [colorArray addObject:colorFrame];
    
    colorFrame = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    [colorFrame setText:@"Various"];

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
    AudioServicesPlaySystemSound(1200);

    selectedColor = [[colorArray objectAtIndex:row]backgroundColor];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
