//
//  BBFImageStore.h
//  blowByFlow
//
//  Created by Yoshihisa Miyamoto on 4/11/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBFImageStore : NSObject
{
    NSMutableDictionary * dictionary;
}

+(BBFImageStore *)sharedStore;

-(void)setImage:(UIImage *) i forKey:(NSString *)s;
-(UIImage *)imageForKey:(NSString *)s;
-(void)deleteImageForKey:(NSString *)s;
@end
