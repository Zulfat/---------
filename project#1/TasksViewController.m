//
//  TasksViewController.m
//  project#1
//
//  Created by Зульфат Мифтахутдинов on 08.11.13.
//  Copyright (c) 2013 Зульфат Мифтахутдинов. All rights reserved.
//

#import "TasksViewController.h"
#import "AppDelegate.h"
#import "loginController.h"
#import "Cellcontr.h"
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
@interface TasksViewController ()

@end

@implementation TasksViewController
@synthesize status,scrollView,timeOfEnd,timeOfStart,statusButton,timer,statusBar,tasksAtWorkTable,assignedTasksTable,tasksAtPauseTable,tasksAtWork,tasksAtPause,assignedTasks;
- (IBAction)start_end:(id)sender {
    bool st = [[[(AppDelegate *)[[UIApplication sharedApplication] delegate] userInfo] objectForKey:@"isWorking"] boolValue];
    NSString* login = [[(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo] objectForKey:@"login"];
    NSString* password = [[(AppDelegate*) [[UIApplication sharedApplication] delegate] userInfo] objectForKey:@"password"];
    NSMutableString* Status = [[NSMutableString alloc] init];
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] userInfo] setValue:[NSNumber numberWithBool:!st] forKey:@"isWorking"]  ;
    if (st) {// st был true, т.е. перход at work -> home
        [statusButton setBackgroundColor:[UIColor grayColor]];
        NSDateFormatter* formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"dd.MM.yyyy hh:mm"];
        
        if ([[statusButton subviews] count]==3) {
            [(UILabel*)[[statusButton subviews] objectAtIndex:2] setText:[formatter stringFromDate:timeOfEnd]];
        } else {
            UILabel* endLabel = [[UILabel alloc] init];
            [endLabel setFrame:CGRectMake(0, 80, 263, 50)];
            [endLabel setBackgroundColor:[UIColor clearColor]];
            [endLabel setFont:[UIFont systemFontOfSize:20.0]];
            [endLabel setTextColor:[UIColor blackColor]];
            [endLabel setTextAlignment:NSTextAlignmentCenter];
            [endLabel setText:[formatter stringFromDate:[NSDate date]]];
            [statusButton addSubview:endLabel];
        }
        [statusBar setText:@"Home"];
        [timer invalidate];
        [Status appendString:@"off"];
    }
    else {// home -> at work
        [statusButton setBackgroundColor:[UIColor greenColor]];
        timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(Update:) userInfo:Nil repeats:YES];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"dd.MM.yyyy hh:mm"];
        
        if ([[statusButton subviews]count]>=2) {
            [(UILabel*)[[statusButton subviews] objectAtIndex:1] setText:[formatter stringFromDate:timeOfStart]];
        } else {
            UILabel* startLabel = [[UILabel alloc] init];
            [startLabel setFrame:CGRectMake(0, 0, 263, 50)];
            [startLabel setBackgroundColor:[UIColor clearColor]];
            [startLabel setFont:[UIFont systemFontOfSize:20.0]];
            [startLabel setTextColor:[UIColor blackColor]];
            [startLabel setTextAlignment:NSTextAlignmentCenter];
            [startLabel setText:[formatter stringFromDate:[NSDate date]]];
            [statusButton addSubview:startLabel];
        }
        if ([[statusButton subviews] count] == 3) {
            [[[statusButton subviews] objectAtIndex:2] removeFromSuperview];
            [(NSMutableDictionary*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo] removeObjectForKey:@"timeofend"];
        }
        [statusBar setText:@"At Work"];
        [Status appendString:@"on"];
    }
    NSURL* changestatusUrl = [NSURL URLWithString:[[NSString stringWithFormat:@"http://m.bossnote.ru/empl/setUserStatus.php?login=%@&passwrdHash=%@&cmd=%@",login, [password MD5],Status] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* changeStatusReq = [NSMutableURLRequest requestWithURL:changestatusUrl];
    [changeStatusReq setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:changeStatusReq queue:nil completionHandler:nil];
}
-(void) Update: (NSTimer*) t {
    NSString* login = [[(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo] objectForKey:@"login"];
    NSString* password = [[(AppDelegate*) [[UIApplication sharedApplication] delegate] userInfo] objectForKey:@"password"];
    NSURL* url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://m.bossnote.ru/empl/getUserData.php?login=%@&passwrdHash=%@",login, [password MD5]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"GET"];
    NSError* error = nil;
    NSData* infdata = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
    NSMutableArray* asTasks = [[[[infdata mutableObjectFromJSONData] objectForKey:@"data"] objectForKey:@"tasks"] objectForKey:@"assigned"];
    NSMutableArray* woTasks = [[[[infdata mutableObjectFromJSONData] objectForKey:@"data"] objectForKey:@"tasks"] objectForKey:@"working"];
    NSMutableArray* paTasks = [[[[infdata mutableObjectFromJSONData] objectForKey:@"data"] objectForKey:@"tasks"] objectForKey:@"pause"];
    if (![assignedTasks isEqual:asTasks]){
        assignedTasks = asTasks;
        [assignedTasksTable reloadData];
    }
    if (![tasksAtWork isEqual:woTasks]){
        tasksAtWork = woTasks;
        [tasksAtWorkTable reloadData];
    }
    if (![tasksAtPause isEqual:paTasks]){
        tasksAtPause = paTasks;
        [tasksAtPauseTable reloadData];
    }
    [(UILabel*)[[statusButton subviews] objectAtIndex:0] setText:[[[[infdata mutableObjectFromJSONData] objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"workedTime" ]];
    if ([[[[[infdata objectFromJSONData] objectForKey:@"data"] objectForKey:@"user"] objectForKey:@"isWorking" ] boolValue])
        [statusButton setBackgroundColor:[UIColor greenColor]];
    else
        [statusButton setBackgroundColor:[UIColor grayColor]];
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
    [scrollView setDelegate:self];
    NSDateFormatter* formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"dd:MMM:yyyy HH:mm"];
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc ] init];
    [formatter1 setDateFormat:@"yyyy"];
    NSDictionary* prov = [(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo];
    NSString* timeOfStartstr = [NSString stringWithFormat:@"%@:%@ %@",[prov objectForKey:@"startDate"],[formatter1 stringFromDate:[NSDate date]],[prov objectForKey:@"startTime"]];
     NSString* timeOfEndstr = [NSString stringWithFormat:@"%@:%@ %@",[prov objectForKey:@"endDate"],[formatter1 stringFromDate:[NSDate date]],[prov objectForKey:@"endTime"]];
    timeOfStart=   [formatter dateFromString:timeOfStartstr];
    timeOfEnd = [formatter dateFromString:timeOfEndstr];
    tasksAtPause = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tasksAtPause];
    tasksAtWork = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tasksAtWork];
    assignedTasks = [(AppDelegate*) [[UIApplication sharedApplication] delegate] assignedTasks];
    if ([[[(AppDelegate *)[[UIApplication sharedApplication] delegate] userInfo] objectForKey:@"isWorking"] boolValue]) {
         [statusButton setBackgroundColor:[UIColor greenColor]];
        [statusBar setText:@"At Work"];
    }
    else {
         [statusButton setBackgroundColor:[UIColor grayColor]];
        [statusBar setText:@"Home"];
    }
    UILabel* Timerlabel = [[UILabel alloc] init]; // timerlabel для отображения кол-ва часов проведенных на работе
    [Timerlabel setFrame:CGRectMake(107, 37, 100, 50)];
    [Timerlabel setBackgroundColor:[UIColor clearColor]];
    [Timerlabel setFont:[UIFont systemFontOfSize:20.0]];
    [Timerlabel setTextColor:[UIColor blackColor]];
        [Timerlabel setText:[(NSMutableDictionary*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo] objectForKey:@"workedTime"]];
    [statusButton addSubview:Timerlabel]; // добавляем timerlabel как subview
    
    CGRect frame;;
    frame.origin.x = 0;
    frame.origin.y=0;
    frame.size= scrollView.frame.size;
    
    UITableView* tasksAtWorktb = [[UITableView alloc] initWithFrame:frame];// создаем и добавляем tasksAtWork как subview
    [tasksAtWorktb setDelegate:self];
    [tasksAtWorktb setDataSource:self];
    tasksAtWorkTable = tasksAtWorktb;
    [scrollView addSubview:tasksAtWorktb];
    
    frame.origin.x = tasksAtWorktb.frame.size.width; // создаем и добавляем assignedTasks как subview
    UITableView* assignedTaskstb = [[UITableView alloc] initWithFrame:frame];
    [assignedTaskstb setDataSource:self];
    [assignedTaskstb setDelegate:self];
    assignedTasksTable = assignedTaskstb;
    [scrollView addSubview:assignedTaskstb];
    
    
    frame.origin.x = tasksAtWorktb.frame.size.width*2; // создаем и добавляем tasksAtPause как subview
    UITableView* tasksAtPausetb = [[UITableView alloc] initWithFrame:frame];
    [tasksAtPausetb setDataSource:self];
    [tasksAtPausetb setDelegate:self];
    tasksAtPauseTable = tasksAtPausetb;
    [scrollView addSubview:tasksAtPausetb];
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width*3,scrollView.frame.size.height)] ;
    
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    if ([self timeOfStart] != nil) {
        UILabel* startLabel = [[UILabel alloc] init];
        [startLabel setFrame:CGRectMake(0, 0, 263, 50)];
        [startLabel setBackgroundColor:[UIColor clearColor]];
        [startLabel setFont:[UIFont systemFontOfSize:20.0]];
        [startLabel setTextColor:[UIColor blackColor]];
        [startLabel setTextAlignment:NSTextAlignmentCenter];
        [startLabel setText:[formatter stringFromDate:timeOfStart]];
        [statusButton addSubview:startLabel];
        timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(Update:) userInfo:Nil repeats:YES];

    }
    if ([self timeOfEnd] !=nil) {
        UILabel* endLabel = [[UILabel alloc] init];
        [endLabel setFrame:CGRectMake(0, 80, 263, 50)];
        [endLabel setBackgroundColor:[UIColor clearColor]];
        [endLabel setFont:[UIFont systemFontOfSize:20.0]];
        [endLabel setTextColor:[UIColor blackColor]];
        [endLabel setTextAlignment:NSTextAlignmentCenter];
        [endLabel setText:[formatter stringFromDate:timeOfEnd]];
        [statusButton addSubview:endLabel];

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count;
    if (tableView == tasksAtWorkTable) {
        count = [tasksAtWork count];
    }
    if (tableView == assignedTasksTable) {
        count = [assignedTasks count];
    }
    if (tableView == tasksAtPauseTable)
        count = [tasksAtPause count];
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = (Cellcontr*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"cell" owner:self options:nil] objectAtIndex:0];
    }
    NSMutableDictionary* prov =[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] ;
    if(tableView == tasksAtWorkTable) {
        
        NSMutableData* imgSt =[prov objectForKey:[[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"statusIcon"]] ;
        NSMutableData* imgPr =[prov objectForKey:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
        NSMutableData* imgType = [prov objectForKey:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
        if (!imgSt) {
            NSURL *statusIconURL = [NSURL URLWithString:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row]objectForKey:@"statusIcon"]];// создание и посылка запросов
            NSMutableURLRequest* a = [NSURLRequest requestWithURL:statusIconURL cachePolicy:0 timeoutInterval:60];
           [prov setObject:imgSt forKey:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"statusIcon"]];
            [NSURLConnection connectionWithRequest:a delegate:self];
        
       
        }
        /*if (!imgPr) {
             NSURL* prIconURL = [NSURL URLWithString:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
             NSMutableURLRequest* prIconReq = [NSURLRequest requestWithURL:prIconURL cachePolicy:0 timeoutInterval:60];
            //imgPr = [[NSMutableData alloc] init];
            //[[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] setObject:imgPr forKey:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
            [NSURLConnection connectionWithRequest:prIconReq delegate:self];
        }*/
        /*if (!imgType) {
            NSURL* typeIconURL = [NSURL URLWithString:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
            NSMutableURLRequest* typeIconReq = [NSURLRequest requestWithURL:typeIconURL cachePolicy:0 timeoutInterval:60];
            //imgType = [[NSMutableData alloc] init];
            //[[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] setObject:imgType forKey:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
            
            [NSURLConnection connectionWithRequest:typeIconReq delegate:self];
        }*/
    
        [[(Cellcontr*)cell statusImage] setImage:[UIImage imageWithData:[prov objectForKey:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"statusIcon"]]]];
        [[(Cellcontr*)cell typeImage] setImage:[UIImage imageWithData:imgType]];
        [[(Cellcontr*)cell prImage] setImage:[UIImage imageWithData:imgPr]];
        [[(Cellcontr*)cell keyLabel] setText:[(NSDictionary *)[tasksAtWork objectAtIndex:indexPath.row]objectForKey:@"key"]];
        [[(Cellcontr*)cell summaryLabel] setText:[(NSDictionary *)[tasksAtWork objectAtIndex:indexPath.row]objectForKey:@"summary"]];
        
    }
    if (tableView == assignedTasksTable)
    {
        NSMutableData* imgSt = [[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] objectForKey:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"statusIcon"]];
        NSMutableData* imgPr = [[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] objectForKey:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
        NSMutableData* imgType = [[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] objectForKey:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
        if (!imgSt) {
            NSURL *statusIconURL = [NSURL URLWithString:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row]objectForKey:@"statusIcon"]];// создание и посылка запросов
            NSMutableURLRequest* a = [NSURLRequest requestWithURL:statusIconURL cachePolicy:0 timeoutInterval:60];
            //imgSt = (UIImage*)[NSURLConnection sendSynchronousRequest:a returningResponse:nil error:nil];
            //[[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] setObject:imgSt forKey:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"statusIcon"]];
            [NSURLConnection connectionWithRequest:a delegate:self];
            
        }
        if (!imgPr) {
            NSURL* prIconURL = [NSURL URLWithString:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
            NSMutableURLRequest* prIconReq = [NSURLRequest requestWithURL:prIconURL cachePolicy:0 timeoutInterval:60];
            //NSData* imgPr = (UIImage*)[NSURLConnection sendSynchronousRequest:prIconReq returningResponse:nil error:nil];
            //[[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] setObject:imgPr forKey:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
            [NSURLConnection connectionWithRequest:prIconReq delegate:self];
        }
        if (!imgType) {
            NSURL* typeIconURL = [NSURL URLWithString:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
            NSMutableURLRequest* typeIconReq = [NSURLRequest requestWithURL:typeIconURL cachePolicy:0 timeoutInterval:60];
            //NSData* imgType = (UIImage*)[NSURLConnection sendSynchronousRequest:typeIconReq returningResponse:nil error:nil];
            //[[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] setObject:imgType forKey:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
            [NSURLConnection connectionWithRequest:typeIconReq delegate:self];
        }
        
        
        [[(Cellcontr*)cell statusImage] setImage:[UIImage imageWithData:imgSt]];
        [[(Cellcontr*)cell typeImage] setImage:[UIImage imageWithData:imgType]];
        [[(Cellcontr*)cell prImage] setImage:[UIImage imageWithData:imgPr]];
        [[(Cellcontr*)cell keyLabel] setText:[(NSDictionary *)[assignedTasks objectAtIndex:indexPath.row]objectForKey:@"key"]];
        [[(Cellcontr*)cell summaryLabel] setText:[(NSDictionary *)[assignedTasks objectAtIndex:indexPath.row]objectForKey:@"summary"]];
    }
    if (tableView == tasksAtPauseTable) {
        NSMutableData* imgSt =[prov objectForKey:[[tasksAtPause objectAtIndex:indexPath.row] objectForKey:@"statusIcon"]] ;
        NSMutableData* imgPr =[prov objectForKey:[(NSDictionary*)[tasksAtPause objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
        NSMutableData* imgType = [prov objectForKey:[(NSDictionary*)[tasksAtPause objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
        if (!imgSt) {
            NSURL *statusIconURL = [NSURL URLWithString:[(NSDictionary*)[tasksAtPause objectAtIndex:indexPath.row]objectForKey:@"statusIcon"]];// создание и посылка запросов
            NSMutableURLRequest* a = [NSURLRequest requestWithURL:statusIconURL cachePolicy:0 timeoutInterval:60];
            //[NSURLConnection connectionWithRequest:a delegate:self];
            
            
        }
        if (!imgPr) {
         NSURL* prIconURL = [NSURL URLWithString:[(NSDictionary*)[tasksAtPause objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
         NSMutableURLRequest* prIconReq = [NSURLRequest requestWithURL:prIconURL cachePolicy:0 timeoutInterval:60];
         //imgPr = [[NSMutableData alloc] init];
         //[[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] setObject:imgPr forKey:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
         [NSURLConnection connectionWithRequest:prIconReq delegate:self];
         }
        if (!imgType) {
         NSURL* typeIconURL = [NSURL URLWithString:[(NSDictionary*)[tasksAtPause objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
         NSMutableURLRequest* typeIconReq = [NSURLRequest requestWithURL:typeIconURL cachePolicy:0 timeoutInterval:60];
         //imgType = [[NSMutableData alloc] init];
         //[[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] setObject:imgType forKey:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
         
         [NSURLConnection connectionWithRequest:typeIconReq delegate:self];
         }
        
        [[(Cellcontr*)cell statusImage] setImage:[UIImage imageWithData:[prov objectForKey:[(NSDictionary*)[tasksAtPause objectAtIndex:indexPath.row] objectForKey:@"statusIcon"]]]];
        [[(Cellcontr*)cell typeImage] setImage:[UIImage imageWithData:imgType]];
        [[(Cellcontr*)cell prImage] setImage:[UIImage imageWithData:imgPr]];
        [[(Cellcontr*)cell keyLabel] setText:[(NSDictionary *)[tasksAtPause objectAtIndex:indexPath.row]objectForKey:@"key"]];
        [[(Cellcontr*)cell summaryLabel] setText:[(NSDictionary *)[tasksAtPause objectAtIndex:indexPath.row]objectForKey:@"summary"]];
    }
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
        self.pageController.currentPage = page;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
   if ( ![[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] objectForKey:[[connection currentRequest] URL]]) {
       NSMutableData* appendingdata = [NSMutableData data];
       [appendingdata appendData:data];
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] setObject:appendingdata forKey:[[connection currentRequest] URL]];
    }
    else
        [[[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] objectForKey:[[connection currentRequest] URL]] appendData:data];
    

}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [tasksAtWorkTable reloadData];
    [assignedTasksTable reloadData];
    [tasksAtPauseTable reloadData];
}
@end
