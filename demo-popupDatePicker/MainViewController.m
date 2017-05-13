//
//  MainViewController.m
//  demo-popupDatePicker
//
//  Created by shoshino21 on 5/14/17.
//  Copyright © 2017 shoshino21. All rights reserved.
//

#import "MainViewController.h"

#define kScreenBounds     [UIScreen mainScreen].bounds
#define kScreenWidth      kScreenBounds.size.width
#define kScreenHeight     kScreenBounds.size.height
#define kStatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height

static CGFloat const kDefaultDatePickerHeight = 216.f;
static CGFloat const kPopupAnimateDuration = 0.25f;
static NSString *const kDefaultBirthDateStr = @"1990/01/01";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate> {
  UITableView *_myTableView;
  NSDateFormatter *_myDateFormatter;
}

@property (nonatomic, strong) UIDatePicker *myDatePicker;
@property (nonatomic, strong) UIView *myDatePickerOverlayView;

@end

@implementation MainViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  [self initProperties];
  [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.navigationItem.title = @"SHODatePicker";
}

#pragma mark - Initialize

- (void)initProperties {
  _myDateFormatter = [NSDateFormatter new];
  _myDateFormatter.dateFormat = @"yyyy/MM/dd";
}

- (void)initUI {
  _myTableView = [[UITableView alloc] initWithFrame:kScreenBounds
                                              style:UITableViewStylePlain];

  _myTableView.dataSource = self;
  _myTableView.delegate = self;
  _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:_myTableView];
}

#pragma mark - Custom Accessors

- (UIDatePicker *)myDatePicker {
  if (!_myDatePicker) {
    CGRect frame = CGRectMake(0,
                              CGRectGetHeight(self.view.frame) - kDefaultDatePickerHeight,
                              kScreenWidth,
                              kDefaultDatePickerHeight);

    _myDatePicker = [[UIDatePicker alloc] initWithFrame:frame];
    _myDatePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_TW"];
    _myDatePicker.backgroundColor = [UIColor whiteColor];
    _myDatePicker.date = [_myDateFormatter dateFromString:kDefaultBirthDateStr];
    _myDatePicker.maximumDate = [NSDate date];
    _myDatePicker.datePickerMode = UIDatePickerModeDate;

    [_myDatePicker addTarget:self
                      action:@selector(datePickerValueChanged:)
            forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:_myDatePicker];
  }

  return _myDatePicker;
}

- (UIView *)myDatePickerOverlayView {
  if (!_myDatePickerOverlayView) {
    _myDatePickerOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        kScreenWidth,
                                                                        kScreenHeight - kDefaultDatePickerHeight)];

    _myDatePickerOverlayView.hidden = YES;

    // 加上顏色便於展示用
    _myDatePickerOverlayView.backgroundColor = [UIColor colorWithRed:0.6 green:0.3 blue:0.3 alpha:0.5];

    // 將 OverlayView 直接加入目前的 keyWindow 當中
    // 以保護到所有畫面上的元件不被誤點，也包括 NavigationBar, TabBar 上的按鈕
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_myDatePickerOverlayView];

    // 加入手勢，點擊後收回 DatePicker
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(datePickerOverlayViewSingleTap:)];

    tapGesture.numberOfTapsRequired = 1;
    [_myDatePickerOverlayView addGestureRecognizer:tapGesture];
  }

  return _myDatePickerOverlayView;
}

#pragma mark - Private Methods

- (void)hideKeyboard {
  // 隱藏螢幕鍵盤
  [self.view endEditing:YES];
}

- (void)showDatePicker {

}

- (void)hideDatePicker {

}

- (void)datePickerValueChanged:(UIDatePicker *)sender {
  NSString *currentDateStr = [_myDateFormatter stringFromDate:sender.date];
  NSLog(@"%@", currentDateStr);
}

- (void)datePickerOverlayViewSingleTap:(UITapGestureRecognizer *)tapGesture {

}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return @"For Demo";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifierStr;
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];

  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                  reuseIdentifier:cellIdentifierStr];
  }

  cell.textLabel.text = @"Birthday";
  cell.detailTextLabel.text = @"12123";

  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  self.myDatePicker.hidden = NO;
  self.myDatePickerOverlayView.hidden = NO;
}

@end
