

#import <UIKit/UIKit.h>

@interface XYPickerView : UIView

+(instancetype)pickerView;

+(instancetype)pickerViewWithDataArray:(NSArray *)dataArray;
/**
 *  要展示的数据(二维数组)
 */
@property(nonatomic,strong) NSArray *dataArray;
/**
 *  滚动那一行
 */
@property(nonatomic,assign) NSUInteger selectedRow;
/**
 *  标题
 */
@property(nonatomic,copy) NSString *title;

/**
 *  显示
 */
-(void)show;
/**
 *  隐藏
 */
-(void)dismiss;

@end
