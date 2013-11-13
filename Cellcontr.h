//
//  Cellcontr.h
//  project#1
//
//  Created by zulfat on 13.11.13.
//  Copyright (c) 2013 Зульфат Мифтахутдинов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cellcontr : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UIImageView *prImage;

@end
