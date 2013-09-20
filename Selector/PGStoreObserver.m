//
//  PGStoreObserver.m
//  Flowee
//
//  Created by Yoshihisa Miyamoto on 9/12/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "PGStoreObserver.h"


@implementation PGStoreObserver
@synthesize myProducts;

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedObserver];
}

+(PGStoreObserver *)sharedObserver
{
    static PGStoreObserver *sharedObserver = nil;
    if(!sharedObserver)
    {
       sharedObserver = [[super allocWithZone:NULL]init];
        
    }
    return sharedObserver;
}


-(id)init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}


#pragma mark -


-(void)checkPurchasedItems
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark -

- (void)requestProductData:(NSString*)kMyFeatureIdentifier
{
    NSLog(@"IN-APP:requestProductData");
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kMyFeatureIdentifier]];
    request.delegate = self;
    [request start];
    NSLog(@"%@, -%s", kMyFeatureIdentifier, __FUNCTION__);
    NSLog(@"IN-APP:requestProductData END");
}


#pragma mark In-App Purchase Request Delegate Methods
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"IN-APP:productsRequest");
    myProducts = response.products;
    
    if([myProducts count] > 0)
    {
    NSDictionary *productInfo = [NSDictionary dictionaryWithObjectsAndKeys:[myProducts objectAtIndex:0], @"Flowee_Product" , nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"product_response_received" object:self userInfo:productInfo];
    }
    // Save a reference to the products list.
}

-(void)buyProduct:(SKProduct*)aProduct
{
    NSLog(@"IN-APP:buyProductData");
    SKPayment *payment = [SKPayment paymentWithProduct:aProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    payment = nil;
}


//SKPaymentTransactionObserver Protocol required method
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        NSLog(@"IN-APP:%s", __FUNCTION__);

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
    [self finishTransaction:transaction wasSuccessful:YES];
    NSLog(@"IN-APP:%s", __FUNCTION__);

}


- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
    NSLog(@"IN-APP:%s", __FUNCTION__);

}


- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
        if (transaction.error.code == SKErrorClientInvalid) {
             NSLog(@"Invalid client.-%s", __FUNCTION__);
        }
        else if (transaction.error.code == SKErrorPaymentInvalid) {
             NSLog(@"Payment invalid.-%s", __FUNCTION__);
        }
        else if (transaction.error.code == SKErrorPaymentNotAllowed) {
             NSLog(@"Payment not allowed.-%s", __FUNCTION__);
        }
        else if (transaction.error.code == SKErrorPaymentCancelled) {
            // [self showAlert:@"In-App Purchase" withMessage:@"This device is not allowed to make the payment."];
            NSLog(@"User Cancellation.");
        }
        else {
            // SKErrorUnknown
            NSLog(@"Unknown Reason.");
        }
    }
    else  {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}


-(void)recordTransaction:(SKPaymentTransaction *)transaction
{
    [[NSUserDefaults standardUserDefaults]setValue:transaction.transactionReceipt forKey:@"TransactionReceipt"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"IN-APP:%s", __FUNCTION__);

    
}

-(void)provideContent:(NSString *)productIdentifier
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:productIdentifier, @"PurchasedProduct" , nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductReady" object:self userInfo:userInfo];

    NSLog(@"IN-APP:%s", __FUNCTION__);

    
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
    }
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSNotification *restoreError = [NSNotification notificationWithName:@"restore_error" object:self];
    [[NSNotificationCenter defaultCenter]postNotification:restoreError];
}

// removes the transaction from the queue and posts a notification with the transaction result
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PurchaseSuccess" object:self userInfo:userInfo];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"someBeenPurchased"];
        NSLog(@"IN-APP Success:%s", __FUNCTION__);

    }
    else
    {
        // send out a notification for the failed transaction
         [[NSNotificationCenter defaultCenter] postNotificationName:@"transaction_error" object:self userInfo:userInfo];
        NSLog(@"IN-APP failed :%s", __FUNCTION__);

    }
}


@end
