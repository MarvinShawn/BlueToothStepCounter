

#import <UIKit/UIKit.h>
typedef enum {
    XYDatePickerButtonTypeSureBtn,
    XYDatePickerButtonTypeCancelBtn,
} XYDatePickerButtonType;

@class XYDatePicker;
@protocol XYDatePickerDelegate <NSObject>
@optional
-(void)datePickerDidValueChanged:(XYDatePicker *)datePicker;
-(void)datePicker:(XYDatePicker *)datePicker didClickButtonWithType:(XYDatePickerButtonType)buttonType;
@end
@interface XYDatePicker : UIView
/**
 *  触发日期选择控件弹出的对象
 */
@property(nonatomic,weak) id focusObject;

@property(nonatomic,weak,readonly) UIDatePicker *datePicker;

@property(nonatomic,weak) id<XYDatePickerDelegate> delegate;

/**
 *  快速创建日期选择控件
 */
+(instancetype)datePicker;

/**
 *  显示
 */
-(void)show;
/**
 *  隐藏
 */
-(void)dismiss;
/**
 *  当前时间
 */
@property(nonatomic,strong) NSDate *currentTime;
/**
 *  最小显示时间
 */
@property(nonatomic,strong) NSDate *minTime;

/**
 *  最大显示时间
 */
@property(nonatomic,strong) NSDate *maxTime;

@end
