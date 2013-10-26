//
//  EmitterLayer.h
//  Flowy
//
//  Created by Yoshihisa Miyamoto on 8/6/13.
//  Copyright 2013 Yoshi Miyamoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EmitterLayer : CCLayerColor

@property (nonatomic, strong)CCParticleFireworks * emitter;
+(CCScene *) scene;

@end
