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
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    if(tableView == tasksAtWorkTable) {
        [[cell textLabel] setText:@"work"];
    }
    else
        [[cell textLabel] setText:@"Assigned Work"];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
        self.pageController.currentPage = page;
}
@end
