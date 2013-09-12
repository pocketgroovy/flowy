//
//  PGStoreObserver.m
//  Flowee
//
//  Created by Yoshihisa Miyamoto on 9/12/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "PGStoreObserver.h"


@implementation PGStoreObserver

-(id)init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

//SKPaymentTransactionObserver Protocol required method
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}


- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    // Your application should implement these two methods.
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        // Optionally, display an error here.
        NSNotification *trasError = [NSNotification notificationWithName:@"transaction_error" object:self];
        [[NSNotificationCenter defaultCenter]postNotification:trasError];
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


-(void)recordTransaction:(SKPaymentTransaction *)transaction
{
    [[NSUserDefaults standardUserDefaults]setValue:transaction.transactionReceipt forKey:@"FloweeShapeTransactionReceipt"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

-(void)provideContent:(NSString *)productIdentifier
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isPurchased"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}


@end
