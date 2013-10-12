//
//  FloweeColorStore.h
//  Flowee
//
//  Created by Yoshihisa Miyamoto on 9/19/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloweeColorStore : NSObject

{
    NSMutableDictionary * dictionary;
}

+(FloweeColorStore *)sharedStore;

-(void)setColor:(UIColor *) i forKey:(NSString *)s;
-(UIColor *)colorForKey:(NSString *)s;
-(void)deleteColorForKey:(NSString *)s;
@end
