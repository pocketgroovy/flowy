//
//  SelectorAppDelegate.m
//  Selector
//
//  Created by Yoshihisa Miyamoto on 4/23/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "SelectorAppDelegate.h"
#import "Flurry.h"
#import "PGStoreObserver.h"
#import <StoreKit/StoreKit.h>
#import "FloweeShapeStore.h"

@implementation SelectorAppDelegate
@synthesize window;
@synthesize audioPlayer;
@synthesize productList;

#define kMyFeatureIdentifier @"Flowee_Shape1"
#define kMyFeatureIdentifier2 @"Flowee_Shape2"
#define kMyFeatureIdentifier3 @"Flowee_Shape3"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //in-app Store observer
    if ([SKPaymentQueue canMakePayments]) {
        PGStoreObserver * observer = [PGStoreObserver sharedObserver];
        [[SKPaymentQueue defaultQueue]addTransactionObserver:observer];
        [observer requestProductData:kMyFeatureIdentifier];
        [observer requestProductData:kMyFeatureIdentifier2];
        [observer requestProductData:kMyFeatureIdentifier3];
        
        
        NSNotificationCenter *productNC = [NSNotificationCenter defaultCenter];
        [productNC addObserver:self selector:@selector(listStoreProducts:) name:@"product_response_received" object:observer];
        
        NSLog(@"Can Make Payments, -%s", __FUNCTION__);
        
        
        
    } else {
        NSString * locPurchaseError = NSLocalizedString(@"PURCHASE_ERROR", nil);
        NSString * locPurchaseErrorMessage = NSLocalizedString(@"PURCHASE_ERROR_MESSAGE", nil);
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:locPurchaseError message:locPurchaseErrorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }



    //Flurry analytic
    [Flurry startSession:@"5BBZNGZ2FK9YFQ7SKZY5"];
    
    
    //opening sound
    NSError * categoryErr;
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryAmbient error:&categoryErr];
    
    NSString * pathForAudio = [[NSBundle mainBundle]pathForResource:@"splash_sound" ofType:@"mp3"];
    NSURL *audioURL = [NSURL fileURLWithPath:pathForAudio];
    
    NSError * err;
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:audioURL error:&err];
    [audioPlayer setDelegate:self];
    [audioPlayer setVolume:0.5f];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    
    productList = [[NSMutableArray alloc]init];
    
    
    return YES;
}

-(void)listStoreProducts:(NSNotification *)productResponseReceived
{
    NSLog(@"%@, %s", [[[productResponseReceived userInfo]objectForKey:@"Flowee_Product"]productIdentifier], __FUNCTION__);
    
   
    [productList addObject:[[productResponseReceived userInfo]objectForKey:@"Flowee_Product"]];
    
    NSLog(@"%d, %s",[productList count], __FUNCTION__);
    for (SKProduct *aProduct in productList)
    {
        [[FloweeShapeStore sharedStore]setShape:aProduct forKey:[aProduct productIdentifier]];
        NSLog(@"%@ in loop, %s",[aProduct productIdentifier], __FUNCTION__);
    }
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//for iOS6 rotation bug
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return  UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskPortrait;
}

@end
