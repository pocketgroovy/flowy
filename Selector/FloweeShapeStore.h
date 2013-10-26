//
//  FloweeShapeStore.h
//  Flowee
//
//  Created by Yoshihisa Miyamoto on 9/17/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>



@interface FloweeShapeStore : NSObject

{
    NSMutableDictionary * dictionary;
}





@property (nonatomic)BOOL hasProducts;
@property (nonatomic)NSUInteger numberOfProducts;

+(FloweeShapeStore*)sharedStore;

-(void)setShape:(SKProduct *) i forKey:(NSString *)s;
-(SKProduct *)shapeForKey:(NSString *)s;
-(void)deleteShapeForKey:(NSString *)s;
@end
