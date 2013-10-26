//
//  FloweeShapeStore.m
//  Flowee
//
//  Created by Yoshihisa Miyamoto on 9/17/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "FloweeShapeStore.h"

@implementation FloweeShapeStore
@synthesize hasProducts;
@synthesize numberOfProducts;

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+(FloweeShapeStore *)sharedStore
{
    static FloweeShapeStore *sharedStore = nil;
    if(!sharedStore)
    {
        sharedStore = [[super allocWithZone:NULL]init];
    }
    return sharedStore;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        dictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)setShape:(SKProduct *) i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
    if(!hasProducts)
    {
        hasProducts = YES;
    }
    numberOfProducts = [dictionary count];


}
-(SKProduct *)shapeForKey:(NSString *)s
{
    return [dictionary objectForKey:s];
}
-(void)deleteShapeForKey:(NSString *)s
{
    if(!s)
        return;
    [dictionary removeObjectForKey:s];
    numberOfProducts = [dictionary count];
    if([dictionary count] ==0)
        hasProducts = NO;
}


@end
