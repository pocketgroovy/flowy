//
//  ShapeViewController.m
//  Selector
//
//  Created by Yoshihisa Miyamoto on 4/23/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "ShapeViewController.h"
#import "UIColor+JP.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SelectorViewController.h"



@interface ShapeViewController ()<UIPickerViewDelegate>
@property NSMutableArray * imageArray;
@property (nonatomic)UIImageView * imageView;
@property (nonatomic)UIImageView * imageView2;
@property (nonatomic)UIImageView * imageView3;
@property (nonatomic)UIImageView * imageView4;
@property (nonatomic)UIImageView * imageView5;
@property  (nonatomic) IBOutlet UIImageView *wallpaper;
@property (weak, nonatomic) IBOutlet UIButton *go;
@property (weak, nonatomic) IBOutlet UIButton *cancel;

@property (nonatomic)UIImageView * selectedImageView;

@end

@implementation ShapeViewController
@synthesize selectedShape;
@synthesize imageArray;
@synthesize imageView;
@synthesize imageView2;
@synthesize imageView3;
@synthesize imageView4;
@synthesize imageView5;
@synthesize selectedImageView;
@synthesize wallpaper;
@synthesize go;
@synthesize cancel;
@synthesize shapeDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
      [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"candies.png"]]];
    
    imageArray = [[NSMutableArray alloc]init];
        
    imageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smileyStar.png"]];
    imageView.frame = CGRectMake(0, 0, 100, 100);
    imageView2 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"diamond.png"]];
    imageView2.frame = CGRectMake(0, 0, 100, 100);
    imageView3 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"egg.png"]];
    imageView3.frame = CGRectMake(0, 0, 100, 100);
    imageView4 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"snowflake2.png"]];
    imageView5 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circle.png"]];
    wallpaper =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"candies.png"]];


    [imageArray addObject:imageView];
    [imageArray addObject:imageView2];
    [imageArray addObject:imageView3];
    [imageArray addObject:imageView4];
    [imageArray addObject:imageView5];
    
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
    
    selectedShape = [imageView image];      //default shape

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



-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [imageArray count];
}


#define MARGIN 15   //margin  


#pragma mark - UIPickerViewDelegate
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    
  
    return 100.0f +MARGIN;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    return [imageArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
    AudioServicesPlaySystemSound(0x450);

    selectedImageView = [imageArray objectAtIndex:row];
    
    selectedShape = [selectedImageView image];
    

    NSLog(@"%s", __FUNCTION__);

}



- (IBAction)shapeSelected:(id)sender {
        [self.shapeDelegate shapeViewController:self didFinishSelecting:selectedShape];

}


- (IBAction)cancelled:(id)sender {
    [self dismissModalViewControllerAnimated:YES];

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
