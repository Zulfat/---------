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
@interface TasksViewController ()

@end

@implementation TasksViewController
@synthesize tasksAtWork,assignedTasks,status,scrollView,timeOfEnd,timeOfStart,statusButton,timer,statusBar,tasksAtWorkTable,assignedTasksTable;
- (IBAction)start_end:(id)sender {
    bool st = [[[(AppDelegate *)[[UIApplication sharedApplication] delegate] userInfo] objectForKey:@"status"] boolValue];
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] userInfo] setValue:[NSNumber numberWithBool:!st] forKey:@"status"]  ;
   
    if (st) {// st был true, т.е. перход at work -> home
        timeOfEnd = [NSDate date];
          [(NSMutableDictionary*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo]setObject:timeOfEnd forKey:@"timeofend"];
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
            [endLabel setText:[formatter stringFromDate:timeOfEnd]];
            [statusButton addSubview:endLabel];
        }
        [statusBar setText:@"Home"];
        [timer invalidate];
    }
    else {// home -> at work
        timeOfStart = [NSDate date] ;
        [(NSMutableDictionary*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo] setObject:timeOfStart forKey:@"timeofstart"];
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
            [startLabel setText:[formatter stringFromDate:timeOfStart]];
            [statusButton addSubview:startLabel];
        }
        if ([[statusButton subviews] count] == 3) {
            [[[statusButton subviews] objectAtIndex:2] removeFromSuperview];
            [(NSMutableDictionary*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo] removeObjectForKey:@"timeofend"];
        }
        [statusBar setText:@"At Work"];
        [self Update:nil];
    }
}
-(void) Update: (NSTimer*) t {
    if (timeOfStart && !timeOfEnd) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:timeOfStart];
        interval++;
        [(UILabel*)[[statusButton subviews] objectAtIndex:0] setText:[NSString stringWithFormat:@"%i%i:%i%i",((int)interval/3600)/10,((int)interval/3600)%10,(((int)interval/60)%60)/10,(((int)interval/60)%60)%10]];
    }
    if (timeOfEnd && timeOfStart) {
         NSTimeInterval interval = [timeOfStart timeIntervalSinceDate:timeOfStart];
        interval++;
        [(UILabel*)[[statusButton subviews] objectAtIndex:0] setText:[NSString stringWithFormat:@"%i%i:%i%i",((int)interval/3600)/10,((int)interval/3600)%10,(((int)interval/60)%60)/10,(((int)interval/60)%60)%10]];
    }
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
    timeOfStart =   [(NSMutableDictionary*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo] objectForKey:@"timeofstart"];
    timeOfEnd =   [(NSMutableDictionary*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] userInfo] objectForKey:@"timeofend"];
    if ([[[(AppDelegate *)[[UIApplication sharedApplication] delegate] userInfo] objectForKey:@"status"] boolValue]) {
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
        [Timerlabel setText:@"00:00"];
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
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width*2,scrollView.frame.size.height)] ;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"dd.MM.yyyy hh:mm"];
    
    if ([self timeOfStart] != nil) {
        UILabel* startLabel = [[UILabel alloc] init];
        [startLabel setFrame:CGRectMake(0, 0, 263, 50)];
        [startLabel setBackgroundColor:[UIColor clearColor]];
        [startLabel setFont:[UIFont systemFontOfSize:20.0]];
        [startLabel setTextColor:[UIColor blackColor]];
        [startLabel setTextAlignment:NSTextAlignmentCenter];
        [startLabel setText:[formatter stringFromDate:timeOfStart]];
        [statusButton addSubview:startLabel];
        [self Update:nil];
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
        [self Update:nil];

    }
    tasksAtWork = [NSMutableArray array];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:@"1234" forKey:@"key"];
    [dict setObject:@"data:image/jpeg;base64,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" forKey:@"statusIcon"];
    [dict setObject:@"data:image/jpeg;base64,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" forKey:@"typeIcon"];
    [dict setObject:@"dfsdfdsds" forKey:@"summary"];
    [tasksAtWork addObject:dict];
    
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
    else {
        count = [assignedTasks count];
    }
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = (Cellcontr*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"cell" owner:self options:nil] objectAtIndex:0];
    }
    if(tableView == tasksAtWorkTable) {
        NSURL *statusIconURL = [NSURL URLWithString:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row]objectForKey:@"statusIcon"]];// создание и посылка запросов
        NSURL* prIconURL = [NSURL URLWithString:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
        NSURL* typeIconURL = [NSURL URLWithString:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
        NSMutableURLRequest* a = [NSURLRequest requestWithURL:statusIconURL cachePolicy:0 timeoutInterval:60];
        NSMutableURLRequest* prIconReq = [NSURLRequest requestWithURL:prIconURL cachePolicy:0 timeoutInterval:60];
        NSMutableURLRequest* typeIconReq = [NSURLRequest requestWithURL:typeIconURL cachePolicy:0 timeoutInterval:60];
        NSData* imgSt = (UIImage*)[NSURLConnection sendSynchronousRequest:a returningResponse:nil error:nil];
        NSData* imgPr = (UIImage*)[NSURLConnection sendSynchronousRequest:prIconReq returningResponse:nil error:nil];
        NSData* imgType = (UIImage*)[NSURLConnection sendSynchronousRequest:typeIconReq returningResponse:nil error:nil];
        
        
    
        [[(Cellcontr*)cell statusImage] setImage:[UIImage imageWithData:imgSt]];
        [[(Cellcontr*)cell typeImage] setImage:[UIImage imageWithData:imgType]];
        [[(Cellcontr*)cell prImage] setImage:[UIImage imageWithData:imgPr]];
        [[(Cellcontr*)cell keyLabel] setText:[(NSDictionary *)[tasksAtWork objectAtIndex:indexPath.row]objectForKey:@"key"]];
        [[(Cellcontr*)cell summaryLabel] setText:[(NSDictionary *)[tasksAtWork objectAtIndex:indexPath.row]objectForKey:@"summary"]];
        
    }
    else {
    
    
        NSURL *statusIconURL = [NSURL URLWithString:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row]objectForKey:@"statusIcon"]];// создание и посылка запросов
        NSURL* prIconURL = [NSURL URLWithString:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
        NSURL* typeIconURL = [NSURL URLWithString:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
        NSMutableURLRequest* a = [NSURLRequest requestWithURL:statusIconURL cachePolicy:0 timeoutInterval:60];
        NSMutableURLRequest* prIconReq = [NSURLRequest requestWithURL:prIconURL cachePolicy:0 timeoutInterval:60];
        NSMutableURLRequest* typeIconReq = [NSURLRequest requestWithURL:typeIconURL cachePolicy:0 timeoutInterval:60];
        NSData* imgSt = (UIImage*)[NSURLConnection sendSynchronousRequest:a returningResponse:nil error:nil];
        NSData* imgPr = (UIImage*)[NSURLConnection sendSynchronousRequest:prIconReq returningResponse:nil error:nil];
        NSData* imgType = (UIImage*)[NSURLConnection sendSynchronousRequest:typeIconReq returningResponse:nil error:nil];
        
        
        [[(Cellcontr*)cell statusImage] setImage:[UIImage imageWithData:imgSt]];
        [[(Cellcontr*)cell typeImage] setImage:[UIImage imageWithData:imgType]];
        [[(Cellcontr*)cell prImage] setImage:[UIImage imageWithData:imgPr]];
        [[(Cellcontr*)cell keyLabel] setText:[(NSDictionary *)[tasksAtWork objectAtIndex:indexPath.row]objectForKey:@"key"]];
        [[(Cellcontr*)cell summaryLabel] setText:[(NSDictionary *)[tasksAtWork objectAtIndex:indexPath.row]objectForKey:@"summary"]];
    }
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
        self.pageController.currentPage = page;
}
@end
