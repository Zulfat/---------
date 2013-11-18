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
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
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
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.bossnote.ru/empl/getUserData.php?login=%@&passwordhash=%@",[self.login text], [[self.password text] MD5]]];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setValue:[self.login text] forHTTPHeaderField:@"login"];
    [req setValue:[[self.password text] MD5] forHTTPHeaderField:@"PasswordHash"];
    NSLog(@"%@",req);
    NSData* infdata = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
    NSDictionary* inf = [infdata objectFromJSONData];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setLoggedIN:(BOOL)[inf objectForKey:@"loginSuccess"]];
    if ((BOOL)[inf objectForKey:@"loginSuccess"]) {
        NSDictionary* userInfo = [[inf objectForKey:@"data"] objectForKey:@"user"];
        NSArray* tasks = [[inf objectForKey:@"data"] objectForKey:@"tasks"];
        
        
        [(NSMutableDictionary*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo]setObject:[self.login text] forKey:@"login"];
        [(NSMutableDictionary*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo]setObject:[self.password text] forKey:@"password"];
        
        
        [self presentModalViewController:(TasksViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController] animated:YES];
    
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
