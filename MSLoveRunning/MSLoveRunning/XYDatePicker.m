

#import "XYDatePicker.h"
#import "XYKeyboardTool.h"

@interface XYDatePicker()<CZKeyboardToolDelegate,UIPickerViewDelegate>
@property(nonatomic,weak) XYKeyboardTool *keyboardTool;
@property(nonatomic,weak) UIDatePicker *datePicker;
@property(nonatomic,strong) UIButton *cover;
@end

@implementation XYDatePicker

- (UIButton *)cover {
    if (_cover == nil) {
        _cover = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cover addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cover;
}
+(instancetype)datePicker{
    return [[XYDatePicker alloc] init];
//    return [[[NSBundle mainBundle] loadNibNamed:@"CZDatePicker" owner:nil options:nil] lastObject];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor whiteColor];
    
    XYKeyboardTool *keyboardTool = [XYKeyboardTool keyboardTool];
    keyboardTool.delegate = self;
    [self addSubview:keyboardTool];
    self.keyboardTool = keyboardTool;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    [datePicker addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    
//    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    datePicker.locale = [NSLocale systemLocale];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [self addSubview:datePicker];
    self.datePicker = datePicker;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat toolHeight = 40;
    self.keyboardTool.frame = CGRectMake(0, 0, self.frame.size.width, toolHeight);
    
    CGRect frame = self.datePicker.frame;
    frame.origin.y = toolHeight;
    self.datePicker.frame =  frame;
}

-(void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.cover.frame = window.bounds;
    [window addSubview:self.cover];
    
    CGFloat screenW = window.frame.size.width;
    CGFloat height = 256;
    
    CGRect frame = self.frame;
    frame.size = CGSizeMake(screenW, height);
    frame.origin.y = window.frame.size.height;
    self.frame = frame;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y -= height;
        self.frame = frame;
    }];
}

-(void)dismiss{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y += frame.size.height;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.cover removeFromSuperview];
        _cover = nil;
    }];
}


- (void)setCurrentTime:(NSDate *)currentTime {
    _currentTime = currentTime;
    self.datePicker.date = currentTime;
}

- (void)setMinTime:(NSDate *)minTime {
    _minTime = minTime;
    self.datePicker.minimumDate = minTime;
}

- (void)setMaxTime:(NSDate *)maxTime {
    _maxTime = maxTime;
    self.datePicker.maximumDate = maxTime;
}


- (void)valueChanged{
    if ([self.delegate respondsToSelector:@selector(datePickerDidValueChanged:)]) {
        [self.delegate datePickerDidValueChanged:self];
    }
}

#pragma mark - CZKeyboardToolDelegate 方法
- (void)keyboardToolDidClickCancelBtn:(XYKeyboardTool *)keyboardTool{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(datePicker:didClickButtonWithType:)]) {
        [self.delegate datePicker:self didClickButtonWithType:XYDatePickerButtonTypeCancelBtn];
    }
}

- (void)keyboardToolDidClickSureBtn:(XYKeyboardTool *)keyboardTool {
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(datePicker:didClickButtonWithType:)]) {
        [self.delegate datePicker:self didClickButtonWithType:XYDatePickerButtonTypeSureBtn];
    }
}

- (void)dealloc {
    NSLog(@"-----%@",self.class);
}
@end
