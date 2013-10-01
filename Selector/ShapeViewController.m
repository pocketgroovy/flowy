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
@property  (nonatomic, weak) IBOutlet UIImageView *wallpaper;
@property (weak, nonatomic) IBOutlet UIButton *go;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (assign, nonatomic) NSInteger selectedShapeRow;
@property (nonatomic, weak)NSArray * floweeOptionalShapes;
@property (nonatomic, strong)UIPickerView * pickerView;
@property (nonatomic, strong)NSMutableArray * tempArray;
@end

@implementation ShapeViewController
@synthesize selectedShape;
@synthesize imageArray;
@synthesize selectedImageView;
@synthesize wallpaper;
@synthesize go;
@synthesize cancel;
@synthesize shapeDelegate;
@synthesize selectedShapeRow;
@synthesize floweeOptionalShapes;
@synthesize pickerView;
@synthesize tempArray;


#define shopBorder 10

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
    
    shapes = [[ShapeData alloc]init];
    imageArray = [shapes shapeArray];
    

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
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"restoreAsked"];
    }
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"candies.png"]]];
    
    
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
    
    selectedImageView =[imageArray objectAtIndex:0];
    
    selectedShape = [selectedImageView image];     //default shape

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


//provide the purchased product after recieving response from store
-(void)provideProduct:(NSNotification *)productIsReady
{
    
    NSDictionary * productInfo = [productIsReady userInfo];
    
    NSString * productID = [productInfo objectForKey:@"PurchasedProduct"];


    if([productID isEqualToString:@"Flowee_Shape1"])
    {
        UIImageView * foxxEgg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"foxxEgg.png"]];
        foxxEgg.frame = CGRectMake(0, 0, 100, 100);
        [shapes replaceImageAtIndex:flowee1 withUnlockedImageView:foxxEgg];
        imageArray = [shapes shapeArray];
        [pickerView reloadAllComponents];
    }
    else if([productID isEqualToString:@"Flowee_Shape2"])
    {
        UIImageView *kaijuEgg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaijuEgg.png"]];
        kaijuEgg.frame = CGRectMake(0, 0, 100, 100);
        [shapes replaceImageAtIndex:flowee2 withUnlockedImageView:kaijuEgg];
        imageArray = [shapes shapeArray];
        [pickerView reloadAllComponents];
    }
    
    else if([productID isEqualToString:@"Flowee_Shape3s"])
    {
        UIImageView * pigEgg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pigEgg.png"]];
        pigEgg.frame = CGRectMake(0, 0, 100, 100);
        [shapes replaceImageAtIndex:flowee3 withUnlockedImageView:pigEgg];
        imageArray = [shapes shapeArray];
        [pickerView reloadAllComponents];
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
	
    AudioServicesPlaySystemSound(1057);
    
    selectedShapeRow = row;
    
    Reachability * reachNet = [Reachability reachabilityForInternetConnection];
    NetworkStatus statusNet = [reachNet currentReachabilityStatus];
    
    selectedImageView = [imageArray objectAtIndex:selectedShapeRow];

    
    if(statusNet != NotReachable)
    {
        switch (selectedShapeRow) {
            case 11:
                if(![[NSUserDefaults standardUserDefaults]boolForKey:@"Flowee_Shape1"] &&[SKPaymentQueue canMakePayments])
                {
                    NSLog(@"purchased1, -%s", __FUNCTION__);

                    [self purchaseMessage];
                }
                break;
            case 12:
                if(![[NSUserDefaults standardUserDefaults]boolForKey:@"Flowee_Shape2"] &&[SKPaymentQueue canMakePayments])
                {
                    NSLog(@"purchased2, -%s", __FUNCTION__);
                    [self purchaseMessage];
                }
                break;
            case 13:
                if(![[NSUserDefaults standardUserDefaults]boolForKey:@"Flowee_Shape3s"] &&[SKPaymentQueue canMakePayments])
                {
                    NSLog(@"purchased3, -%s", __FUNCTION__);

                    [self purchaseMessage];
                }
                break;
                
            default:
                break;
        }
    }
}



-(void)purchaseMessage
{
    NSString * locInAppPurchase = NSLocalizedString(@"INAPP_PURCHASE", nil);
    NSString * locInAppPurchaseMessage = NSLocalizedString(@"INAPP_PURCHASE_MESSAGE", nil);
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:locInAppPurchase message:locInAppPurchaseMessage delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
}


#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        switch (selectedShapeRow ) {
            case 11:
                [[PGStoreObserver sharedObserver]buyProduct:[[FloweeShapeStore sharedStore]shapeForKey:@"Flowee_Shape1"]];
                break;
            case 12:
                [[PGStoreObserver sharedObserver]buyProduct:[[FloweeShapeStore sharedStore]shapeForKey:@"Flowee_Shape2"]];
                break;
            case 13:
                [[PGStoreObserver sharedObserver]buyProduct:[[FloweeShapeStore sharedStore]shapeForKey:@"Flowee_Shape3s"]];
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
    
    
    //For Flurry - shape chosen by the user
    NSString * shapeName;
    switch (selectedShapeRow) {
        case 0:
            shapeName = @"Smiley";
            break;
        case 1:
            shapeName = @"Flower";
            break;
        case 2:
            shapeName = @"Diamond";
            break;
        case 3:
            shapeName = @"Egg";
            break;
        case 4:
            shapeName = @"Rain";
            break;
        case 5:
            shapeName = @"Cupcake";
            break;
        case 6:
            shapeName = @"Mashroom";
            break;
        case 7:
            shapeName = @"Cho";
            break;
        case 8:
            shapeName = @"Foxx";
            break;
        case 9:
            shapeName = @"Kaiju";
            break;
        case 10:
            shapeName = @"Pig";
            break;
        case 11:
            shapeName = @"FoxxEgg";
            break;
        case 12:
            shapeName = @"KaijuEgg";
            break;
        case 13:
            shapeName = @"PigEgg";
            break;
        default:
            break;
    }
    
        
    NSDictionary *shapeChosenByUser = [NSDictionary dictionaryWithObjectsAndKeys:shapeName, @"Selected Shape", nil ];
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
