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

static CGFloat const kDefaultDatePickerHeight = 216.f;
static CGFloat const kPopupAnimateDuration = 0.25f;
static NSString *const kDefaultBirthDateStr = @"1990/01/01";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate> {
  UITableView *_myTableView;
  NSDateFormatter *_myDateFormatter;
  NSString *_currentDateStr;
}

@property (nonatomic, strong) UIDatePicker *myDatePicker;
@property (nonatomic, strong) UIView *myDatePickerOverlayView;
@property (nonatomic, assign, readonly) BOOL isDatePickerShowing;

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
  self.navigationItem.title = @"SHODatePickerDemo";
}

#pragma mark - Initialize

- (void)initProperties {
  _myDateFormatter = [NSDateFormatter new];
  _myDateFormatter.dateFormat = @"yyyy/MM/dd";

  _currentDateStr = kDefaultBirthDateStr;
}

- (void)initUI {
  _myTableView = [[UITableView alloc] initWithFrame:kScreenBounds
                                              style:UITableViewStylePlain];

  _myTableView.dataSource = self;
  _myTableView.delegate = self;
  [self.view addSubview:_myTableView];

  // Dummy button for demo
  UIBarButtonItem *dummyBarButton =
  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                target:self
                                                action:nil];

  self.navigationItem.rightBarButtonItem = dummyBarButton;
}

#pragma mark - Custom Accessors

- (UIDatePicker *)myDatePicker {
  if (!_myDatePicker) {
    CGRect frame = CGRectMake(0,
                              kScreenHeight,    // 一開始配置在螢幕之外
                              kScreenWidth,
                              kDefaultDatePickerHeight);

    _myDatePicker = [[UIDatePicker alloc] initWithFrame:frame];
    _myDatePicker.backgroundColor = [UIColor whiteColor];
    _myDatePicker.date = [_myDateFormatter dateFromString:kDefaultBirthDateStr];
    _myDatePicker.maximumDate = [NSDate date];
    _myDatePicker.datePickerMode = UIDatePickerModeDate;
    _myDatePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_TW"];

    // 變更日期時觸發事件
    [_myDatePicker addTarget:self
                      action:@selector(datePickerValueChanged:)
            forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:_myDatePicker];
  }

  return _myDatePicker;
}

- (UIView *)myDatePickerOverlayView {
  if (!_myDatePickerOverlayView) {
    CGRect frame = CGRectMake(0,
                              0,
                              kScreenWidth,
                              kScreenHeight - kDefaultDatePickerHeight);

    _myDatePickerOverlayView = [[UIView alloc] initWithFrame:frame];
    _myDatePickerOverlayView.hidden = YES;

    // 便於展示用
    _myDatePickerOverlayView.backgroundColor =
    [UIColor colorWithRed:0.3 green:0.7 blue:0.9 alpha:0.3];

    // 將 OverlayView 直接加入目前的 keyWindow 當中
    // 以保護所有畫面上的元件不被誤點，包括 NavigationBar, TabBar 上的按鈕
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_myDatePickerOverlayView];

    // 點擊後收起用手勢
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(datePickerOverlayViewSingleTap:)];

    tapGesture.numberOfTapsRequired = 1;
    [_myDatePickerOverlayView addGestureRecognizer:tapGesture];
  }

  return _myDatePickerOverlayView;
}

- (BOOL)isDatePickerShowing {
  return !(self.myDatePickerOverlayView.isHidden);
}

#pragma mark - Actions

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender {
  _currentDateStr = [_myDateFormatter stringFromDate:sender.date];

  // 僅更新該列表格的顯示
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  [_myTableView reloadRowsAtIndexPaths:@[ indexPath ]
                      withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)datePickerOverlayViewSingleTap:(UITapGestureRecognizer *)tapGesture {
  [self hideDatePicker];
}

#pragma mark - Private Methods

- (void)hideKeyboard {
  [self.view endEditing:YES];
}

- (void)switchDatePicker:(BOOL)show {
  self.myDatePickerOverlayView.hidden = !show;

  CGAffineTransform transform = show
  ? CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -kDefaultDatePickerHeight)   // 彈出
  : CGAffineTransformIdentity;                                                            // 收起

  [UIView animateWithDuration:kPopupAnimateDuration animations:^{
    [self.myDatePicker setTransform:transform];
  }];
}

- (void)showDatePicker {
  if (self.isDatePickerShowing) { return; }

  [self hideKeyboard];
  [self switchDatePicker:YES];
}

- (void)hideDatePicker {
  if (!self.isDatePickerShowing) { return; }

  [self switchDatePicker:NO];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView
         titleForHeaderInSection:(NSInteger)section
{
  return @"For Demo";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifierStr = @"MyCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];

  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                  reuseIdentifier:cellIdentifierStr];
  }

  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  cell.textLabel.text = @"Birthday";
  cell.detailTextLabel.text = _currentDateStr;

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 && indexPath.row == 0) {
    [self showDatePicker];
  }
}

@end
