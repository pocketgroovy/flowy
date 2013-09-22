//
//  ShapeViewController.h
//  Selector
//
//  Created by Yoshihisa Miyamoto on 4/23/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShapeViewController;

@protocol ShapeViewControllerDelegate <NSObject>

-(void)shapeViewController:(ShapeViewController *)controller didFinishSelecting:(UIImage*)shape inRow:(NSInteger)row;

@end

//flowee shapes from store
typedef enum {
    flowee1 = 5,
    flowee2 = 6
}Flowee_Store_Shapes;

@interface ShapeViewController : UIViewController
@property (nonatomic, readonly) UIImage * selectedShape;
@property (nonatomic) id<ShapeViewControllerDelegate>shapeDelegate;

@end
