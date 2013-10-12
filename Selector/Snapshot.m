//
//  Snapshot.m
//  DemoView
//
//  Created by YOSHIHISA MIYAMOTO on 5/8/13.
//  Copyright (c) 2013 YOSHIHISA MIYAMOTO. All rights reserved.
//

#import "Snapshot.h"

@implementation Snapshot

#pragma mark - Snapshot in UIImage


+(UIImage*)takeAsUIImage:(CCNode*)startNode
{
    CCDirector* director = [CCDirector sharedDirector];
    CGSize size = [director winSize];
    CCRenderTexture * rtx = [CCRenderTexture renderTextureWithWidth:size.width height:size.height];
    
    [rtx begin];
    [startNode visit];
    [rtx end];
    
    return [rtx getUIImage];
}


#pragma mark - Snapshot in PNG
+(NSData *)takeAsPNG:(CCNode*)statrtNode
{
    NSData * ouputImage = UIImagePNGRepresentation([Snapshot takeAsUIImage:statrtNode]);
    
    return ouputImage;
}





@end
