//
//  Snapshot.h
//  DemoView
//
//  Created by YOSHIHISA MIYAMOTO on 5/8/13.
//  Copyright (c) 2013 YOSHIHISA MIYAMOTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
@interface Snapshot : UIView

+(UIImage*)takeAsUIImage;
+(NSData*)takeAsPNG;


@end
