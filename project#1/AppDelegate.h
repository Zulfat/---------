//
//  AppDelegate.h
//  project#1
//
//  Created by Зульфат Мифтахутдинов on 08.11.13.
//  Copyright (c) 2013 Зульфат Мифтахутдинов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableDictionary* userInfo;
@property (strong, nonatomic) NSMutableDictionary* icons;
@property (atomic) BOOL loggedIN;
@property (strong, nonatomic) NSMutableArray* tasksAtWork;
@property (strong,nonatomic) NSMutableArray* tasksAtPause;
@property (strong, nonatomic) NSMutableArray* assignedTasks;
@end
