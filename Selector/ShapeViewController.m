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
@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic,strong)UIImageView * imageView2;
@property (nonatomic,strong)UIImageView * imageView3;
@property (nonatomic,strong)UIImageView * imageView4;
@property (nonatomic,strong)UIImageView * imageView5;
@property (nonatomic,strong)UIImageView * imageView6;
@property (nonatomic,strong)UIImageView * imageView7;
@property (nonatomic,strong)UIImageView * imageView6Unlocked;
@property (nonatomic,strong)UIImageView * imageView7Unlocked;



@property  (nonatomic, weak) IBOutlet UIImageView *wallpaper;
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
@synthesize imageView6Unlocked;
@synthesize imageView7Unlocked;
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

    //check network
    Reachability * reachNet = [Reachability reachabilityForInternetConnection];
    NetworkStatus statusNet = [reachNet currentReachabilityStatus];

    //listening store observer
    NSNotificationCenter *productNC = [NSNotificationCenter defaultCenter];
    [productNC addObserver:self selector:@selector(provideProduct:) name:@"ProductReady" object:[PGStoreObserver sharedObserver]];
    
    //show if needs to restore items
    if(statusNet != NotReachable && ![[NSUserDefaults standardUserDefaults]boolForKey:@"restoreAsked"])
    {
    [[PGStoreObserver sharedObserver]checkPurchasedItems];
    }
    
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
    
    imageView6 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LockedFoxxEgg.png"]];
                imageView6.frame = CGRectMake(0, 0, 100, 100);
    imageView7 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LockedKaijuEgg.png"]];
                imageView7.frame = CGRectMake(0, 0, 100, 100);

    imageArray = [NSArray arrayWithObjects:imageView, imageView2, imageView3,imageView4, imageView5, imageView6, imageView7, nil];
    
    
    imageView6Unlocked =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"foxxEgg.png"]];
    imageView6Unlocked.frame = CGRectMake(0, 0, 100, 100);
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"flowee1Purchased"]]) 
    {
        [self replaceImageAtIndex:flowee1 withUnlockedImageView:imageView6Unlocked];
    }
    
    imageView7Unlocked =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaijuEgg.png"]];
    imageView7Unlocked.frame = CGRectMake(0, 0, 100, 100);
    if([[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"flowee2Purchased"]])
    {
        [self replaceImageAtIndex:flowee2 withUnlockedImageView:imageView7Unlocked];
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



//replace with unlocked shapes

-(void)replaceImageAtIndex:(NSInteger )index withUnlockedImageView:(UIImageView *)unlockedImageView
{
    NSLog(@"%@, %s",[[unlockedImageView image]description], __FUNCTION__);
    tempArray = [NSMutableArray arrayWithArray:imageArray];
    [tempArray removeObjectAtIndex:index];
    [tempArray insertObject:unlockedImageView atIndex:index];
    imageArray = tempArray;
    [pickerView reloadAllComponents];
}


//provide the purchased product after recieving response from store
-(void)provideProduct:(NSNotification *)productIsReady
{
    
    NSDictionary * productInfo = [productIsReady userInfo];
    
    NSString * productID = [productInfo objectForKey:@"PurchasedProduct"];


    if([productID isEqualToString:@"Flowee_Shape1"])
    {
        imageView6Unlocked =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"foxxEgg.png"]];
        imageView6Unlocked.frame = CGRectMake(0, 0, 100, 100);
        [self replaceImageAtIndex:flowee1 withUnlockedImageView:imageView6Unlocked];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[NSString stringWithFormat:@"flowee1Purchased"]];
    }
    else if([productID isEqualToString:@"Flowee_Shape2"])
    {
        imageView7Unlocked =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaijuEgg.png"]];
        imageView7Unlocked.frame = CGRectMake(0, 0, 100, 100);
        [self replaceImageAtIndex:flowee2 withUnlockedImageView:imageView7Unlocked];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[NSString stringWithFormat:@"flowee2Purchased"]];
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
        
        if((selectedShapeRow > 4 && ![[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"flowee1Purchased"]] &&[SKPaymentQueue canMakePayments]) ||(selectedShapeRow > 4 && ![[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"flowee2Purchased"]] &&[SKPaymentQueue canMakePayments]))
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
