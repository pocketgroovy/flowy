//
//  EmitterLayer.m
//  Flowy
//
//  Created by Yoshihisa Miyamoto on 8/6/13.
//  Copyright 2013 Yoshi Miyamoto. All rights reserved.
//

#import "EmitterLayer.h"
#import "BBFImageStore.h"


@implementation EmitterLayer
@synthesize emitter;

+(CCScene *) scene;
{
    CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EmitterLayer *layer = [EmitterLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if(self=[super init])  {
        
        UIImage * picSelected = [[BBFImageStore sharedStore]imageForKey:@"mySelectedPhoto"];
        
        CCSprite * bg = [CCSprite spriteWithCGImage:picSelected.CGImage key:@"picSelected"];
        CGSize  windowSize = [[CCDirector sharedDirector] winSize];
        [bg setPosition:ccp(windowSize.width/2, windowSize.height/2)];
        [self addChild:bg z:0];
        
        emitter = [[CCParticleSpringParticle alloc]initWithTotalParticles:10];
        
        UIImage * myShape = [[BBFImageStore sharedStore]imageForKey:@"myColoredShape"];
        emitter.texture = [[CCTextureCache sharedTextureCache]addCGImage:myShape.CGImage forKey:@"myShape"];
        emitter.scale = 5.0f;
        emitter.position = ccp(150, 160);
        emitter.speed = 50;
        emitter.speedVar = 10;
        emitter.life = 10;
        [self addChild:emitter z:1];
        NSLog(@"%s", __FUNCTION__);
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
