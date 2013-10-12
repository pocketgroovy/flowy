//
//  CCNode+Scaling.h
//  Flowy
//
//  Created by Yoshihisa Miyamoto on 8/16/13.
//  Copyright 2013 Yoshi Miyamoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    
    CCScaleFitFull,
    CCScaleFitAspectFit,
} CCScaleFit;


@interface CCNode (Scaling)


-(void)scaleToSize:(CGSize)size fitType:(CCScaleFit)fitType;
@end
