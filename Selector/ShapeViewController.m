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
#import "FloweeShapeStore.h"
#import "PGStoreObserver.h"
#import "Reachability.h"

@interface ShapeViewController ()<UIPickerViewDelegate, UIAlertViewDelegate>
@property NSArray * imageArray;
@property (nonatomic)UIImageView * imageView;
@property (nonatomic)UIImageView * imageView2;
@property (nonatomic)UIImageView * imageView3;
@property (nonatomic)UIImageView * imageView4;
@property (nonatomic)UIImageView * imageView5;
@property (nonatomic)UIImageView * imageView6;
@property (nonatomic)UIImageView * imageView7;
@property  (nonatomic) IBOutlet UIImageView *wallpaper;
@property (weak, nonatomic) IBOutlet UIButton *go;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (assign, nonatomic) NSInteger selectedShapeRow;
@property (nonatomic)UIImageView * selectedImageView;
@property (nonatomic, weak)NSArray * floweeOptionalShapes;
@property (nonatomic, strong)UIPickerView * pickerView;
@property (nonatomic, strong)NSMutableArray * tempArray;
@end

@implementation ShapeViewController
@synthesize selectedShape;
@synthesize imageArray;
@synthesize imageView;
@synthesize imageView2;
@synthesize imageView3;
@synthesize imageView4;
@synthesize imageView5;
@synthesize imageView6;
@synthesize imageView7;
@synthesize selectedImageView;
@synthesize wallpaper;
@synthesize go;
@synthesize cancel;
@synthesize shapeDelegate;
@synthesize selectedShapeRow;
@synthesize floweeOptionalShapes;
@synthesize pickerView;
@synthesize tempArray;

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

    
    Reachability * reachNet = [Reachability reachabilityForInternetConnection];
    NetworkStatus statusNet = [reachNet currentReachabilityStatus];

    NSNotificationCenter *productNC = [NSNotificationCenter defaultCenter];
    [productNC addObserver:self selector:@selector(provideProduct:) name:@"ProductReady" object:[PGStoreObserver sharedObserver]];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"candies.png"]]];
    
    imageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smileyStar.png"]];
    imageView.frame = CGRectMake(0, 0, 100, 100);
    
    imageView2 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"diamond.png"]];
    imageView2.frame = CGRectMake(0, 0, 100, 100);
 
    imageView3 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"egg.png"]];
    imageView3.frame = CGRectMake(0, 0, 100, 100);
    
    imageView4 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"foxx.png"]];
    imageView4.frame = CGRectMake(0, 0, 100, 100);

    imageView5 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaiju.png"]];
    imageView5.frame = CGRectMake(0, 0, 100, 100);

    imageArray = [NSArray arrayWithObjects:imageView, imageView2, imageView3,imageView4, imageView5, nil];
    

    
    
    //IN-APP store products
    if([[FloweeShapeStore sharedStore]hasProducts] || [[NSUserDefaults standardUserDefaults]boolForKey:@"someBeenPurchased"]|| statusNet == NotReachable)
    {
            //before purchase
            if(![[NSUserDefaults standardUserDefaults]boolForKey:@"Flowee_Shape1"])
            {
            imageView6 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LockedFoxxEgg.png"]];
            imageView6.frame = CGRectMake(0, 0, 100, 100);
            [self addStoreProduct:imageView6];
            }
            //after purchase
            else{
            imageView6 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"foxxEgg.png"]];
            imageView6.frame = CGRectMake(0, 0, 100, 100);
            [self addStoreProduct:imageView6];
                NSLog(@"imageView6, -%s", __FUNCTION__);
            }
            
        
            if(![[NSUserDefaults standardUserDefaults]boolForKey:@"Flowee_Shape2"])
            {
            imageView7 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LockedKaijuEgg.png"]];
            imageView7.frame = CGRectMake(0, 0, 100, 100);
            [self addStoreProduct:imageView7];
            }
            else{
            imageView7 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaijuEgg.png"]];
            imageView7.frame = CGRectMake(0, 0, 100, 100);
            [self addStoreProduct:imageView7];
                NSLog(@"imageView7, -%s", __FUNCTION__);

            }
        
        NSLog(@"FloweeShapeStore hasProducts, -%s", __FUNCTION__);

    }

    
    CGRect pickerFrame = CGRectMake(0, 120, 0, 0);
    pickerView = [[UIPickerView alloc]initWithFrame:pickerFrame];

    
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

-(void)addStoreProduct:(UIImageView *)storeImageView
{
    tempArray = [NSMutableArray arrayWithArray:imageArray];
    [tempArray addObject:storeImageView];
    imageArray = tempArray;
}


-(void)replaceImageAtIndex:(NSInteger )index withUnlockedImageView:(UIImageView *)unlockedImageView
{
    tempArray = [NSMutableArray arrayWithArray:imageArray];
    [tempArray removeObjectAtIndex:index];
    [tempArray insertObject:unlockedImageView atIndex:index];
    [pickerView reloadAllComponents];
}


-(void)provideProduct:(NSNotification *)productIsReady
{
    NSDictionary * productInfo = [productIsReady userInfo];
    
    NSString * productID = [productInfo objectForKey:@"PurchasedProduct"];

    if([productID isEqualToString:@"Flowee_Shape1"])
    {
        imageView6 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"foxxEgg.png"]];
        imageView6.frame = CGRectMake(0, 0, 100, 100);
        [self replaceImageAtIndex:selectedShapeRow withUnlockedImageView:imageView6];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[NSString stringWithFormat:@"%@",[imageView6 image]]];
        NSLog(@"Flowee_Shape1, %s", __FUNCTION__);

    }
    else if([productID isEqualToString:@"Flowee_Shape2"])
    {
        
        imageView7 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaijuEgg.png"]];
        imageView7.frame = CGRectMake(0, 0, 100, 100);
        [self replaceImageAtIndex:selectedShapeRow withUnlockedImageView:imageView7];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[NSString stringWithFormat:@"%@",[imageView7 image]]];
        NSLog(@"Flowee_Shape2, %s", __FUNCTION__);

    }

    
    
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
    if(tempArray)
    {
        imageArray = tempArray;
    }
    
    return [imageArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
    AudioServicesPlaySystemSound(0x450);
    
    selectedShapeRow = row;
    
    Reachability * reachNet = [Reachability reachabilityForInternetConnection];
    NetworkStatus statusNet = [reachNet currentReachabilityStatus];
    
    selectedImageView = [imageArray objectAtIndex:selectedShapeRow];

    
    if(statusNet != NotReachable)
    {
        
        if(selectedShapeRow > 4 && ![[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"%@", [selectedImageView image]]] &&[SKPaymentQueue canMakePayments])
        {
            NSString * locInAppPurchase = NSLocalizedString(@"INAPP_PURCHASE", nil);
            NSString * locInAppPurchaseMessage = NSLocalizedString(@"INAPP_PURCHASE_MESSAGE", nil);
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:locInAppPurchase message:locInAppPurchaseMessage delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [alert show];
            
            NSLog(@"selectedRow, %d - %s", selectedShapeRow, __FUNCTION__);
        }
    }
}


#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        switch (selectedShapeRow ) {
            case 5:
                [[PGStoreObserver sharedObserver]buyProduct:[[FloweeShapeStore sharedStore]shapeForKey:@"Flowee_Shape1"]];
                break;
            case 6:
                [[PGStoreObserver sharedObserver]buyProduct:[[FloweeShapeStore sharedStore]shapeForKey:@"Flowee_Shape2"]];
                break;
            default:
                break;
        }
 
    }

}


#pragma mark - Send the delegate the selected shape
- (IBAction)shapeSelected:(id)sender {
    

    selectedImageView = [imageArray objectAtIndex:selectedShapeRow];
    
    selectedShape = [selectedImageView image];
    
    [self.shapeDelegate shapeViewController:self didFinishSelecting:selectedShape inRow:selectedShapeRow];
    
    NSString * selectedShapeRowNumber = [NSString stringWithFormat:@"%d", selectedShapeRow];
        
    NSDictionary *shapeChosenByUser = [NSDictionary dictionaryWithObjectsAndKeys:selectedShapeRowNumber, @"Selected Shape Row", nil ];
    NSLog(@"selectedRow in delegate, %d - %s", selectedShapeRow, __FUNCTION__);

    
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
