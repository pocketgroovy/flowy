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
#import "BBFImageStore.h"
#import "Flurry.h"
#import <StoreKit/StoreKit.h>

@interface ShapeViewController ()<UIPickerViewDelegate, SKProductsRequestDelegate>
@property NSMutableArray * imageArray;
@property (nonatomic)UIImageView * imageView;
@property (nonatomic)UIImageView * imageView2;
@property (nonatomic)UIImageView * imageView3;
@property (nonatomic)UIImageView * imageView4;
@property (nonatomic)UIImageView * imageView5;
@property  (nonatomic) IBOutlet UIImageView *wallpaper;
@property (weak, nonatomic) IBOutlet UIButton *go;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (assign, nonatomic) NSInteger selectedShapeRow;
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
@synthesize selectedShapeRow;

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

- (void)requestProductData
{
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:
                                 [NSSet setWithObject: kMyFeatureIdentifier]];
    request.delegate = self;
    [request start];
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *myProducts = response.products;
    // Populate your UI from the products list.
    // Save a reference to the products list.
}





#pragma mark - UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}



-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [imageArray count];
}


#define MARGIN 15   //margin  


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
    
    selectedShapeRow = row;

}


#pragma mark - Send the delegate the selected shape
- (IBAction)shapeSelected:(id)sender {
    
        [self.shapeDelegate shapeViewController:self didFinishSelecting:selectedShape];
    
    NSString * selectedShapeRowNumber = [NSString stringWithFormat:@"%d", selectedShapeRow];
        
    NSDictionary *shapeChosenByUser = [NSDictionary dictionaryWithObjectsAndKeys:selectedShapeRowNumber, @"Selected Shape Row", nil ];
    
    [Flurry logEvent:@"Shape_Selected" withParameters:shapeChosenByUser];
}


- (IBAction)cancelled:(id)sender {
    [self dismissModalViewControllerAnimated:YES];

}

#pragma mark - For iOS5 and older orientation in iPAD
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;//needs to be YES for iOS5 and 5.1 to stay in Landscape
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
