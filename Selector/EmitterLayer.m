//
//  EmitterLayer.m
//  Flowy
//
//  Created by Yoshihisa Miyamoto on 8/6/13.
//  Copyright 2013 Yoshi Miyamoto. All rights reserved.
//

#import "EmitterLayer.h"
#import "BBFImageStore.h"
#import "CCNode+Scaling.h"



@interface EmitterLayer()
{
    CCSprite * bg;
    UIImageView * imageView;
}


@end 

@implementation EmitterLayer
@synthesize emitter;


//change size and a number of particle for iphone and iPad
#define PARTICLE_SIZE (isIphone ? 8.0f:12.0f)
#define NUMBER_OF_PARTICLE (isIphone ? 100:180)

+(CCScene *) scene
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
    if(self=[super initWithColor:ccc4(255, 255, 255, 255)])  {
        
        UIImage * picSelected = [[BBFImageStore sharedStore]imageForKey:@"mySelectedPhoto"];
        CGSize  windowSize =[[CCDirector sharedDirector] winSize];;
        if(picSelected)
        {
            bg = [CCSprite spriteWithCGImage:picSelected.CGImage key:@"picSelected"];

            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
            {
                windowSize = CGSizeMake(768.0f, 704.0f);
                [bg setPosition:ccp(windowSize.height-320 + 0.5f, windowSize.width/2 + 0.5f)];

            }
            else{
            [bg setPosition:ccp(windowSize.width/2+0.5f, windowSize.height/2 + 0.5f)];

            }
            [self addChild:bg z:0];
            
            //CCNode scaling to fit the background size to the view
            [bg scaleToSize:windowSize fitType:CCScaleFitAspectFit];
        }
        
        emitter = [[CCParticleFireworks alloc]initWithTotalParticles:NUMBER_OF_PARTICLE];
        
        UIImage * myShape = [[BBFImageStore sharedStore]imageForKey:@"myColoredShape"];
        
        emitter.texture = [[CCTextureCache sharedTextureCache]addCGImage:myShape.CGImage forKey:@"myShape"];
        
        emitter.scale = PARTICLE_SIZE;
        emitter.position = ccp(windowSize.width/2, 0);
        emitter.speed = 50;
        emitter.speedVar = 10;
        emitter.life = 3;
        emitter.startColorVar = ccc4f(0.3, 0.3, 0.3, 1);
        if(windowSize.width > 320) //iPad gravity
        {
        emitter.gravity = ccp(0,-20);
        }
        else    //iPhone gravity
        {
        emitter.gravity = ccp(0,-30);
        }
        [self addChild:emitter z:1];
    }
    
	return self;
}

-(id) initWithImageView:(UIImageView*)myImageView
{
    imageView = myImageView;
    return [self init];
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
