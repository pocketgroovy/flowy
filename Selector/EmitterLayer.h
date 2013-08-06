//
//  EmitterLayer.h
//  Flowy
//
//  Created by Yoshihisa Miyamoto on 8/6/13.
//  Copyright 2013 Yoshi Miyamoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EmitterLayer : CCLayer
@property (nonatomic, strong)CCParticleSpringParticle * emitter;

+(CCScene *) scene;
@end
