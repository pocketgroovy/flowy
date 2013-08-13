//
//  EmitterLayer.m
//  Flowy
//
//  Created by Yoshihisa Miyamoto on 8/6/13.
//  Copyright 2013 Yoshi Miyamoto. All rights reserved.
//

#import "EmitterLayer.h"
#import "BBFImageStore.h"


static NSUInteger intNumber;

@interface EmitterLayer()
{
    CCSprite * bg;
    
}


@end 

@implementation EmitterLayer
@synthesize emitter;

#define NUMOFPARTICLES 130

+(CCScene *) scene
{
    
    CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EmitterLayer *layer = [EmitterLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer];
    
    NSLog(@"%s", __FUNCTION__);
	// return the scene
	return scene;
}

-(id) init
{
    if(self=[super initWithColor:ccc4(255, 255, 255, 255)])  {
        
        UIImage * picSelected = [[BBFImageStore sharedStore]imageForKey:@"mySelectedPhoto"];
        
        if(picSelected)
        {
            bg = [CCSprite spriteWithCGImage:picSelected.CGImage key:@"picSelected"];
            NSLog(@"picselected %s", __FUNCTION__);
            CGSize  windowSize = [[CCDirector sharedDirector] winSize];
            [bg setPosition:ccp(windowSize.width/2, windowSize.height/2)];
            [self addChild:bg z:0];
        }
        
        emitter = [[CCParticleFireworks alloc]initWithTotalParticles:NUMOFPARTICLES];
        
        UIImage * myShape = [[BBFImageStore sharedStore]imageForKey:@"myColoredShape"];
        
        emitter.texture = [[CCTextureCache sharedTextureCache]addCGImage:myShape.CGImage forKey:@"myShape"];
        emitter.scale = 10.0f;
        emitter.position = ccp(320, 0);
        emitter.speed = 100;
        emitter.speedVar = 10;
        emitter.life = 3;
        [self addChild:emitter z:1];
        NSLog(@"%s", __FUNCTION__);
        NSLog(@"%d parciles %s", intNumber,  __FUNCTION__);
        
        
    }
	return self;
}



- (void) dealloc
{
    // in case you have something to dealloc, do it in this method
    // in this particular example nothing needs to be released.
    // cocos2d will automatically release all the children (Label)
    
    // don't forget to call "super dealloc"
    [super dealloc];
}

@end
