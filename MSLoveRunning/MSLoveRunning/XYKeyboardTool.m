

#import "XYKeyboardTool.h"
@interface XYKeyboardTool()
- (IBAction)sureBtnClick;
- (IBAction)cancelBtnClick;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation XYKeyboardTool
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}
+ (instancetype)keyboardTool {
    return [[[NSBundle mainBundle] loadNibNamed:@"XYKeyboardTool" owner:nil options:nil] lastObject];
}

- (IBAction)sureBtnClick {
    if ([self.delegate respondsToSelector:@selector(keyboardToolDidClickSureBtn:)]) {
        [self.delegate keyboardToolDidClickSureBtn:self];
    }
}

- (IBAction)cancelBtnClick {
    if ([self.delegate respondsToSelector:@selector(keyboardToolDidClickCancelBtn:)]) {
        [self.delegate keyboardToolDidClickCancelBtn:self];
    }
}
@end
