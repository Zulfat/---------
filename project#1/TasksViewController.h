//
//  TasksViewController.h
//  project#1
//
//  Created by Зульфат Мифтахутдинов on 08.11.13.
//  Copyright (c) 2013 Зульфат Мифтахутдинов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TasksViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,NSURLConnectionDataDelegate>
@property NSMutableArray* tasksAtWork;
@property NSMutableArray* assignedTasks;
@property BOOL status;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSDate* timeOfStart;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (strong, nonatomic) NSDate* timeOfEnd;
@property (strong,nonatomic) NSTimer* timer;
@property (weak, nonatomic) IBOutlet UILabel *statusBar;
@property (strong,nonatomic) UITableView* tasksAtWorkTable;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (strong, nonatomic) UITableView* assignedTasksTable;
@property (strong,nonatomic) UITableView* tasksAtPauseTable;
@property (strong,nonatomic) NSMutableArray* tasksAtPause;
@end
