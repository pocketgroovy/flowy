//
//  ShapeViewController.h
//  Selector
//
//  Created by Yoshihisa Miyamoto on 4/23/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShapeData.h"
@class ShapeViewController;

@protocol ShapeViewControllerDelegate <NSObject>


-(void)shapeViewController:(ShapeViewController *)controller didFinishSelecting:(UIImage*)shape inRow:(NSInteger)row;

@end


@interface ShapeViewController : UIViewController
{
    ShapeData * shapes;
}
@property (nonatomic, readonly) UIImage * selectedShape;
@property  (nonatomic, weak)UIImageView * selectedImageView;
@property (nonatomic) id<ShapeViewControllerDelegate>shapeDelegate;

@end
