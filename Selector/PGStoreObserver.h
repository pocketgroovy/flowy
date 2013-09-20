//
//  PGStoreObserver.h
//  Flowee
//
//  Created by Yoshihisa Miyamoto on 9/12/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface PGStoreObserver : NSObject<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, strong)NSArray * myProducts;


+(PGStoreObserver *)sharedObserver;
-(void)checkPurchasedItems;
- (void)requestProductData:(NSString*)kMyFeatureIdentifier;
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response;

-(void)buyProduct:(SKProduct*)aProduct;
@end
