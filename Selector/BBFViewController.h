//
//  BBFViewController.h
//  
//
//  Created by Yoshihisa Miyamoto on 4/7/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BBFViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPopoverControllerDelegate>

@property (nonatomic, copy)NSString * key;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonOK;
@property (strong, nonatomic) UIImage * photo;
@end
