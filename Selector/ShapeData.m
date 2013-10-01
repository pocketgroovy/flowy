//
//  ShapeData.m
//  Flowee
//
//  Created by Yoshihisa Miyamoto on 9/30/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "ShapeData.h"

@interface ShapeData()
@property (nonatomic,strong)UIImageView * shapeSmiley;
@property (nonatomic,strong)UIImageView * shapeFlower;
@property (nonatomic,strong)UIImageView * shapeDiamond;
@property (nonatomic,strong)UIImageView * shapeEgg;
@property (nonatomic,strong)UIImageView * shapeFoxx;
@property (nonatomic,strong)UIImageView * shapeKaiju;
@property (nonatomic,strong)UIImageView * shapeFoxxEggLocked;
@property (nonatomic,strong)UIImageView * shapeKaijuEggLocked;
@property (nonatomic,strong)UIImageView * shapeFoxxEgg;
@property (nonatomic,strong)UIImageView * shapeKaijuEgg;
@property (nonatomic,strong)UIImageView * shapeRain;
@property (nonatomic,strong)UIImageView * shapeCupcake;
@property (nonatomic,strong)UIImageView * shapeMashroom;
@property (nonatomic,strong)UIImageView * shapeCho;
@property (nonatomic,strong)UIImageView * shapePig;
@property (nonatomic,strong)UIImageView * shapePigEggLocked;
@property (nonatomic,strong)UIImageView * shapePigEgg;

@end


@implementation ShapeData
@synthesize shapeArray;
@synthesize shapeSmiley;
@synthesize shapeFlower;
@synthesize shapeDiamond;
@synthesize shapeEgg;
@synthesize shapeFoxx;
@synthesize shapeKaiju;
@synthesize shapeFoxxEggLocked;
@synthesize shapeKaijuEggLocked;
@synthesize shapeFoxxEgg;
@synthesize shapeKaijuEgg;
@synthesize shapeRain;
@synthesize shapeCupcake;
@synthesize shapeMashroom;
@synthesize shapeCho;
@synthesize shapePig;
@synthesize shapePigEgg;
@synthesize shapePigEggLocked;

-(id)init
{
    shapeSmiley =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smileyStar.png"]];
    shapeSmiley.frame = CGRectMake(0, 0, 100, 100);

    shapeFlower =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"flower.png"]];
    shapeFlower.frame = CGRectMake(0, 0, 100, 100);

    shapeDiamond =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"diamond.png"]];
    shapeDiamond.frame = CGRectMake(0, 0, 100, 100);

    shapeEgg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"egg.png"]];
    shapeEgg.frame = CGRectMake(0, 0, 100, 100);

    shapeRain =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rain.png"]];
    shapeRain.frame = CGRectMake(0, 0, 100, 100);

    shapeCupcake =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sweetcupcake.png"]];
    shapeCupcake.frame = CGRectMake(0, 0, 100, 100);

    shapeMashroom =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mashroom.png"]];
    shapeMashroom.frame = CGRectMake(0, 0, 100, 100);

    shapeCho =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cho.png"]];
    shapeCho.frame = CGRectMake(0, 0, 100, 100);
    
    shapeFoxx =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"foxx.png"]];
    shapeFoxx.frame = CGRectMake(0, 0, 100, 100);
    
    shapeKaiju =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaiju.png"]];
    shapeKaiju.frame = CGRectMake(0, 0, 100, 100);

    
    shapePig =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pig.png"]];
    shapePig.frame = CGRectMake(0, 0, 100, 100);
    
    shapeFoxxEggLocked =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LockedFoxxEgg.png"]];
    shapeFoxxEggLocked.frame = CGRectMake(0, 0, 100, 100);
    
    shapeKaijuEggLocked =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LockedKaijuEgg.png"]];
    shapeKaijuEggLocked.frame = CGRectMake(0, 0, 100, 100);
    
    shapePigEggLocked =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LockedPigEgg.png"]];
    shapePigEggLocked.frame = CGRectMake(0, 0, 100, 100);

    shapeArray = [NSArray arrayWithObjects:shapeSmiley, shapeFlower, shapeDiamond, shapeEgg,shapeRain, shapeCupcake, shapeMashroom, shapeCho, shapeFoxx, shapeKaiju, shapePig, shapeFoxxEggLocked, shapeKaijuEggLocked, shapePigEggLocked, nil];


    shapeFoxxEgg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"foxxEgg.png"]];
    shapeFoxxEgg.frame = CGRectMake(0, 0, 100, 100);

    shapeKaijuEgg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaijuEgg.png"]];
    shapeKaijuEgg.frame = CGRectMake(0, 0, 100, 100);

    shapePigEgg =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pigEgg.png"]];
    shapePigEgg.frame = CGRectMake(0, 0, 100, 100);
    
    [self checkPurchasedItem:@"Flowee_Shape1" andReplaceWithUnLockedItem:shapeFoxxEgg atRow:flowee1];
    [self checkPurchasedItem:@"Flowee_Shape2" andReplaceWithUnLockedItem:shapeKaijuEgg atRow:flowee2];
    [self checkPurchasedItem:@"Flowee_Shape3s" andReplaceWithUnLockedItem:shapePigEgg atRow:flowee3];

    return self;
}

-(void)checkPurchasedItem:(NSString *)purchasedItem andReplaceWithUnLockedItem:(UIImageView*)unlockedItem atRow:(NSInteger)row
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:purchasedItem])
    {
        [self replaceImageAtIndex:row withUnlockedImageView:unlockedItem];
    }
}




-(void)replaceImageAtIndex:(NSInteger )index withUnlockedImageView:(UIImageView *)unlockedImageView
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:shapeArray];
    [tempArray removeObjectAtIndex:index];
    [tempArray insertObject:unlockedImageView atIndex:index];
    shapeArray = tempArray;
}


@end
