

#import "XYPickerView.h"
#import "XYKeyboardTool.h"

@interface XYPickerView()<CZKeyboardToolDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,weak) XYKeyboardTool *keyboardTool;
@property(nonatomic,weak) UIPickerView *pickerView;
@property(nonatomic,strong) UIButton *cover;
@end

@implementation XYPickerView

- (UIButton *)cover {
    if (_cover == nil) {
        _cover = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cover addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cover;
}
#pragma mark - 初始化方法
+(instancetype)pickerView{
    return [[XYPickerView alloc] init];
}

+(instancetype)pickerViewWithDataArray:(NSArray *)dataArray {
    XYPickerView *pickerView  = [self pickerView];
    pickerView.dataArray = dataArray;
    return pickerView;
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
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self addSubview:pickerView];
    self.pickerView = pickerView;
}

#pragma mark - 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat toolHeight = 40;
    self.keyboardTool.frame = CGRectMake(0, 0, self.frame.size.width, toolHeight);
    
    CGRect frame = self.pickerView.frame;
    frame.origin.y = toolHeight;
    self.pickerView.frame =  frame;
}

#pragma mark - UIPickerView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataArray.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataArray[component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    // 获得子数组
    NSArray *subArray = self.dataArray[component];
    // 根据row获得对应的标题
    return subArray[row];
}

#pragma mark - setter 方法
- (void)setTitle:(NSString *)title {
    _title = title;
    self.keyboardTool.title = title;
}
#pragma mark - 显示和隐藏
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

#pragma mark - CZKeyboardToolDelegate 方法
- (void)keyboardToolDidClickCancelBtn:(XYKeyboardTool *)keyboardTool{
    [self dismiss];
   
}

- (void)keyboardToolDidClickSureBtn:(XYKeyboardTool *)keyboardTool {
    [self dismiss];
}

- (void)didMoveToSuperview {
    [self.pickerView selectRow:_selectedRow inComponent:0 animated:YES];
}

@end
