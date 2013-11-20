//
//  loginController.m
//  project#1
//
//  Created by Зульфат Мифтахутдинов on 09.11.13.
//  Copyright (c) 2013 Зульфат Мифтахутдинов. All rights reserved.
//

#import "loginController.h"
#import "AppDelegate.h"
#import "TasksViewController.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(MD5)

- (NSString*)MD5
{
    const char *ptr = [self UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    return output;
}

@end
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
    NSURL* url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://m.bossnote.ru/empl/getUserData.php?login=%@&passwrdHash=%@",[self.login text], [[self.password text] MD5]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"GET"];
    NSError* error = nil;
    NSData* infdata = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
    if (error) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error:%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    NSMutableDictionary* inf = [infdata mutableObjectFromJSONData];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setLoggedIN:[[inf objectForKey:@"loginSuccess"] boolValue]];
    if ([(NSNumber*)[inf objectForKey:@"loginSuccess"] boolValue] ) {
        NSMutableDictionary* userInfo = [[inf objectForKey:@"data"] objectForKey:@"user"];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] setUserInfo:userInfo];
        [(NSMutableDictionary*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo] setObject:[self.login text] forKey:@"login"];
        [(NSMutableDictionary*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo] setObject:[self.password text] forKey:@"password"];
        NSDictionary* tasks = [[inf objectForKey:@"data"] objectForKey:@"tasks"];// задаем в appdelegate массивы по задачам
        AppDelegate* mydel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [mydel setTasksAtPause:[tasks objectForKey:@"pause"]];
        [mydel setTasksAtWork:[tasks objectForKey:@"working"]];
        [mydel setAssignedTasks:[tasks objectForKey:@"assigned"]];
        
        [self presentViewController:(TasksViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController] animated:YES completion:nil];
    
    
    }
    else {
        if (infdata) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Authorization" message:@"Login or Password invalid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
}
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}
@end
