//
//  ParticleView.h
//  EmitterEffects
//
//  Created by Yoshihisa Miyamoto on 7/30/13.
//  Copyright (c) 2013 pocketgroovy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParticleView : UIView
-(void)setEmitterPositionFromTouch:(UITouch *)touch;
-(void)setIsEmitting:(BOOL)isEmitting;

@end
