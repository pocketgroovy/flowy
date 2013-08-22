//
//  CCNode+Scaling.m
//  Flowy
//
//  Created by Yoshihisa Miyamoto on 8/16/13.
//  Copyright 2013 Yoshi Miyamoto. All rights reserved.
//

#import "CCNode+Scaling.h"


@implementation  CCNode (Scaling)
-(void)scaleToSize:(CGSize)size fitType:(CCScaleFit)fitType
{
    CGSize targetSize =size;
    CGSize mySize = [self contentSize];
    
    float xScale = [self scaleX];
    float yScale = [self scaleY];
 
    switch (fitType) {
        case CCScaleFitFull:
            xScale = targetSize.width/mySize.width;
            yScale = targetSize.height/mySize.height;
            break;
            
        case CCScaleFitAspectFit:
                xScale = yScale = targetSize.width/mySize.width;
            break;

        default:
            break;
    }
    [self setScaleX:xScale];
    [self setScaleY:yScale];
    
    
}

@end
