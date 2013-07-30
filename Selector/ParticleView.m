//
//  ParticleView.m
//  EmitterEffects
//
//  Created by Yoshihisa Miyamoto on 7/30/13.
//  Copyright (c) 2013 pocketgroovy. All rights reserved.
//

#import "ParticleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ParticleView
{
    CAEmitterLayer * particleLayer;
    
}

-(void)awakeFromNib
{
    
    particleLayer = (CAEmitterLayer*)self.layer;
    particleLayer.emitterPosition = CGPointMake(self.layer.frame.size.width/2, self.layer.frame.size.height);
    particleLayer.emitterSize = CGSizeMake(10, 10);
   // particleLayer.renderMode = kCAEmitterLayerAdditive;

    CAEmitterCell * particle = [CAEmitterCell emitterCell];
    particle.birthRate = 0;
    particle.lifetime = 3.0;
    particle.lifetimeRange = 0.5;
    particle.color = [[UIColor colorWithRed:0.5 green:0.2 blue:1.0 alpha:0.2]CGColor];
    particle.contents = (id)[[UIImage imageNamed:@"star.png"] CGImage];
    
    particle.velocity = 150;
    particle.velocityRange = 20;
    particle.emissionLongitude = -90;
    particle.emissionRange = M_PI_2;
    particle.scaleSpeed = 0.3;
    particle.spin = 0.8;
    particle.spinRange = 5;
    particle.greenSpeed = 1;
//    particle.greenRange = 15;
    particle.redSpeed = 0.8;
    particle.blueSpeed = 1;
    
    [particle setName:@"particle"];
    
    particleLayer.emitterCells = [NSArray arrayWithObject:particle];
    NSLog(@"%s", __FUNCTION__);

    
}

-(void)setEmitterPositionFromTouch:(UITouch *)touch
{
    particleLayer.emitterPosition = [touch locationInView:self];
    NSLog(@"%s", __FUNCTION__);
}


-(void)setIsEmitting:(BOOL)isEmitting;
{
    [particleLayer setValue:[NSNumber numberWithInt:isEmitting?50:0] forKeyPath:@"emitterCells.particle.birthRate"];
}

+(Class)layerClass
{
    NSLog(@"%s", __FUNCTION__);
    return [CAEmitterLayer class];
}


//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//
//        [self awakeFromNib];
//    }
//    return self;
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
