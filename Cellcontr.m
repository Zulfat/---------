//
//  Cellcontr.m
//  project#1
//
//  Created by zulfat on 13.11.13.
//  Copyright (c) 2013 Зульфат Мифтахутдинов. All rights reserved.
//

#import "Cellcontr.h"

@implementation Cellcontr
@synthesize statusImage,keyLabel,summaryLabel,typeImage,prImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
