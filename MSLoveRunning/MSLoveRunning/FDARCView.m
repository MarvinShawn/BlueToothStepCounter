//
//  FDARCView.m
//  FastestDoctor
//
//  Created by ww on 16/8/8.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "FDARCView.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
@interface FDARCView ()
@property(nonatomic,strong)UILabel *numLabel;

@property (nonatomic,weak) UILabel *distanceLabel;

@property (nonatomic,weak) UILabel *carLabel;


@end
@implementation FDARCView
-(void)drawRect:(CGRect)rect
{
    // 仪表盘底部
    drawHu1();
    [self drawHu3];
    // 仪表盘进度
    [self drawHu2];
    
}

-(void)drawHu2
{
    //1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //1.1 设置线条的宽度
    CGContextSetLineWidth(ctx, 20);
    //1.2 设置线条的起始点样式
    CGContextSetLineCap(ctx,kCGLineCapButt);
    //1.3  虚实切换
    CGFloat length[] = {3,3};
    CGContextSetLineDash(ctx, 0, length, 2);
    //1.4 设置颜色
    [[[UIColor alloc]initWithRed:0.0/255.0 green:201.0/255.0 blue:87.0/255.0 alpha:1] set];
    
    //2.设置路径
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(numberChange:) name:@"number" object:nil];
    
    CGFloat end = 1.5*M_PI +(2*M_PI*_num/self.goalStep);
    CGContextAddArc(ctx, ScreenW/2, ScreenW/2, ScreenW / 2- 40, 1.5*M_PI , end, 0);
    
    //3.绘制
    CGContextStrokePath(ctx);
}
-(void)drawHu3
{
    //1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //1.1 设置线条的宽度
    CGContextSetLineWidth(ctx, 20);
    //1.2 设置线条的起始点样式
    CGContextSetLineCap(ctx,kCGLineCapButt);
    //1.3  虚实切换
    CGFloat length[] = {3,3};
    CGContextSetLineDash(ctx, 0, length, 2);
    //1.4 设置颜色
    [[[UIColor alloc]initWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1] set];
    
    CGContextAddArc(ctx, ScreenW/2, ScreenW/2, ScreenW / 2 - 40, 1.5*M_PI , 3.5*M_PI, 0);
    
    //3.绘制
    CGContextStrokePath(ctx);
}


-(void)numberChange:(NSNotification *)text
{
    _num =[text.userInfo[@"num"] intValue];
    [self setNeedsDisplay];
}

-(void)setNum:(int)num
{
    _num =num;
    
    [self change];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setupUI];
    }
    
    return self;
    
    
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _numLabel=[[UILabel alloc]init];
    _numLabel.backgroundColor = [UIColor clearColor];
    _numLabel.textAlignment =NSTextAlignmentCenter;
    _numLabel.textColor=[UIColor orangeColor];
    _numLabel.font=[UIFont systemFontOfSize:30];
    _numLabel.frame = CGRectMake(0, self.bounds.size.height / 2 - 30, ScreenW, 30);
    _numLabel.text = @"0步";
    
    
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height / 2 + 15 , ScreenW, 30)];
    self.distanceLabel = distanceLabel;
//    distanceLabel.text = @"5.";
    distanceLabel.textAlignment = NSTextAlignmentCenter;
    distanceLabel.font=[UIFont systemFontOfSize:20];
    distanceLabel.textColor = [UIColor orangeColor];
    
    
    UILabel *carLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height / 2 + 60, ScreenW, 30)];
    self.carLabel = carLabel;
//    carLabel.text = @"3";
    carLabel.textAlignment = NSTextAlignmentCenter;
    carLabel.font=[UIFont systemFontOfSize:20];
    carLabel.textColor = [UIColor orangeColor];
    

    [self addSubview:_numLabel];
    [self addSubview:distanceLabel];
    [self addSubview:carLabel];
}




-(void)change
{
    _numLabel.text =[NSString stringWithFormat:@"%d步",_num];
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:_numLabel.text,@"num", nil];
    
    //身高和体重应该是从用户单例里拿的,那个没拖进来,就直接给的死值
//    CGFloat height = [[FDXYNUser sharedUser].height floatValue];
    CGFloat height = 175.0;
    CGFloat stepDis = height * 0.45;
    CGFloat distance = (stepDis * (CGFloat)self.num) / 100000;    //这个是根据身高和步数来算距离
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f公里",distance];
    
    CGFloat weight  = 65.0;
//    CGFloat weight = [[FDXYNUser sharedUser].weight floatValue];
    CGFloat cal = weight * distance * 1.036;  //卡路里的简单算法,百度的
    self.carLabel.text = [NSString stringWithFormat:@"%.2f千卡",cal];
    // 创建通知
    NSNotification *noti =[NSNotification notificationWithName:@"number" object:nil userInfo:dic];
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

void drawHu1()
{
    // 1 获取上下文
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    
    // 1.1 设置线条的宽度
    CGContextSetLineWidth(ctx, 2);
    // 1.2 设置线条的起始点样式
    CGContextSetLineCap(ctx,kCGLineCapRound);
    
    // 1.4 设置颜色
    [[[UIColor alloc]initWithRed:0.0/255.0 green:201.0/255.0 blue:87.0/255.0 alpha:1] set];
    
    // 2 设置路径
    CGContextAddArc(ctx,ScreenW/2,ScreenW/2,ScreenW/2 - 20,-M_PI,M_PI,0);
    
    // 3 绘制
    CGContextStrokePath(ctx);
}


@end
