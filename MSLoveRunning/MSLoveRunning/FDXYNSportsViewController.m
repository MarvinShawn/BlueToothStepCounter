//
//  FDXYNSportsViewController.m
//  FastestDoctor
//
//  Created by ww on 16/8/8.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "FDXYNSportsViewController.h"
#import "FDARCView.h"
#import "XYDatePicker.h"
#import "FDXYNCalendarView.h"
#import "NSDate+extension.h"
#import "FDBluetoothTool.h"
//目标步数的Key
#define userStepKey @"userStepKey"
//完成目标后保存当天日期的Key
#define completedGoalKey @"completedGoalKey"
#define clockTimeLabelKey @"clockTimeLabelKey"
@interface FDXYNSportsViewController ()<XYDatePickerDelegate>
@property (weak, nonatomic) IBOutlet FDARCView *arcView;
@property (nonatomic, strong)NSMutableArray *seletedDays;//选择的日期
@property (weak, nonatomic) IBOutlet UILabel *clockTimeLabel;
@property (nonatomic, strong)FDXYNCalendarView    *calendarView;//日历控件
@property(nonatomic,copy) NSString *clockDateStr;

@end

@implementation FDXYNSportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我爱运动";
    
    //这里默认给的8000步,最好给个可以修改的界面,我没加进来.
    self.arcView.goalStep = 8000;
    
    NSString *clockTimeStr = [[NSUserDefaults standardUserDefaults] objectForKey:clockTimeLabelKey];
    
    if (clockTimeStr) {
        
        self.clockTimeLabel.text = clockTimeStr;
        
    }

    //判断是否连接
    if ( ![[FDBluetoothTool sharedBluetoothTool] isConnect]) {
        
        //没连接就连接
        [[FDBluetoothTool sharedBluetoothTool] connectBluetooth];
    }
    
    
    self.arcView.num = [[FDBluetoothTool sharedBluetoothTool] getStepData];
    
    
    [self storeDate:self.arcView.num];
    
    //这个是获得步数的block回调,每次蓝牙里有数据更新的话会走这个block
    [[FDBluetoothTool sharedBluetoothTool] setGetStepBlock:^(int step) {
        
        //赋值
        self.arcView.num = step;
        
        //根据步数来判断是否达标,达标就存储日期
        [self storeDate:step];
        
    }];
    
}

//根据步数来判断是否要存日期
- (void)storeDate:(int) step {
    
    if (step > self.arcView.goalStep) {
        

        NSDate *date = [NSDate date];
        //实例化一个NSDateFormatter对象
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *newDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@-%@-%@",@(date.year),@(date.month),@(date.day)]];
        
        //每次打开程序,可能都会走这个方法,为了不让其重复添加,需要判断
        if (![self.seletedDays containsObject:@(([newDate timeIntervalSince1970])* 1000)]) {
            
            [self.seletedDays addObject:@(([newDate timeIntervalSince1970])* 1000)];
            [[NSUserDefaults standardUserDefaults] setObject:self.seletedDays forKey:completedGoalKey];
        }
    }
}


///  点击每天记录
///
///  @param sender
- (IBAction)dayRecordAction:(id)sender {
    
    
    
    //日期选择
    if (!_calendarView) {
        _calendarView = [[FDXYNCalendarView alloc] initWithFrame:CGRectMake(0, 0, ScreenW,ScreenH)];
        [self.view addSubview:_calendarView];
    }
    self.calendarView.defaultDates = _seletedDays;
    [self.calendarView show];
    
    
}


///  点击小米闹铃
///
///  @param sender
- (IBAction)xiaoMiClockAction:(id)sender {
    
    XYDatePicker *dataPicker = [XYDatePicker datePicker];
    
    dataPicker.delegate = self;
    
    [dataPicker show];
    
}

#pragma mark - DatePickerDelegate
- (void)datePicker:(XYDatePicker *)datePicker didClickButtonWithType:(XYDatePickerButtonType)buttonType {
    
    //点击了确定按钮
    if (buttonType == XYDatePickerButtonTypeSureBtn) {
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        if (notification) {
            
            notification.alertTitle = @"通知的标题";
            notification.alertBody = @"通知的具体内容";
            notification.fireDate = datePicker.datePicker.date;
            
            self.clockTimeLabel.text = [datePicker.datePicker.date stringFromDateFormat:@"HH:mm:ss"];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.clockTimeLabel.text forKey:clockTimeLabelKey];
            //循环次数
            notification.repeatInterval = NSCalendarUnitDay;
            
            notification.timeZone=[NSTimeZone defaultTimeZone];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
        }
        
        
        
    }
}

- (NSMutableArray *)seletedDays {
    
    if (_seletedDays == nil) {
        
        
        NSArray *selArr = [[NSUserDefaults standardUserDefaults] objectForKey:completedGoalKey];
        if (selArr) {
            _seletedDays = selArr.mutableCopy;
        }else {
            
            _seletedDays = [[NSMutableArray alloc] init];
        }
    }
    return _seletedDays;
    
}


@end
