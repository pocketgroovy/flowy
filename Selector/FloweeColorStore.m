//
//  FloweeColorStore.m
//  Flowee
//
//  Created by Yoshihisa Miyamoto on 9/19/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "FloweeColorStore.h"

@implementation FloweeColorStore

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+(FloweeColorStore *)sharedStore
{
    static FloweeColorStore *sharedStore = nil;
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

-(void)setColor:(UIColor *) i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
}
-(UIColor *)colorForKey:(NSString *)s
{
    return [dictionary objectForKey:s];
}
-(void)deleteColorForKey:(NSString *)s
{
    if(!s)
        return;
    [dictionary removeObjectForKey:s];
}


@end

