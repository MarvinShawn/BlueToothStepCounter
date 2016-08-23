
#import <UIKit/UIKit.h>
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
//这个是别人写的日历,我改了一下
typedef void(^ParttimeComplete)(NSArray *result);

@interface FDXYNCalendarView : UIView
@property (nonatomic, strong) NSArray        *defaultDates;
@property (nonatomic, copy) ParttimeComplete complete;

- (id)initWithFrame:(CGRect)frame;
- (void)show;
- (void)hide;
@end
