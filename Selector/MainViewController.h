//
//  MainViewController.h
//  Selector
//
//  Created by Yoshihisa Miyamoto on 5/2/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *photos;
@property (weak, nonatomic) IBOutlet UIButton *stars;
@property (weak, nonatomic) IBOutlet UILabel *instruction;
@property  (strong, nonatomic) UIImage * defaultImage;
@end
