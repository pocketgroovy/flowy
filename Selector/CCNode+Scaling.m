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
    
    
//    float targetAspect = targetSize.width/targetSize.height;
//    float myAspect = mySize.width/mySize.height;
    
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

//         case CCSCaleFitAspectFill:
//            if(targetAspect > myAspect)
//            {
//                xScale = yScale = targetSize.width/mySize.width;
//
//            }
//            else{
//                yScale = xScale = targetSize.width/mySize.width;
//
//            }
            
        default:
            break;
    }
    [self setScaleX:xScale];
    [self setScaleY:yScale];
    
    
}

@end
