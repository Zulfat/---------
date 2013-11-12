//
//  loginController.m
//  project#1
//
//  Created by Зульфат Мифтахутдинов on 09.11.13.
//  Copyright (c) 2013 Зульфат Мифтахутдинов. All rights reserved.
//

#import "loginController.h"
#import "AppDelegate.h"
@interface loginController ()

@end

@implementation loginController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIButton* button = [[UIButton alloc] initWithFrame:[[self interView] frame]];
    [button addTarget:self action:@selector(dismissKeyboard) forControlEvents:0];
    //[[self view] addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)saveUserInfo:(id)sender{
    [(NSMutableDictionary*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo]setObject:[self.login text] forKey:@"login"];
    [(NSMutableDictionary*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo]setObject:[self.password text] forKey:@"password"];
}
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}
@end
