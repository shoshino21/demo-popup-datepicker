//
//  MainViewController.m
//  demo-popupDatePicker
//
//  Created by shoshino21 on 5/14/17.
//  Copyright © 2017 shoshino21. All rights reserved.
//

#define kScreenBounds     [UIScreen mainScreen].bounds
#define kScreenWidth      kScreenBounds.size.width
#define kScreenHeight     kScreenBounds.size.height
#define kStatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];


}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.navigationItem.title = @"SHODatePicker";
}

@end
