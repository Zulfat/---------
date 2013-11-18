//
//  loginController.h
//  project#1
//
//  Created by Зульфат Мифтахутдинов on 09.11.13.
//  Copyright (c) 2013 Зульфат Мифтахутдинов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"
@interface loginController : UIViewController //<NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UITextField *login;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIView *interView;
//@property (strong, nonatomic) NSURLConnection* loginConnection;
@end
