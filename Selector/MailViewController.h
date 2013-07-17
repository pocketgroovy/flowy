//
//  MailViewController.h
//  Selector
//
//  Created by Yoshihisa Miyamoto on 5/12/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MailViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic)NSString * mailSubject;
@property (nonatomic)NSMutableArray * mailAddresses;
@property (nonatomic)NSString * mailContents;

@end
