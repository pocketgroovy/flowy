//
//  ShapeData.h
//  Flowee
//
//  Created by Yoshihisa Miyamoto on 9/30/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShapeData : NSObject
typedef enum {
    flowee1 = 11,
    flowee2 = 12,
    flowee3 = 13
}Flowee_Store_Shapes;

@property(nonatomic, strong) NSArray * shapeArray;

-(void)replaceImageAtIndex:(NSInteger )index withUnlockedImageView:(UIImageView *)unlockedImageView;
@end
