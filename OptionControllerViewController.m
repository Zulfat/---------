//
//  OptionControllerViewController.m
//  project#1
//
//  Created by Зульфат Мифтахутдинов on 11.11.13.
//  Copyright (c) 2013 Зульфат Мифтахутдинов. All rights reserved.
//

#import "OptionControllerViewController.h"
#import "AppDelegate.h"
@interface OptionControllerViewController ()

@end

@implementation OptionControllerViewController
- (IBAction)logOut:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setUserInfo:nil];
    [[(AppDelegate*)[[UIApplication sharedApplication] delegate] window] setRootViewController: [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]
                                                                                                 instantiateViewControllerWithIdentifier:@"loginView"]];
    
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
