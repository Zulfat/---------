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
@synthesize tasksAtWork,assignedTasks,status,scrollView,timeOfEnd,timeOfStart,statusButton,timer,statusBar,tasksAtWorkTable,assignedTasksTable,iconsdict;
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
    iconsdict = [[NSMutableDictionary alloc] init];
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
    [dict setObject:@"http://s1.goodfon.com/wallpaper/previews-middle/490970.jpg" forKey:@"statusIcon"];
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
        cell = [[[NSBundle mainBundle] loadNibNamed:@"cell" owner:self options:nil] objectAtIndex:0];
    }
    if(tableView == tasksAtWorkTable) {
        NSMutableDictionary* prov =[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] ;
        NSMutableData* imgSt =[prov objectForKey:[[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"statusIcon"]] ;
        NSMutableData* imgPr =[prov objectForKey:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
        NSMutableData* imgType = [prov objectForKey:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
        if (!imgSt) {
            NSURL *statusIconURL = [NSURL URLWithString:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row]objectForKey:@"statusIcon"]];// создание и посылка запросов
            NSMutableURLRequest* a = [NSURLRequest requestWithURL:statusIconURL cachePolicy:0 timeoutInterval:60];
            //imgSt = [NSMutableData alloc];
           //[prov setObject:imgSt forKey:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"statusIcon"]];
            [NSURLConnection connectionWithRequest:a delegate:self];
        
       
        }
        /*if (!imgPr) {
             NSURL* prIconURL = [NSURL URLWithString:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
             NSMutableURLRequest* prIconReq = [NSURLRequest requestWithURL:prIconURL cachePolicy:0 timeoutInterval:60];
            //imgPr = (UIImage*)[NSURLConnection sendSynchronousRequest:prIconReq returningResponse:nil error:nil];
            imgPr = [[NSMutableData alloc] init];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] setObject:imgPr forKey:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
            [NSURLConnection connectionWithRequest:prIconReq delegate:self];
        }*/
        /*if (!imgType) {
            NSURL* typeIconURL = [NSURL URLWithString:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
            NSMutableURLRequest* typeIconReq = [NSURLRequest requestWithURL:typeIconURL cachePolicy:0 timeoutInterval:60];
            //imgType = (UIImage*)[NSURLConnection sendSynchronousRequest:typeIconReq returningResponse:nil error:nil];
            imgType = [[NSMutableData alloc] init];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] setObject:imgType forKey:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
            
            [NSURLConnection connectionWithRequest:typeIconReq delegate:self];
        }*/
    
        [[(Cellcontr*)cell statusImage] setImage:[UIImage imageWithData:[prov objectForKey:[(NSDictionary*)[tasksAtWork objectAtIndex:indexPath.row] objectForKey:@"statusIcon"]]]];
        [[(Cellcontr*)cell typeImage] setImage:[UIImage imageWithData:imgType]];
        [[(Cellcontr*)cell prImage] setImage:[UIImage imageWithData:imgPr]];
        [[(Cellcontr*)cell keyLabel] setText:[(NSDictionary *)[tasksAtWork objectAtIndex:indexPath.row]objectForKey:@"key"]];
        [[(Cellcontr*)cell summaryLabel] setText:[(NSDictionary *)[tasksAtWork objectAtIndex:indexPath.row]objectForKey:@"summary"]];
        
    }
    else
    {
        NSMutableData* imgSt = [[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] objectForKey:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"statusIcon"]];
        NSMutableData* imgPr = [[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] objectForKey:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
        NSMutableData* imgType = [[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] objectForKey:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
        if (!imgSt) {
            NSURL *statusIconURL = [NSURL URLWithString:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row]objectForKey:@"statusIcon"]];// создание и посылка запросов
            NSMutableURLRequest* a = [NSURLRequest requestWithURL:statusIconURL cachePolicy:0 timeoutInterval:60];
            imgSt = (UIImage*)[NSURLConnection sendSynchronousRequest:a returningResponse:nil error:nil];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] setObject:imgSt forKey:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"statusIcon"]];
            
        }
        if (!imgPr) {
            NSURL* prIconURL = [NSURL URLWithString:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
            NSMutableURLRequest* prIconReq = [NSURLRequest requestWithURL:prIconURL cachePolicy:0 timeoutInterval:60];
            NSData* imgPr = (UIImage*)[NSURLConnection sendSynchronousRequest:prIconReq returningResponse:nil error:nil];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] setObject:imgPr forKey:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"prIcon"]];
        }
        if (!imgType) {
            NSURL* typeIconURL = [NSURL URLWithString:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
            NSMutableURLRequest* typeIconReq = [NSURLRequest requestWithURL:typeIconURL cachePolicy:0 timeoutInterval:60];
            NSData* imgType = (UIImage*)[NSURLConnection sendSynchronousRequest:typeIconReq returningResponse:nil error:nil];
            [[(AppDelegate*)[[UIApplication sharedApplication] delegate] icons] setObject:imgType forKey:[(NSDictionary*)[assignedTasks objectAtIndex:indexPath.row] objectForKey:@"typeIcon"]];
        }
        
        
        [[(Cellcontr*)cell statusImage] setImage:[UIImage imageWithData:imgSt]];
        [[(Cellcontr*)cell typeImage] setImage:[UIImage imageWithData:imgType]];
        [[(Cellcontr*)cell prImage] setImage:[UIImage imageWithData:imgPr]];
        [[(Cellcontr*)cell keyLabel] setText:[(NSDictionary *)[assignedTasks objectAtIndex:indexPath.row]objectForKey:@"key"]];
        [[(Cellcontr*)cell summaryLabel] setText:[(NSDictionary *)[assignedTasks objectAtIndex:indexPath.row]objectForKey:@"summary"]];
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
}
@end
