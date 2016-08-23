

#import <UIKit/UIKit.h>
@class XYKeyboardTool;
@protocol CZKeyboardToolDelegate<NSObject>
@optional
-(void)keyboardToolDidClickSureBtn:(XYKeyboardTool *)keyboardTool;
-(void)keyboardToolDidClickCancelBtn:(XYKeyboardTool *)keyboardTool;
@end
@interface XYKeyboardTool : UIView
@property(nonatomic,copy) NSString *title;
+(instancetype)keyboardTool;
@property(nonatomic,weak) id<CZKeyboardToolDelegate> delegate;
@end
