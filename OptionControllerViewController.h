//
//  OptionControllerViewController.h
//  project#1
//
//  Created by Зульфат Мифтахутдинов on 11.11.13.
//  Copyright (c) 2013 Зульфат Мифтахутдинов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionControllerViewController : UIViewController <NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *Photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *surname;
@property (weak, nonatomic) IBOutlet UILabel *department;
@property (weak, nonatomic) IBOutlet UILabel *statuslb;
@end
