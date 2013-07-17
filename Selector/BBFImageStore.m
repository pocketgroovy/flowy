//
//  BBFImageStore.m
//  blowByFlow
//
//  Created by Yoshihisa Miyamoto on 4/11/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "BBFImageStore.h"

@implementation BBFImageStore

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+(BBFImageStore *)sharedStore
{
    static BBFImageStore *sharedStore = nil;
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

-(void)setImage:(UIImage *) i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
}
-(UIImage *)imageForKey:(NSString *)s
{
    return [dictionary objectForKey:s];
}
-(void)deleteImageForKey:(NSString *)s
{
    if(!s)
        return;
    [dictionary removeObjectForKey:s];
}


@end
