//
//  FDBluetoothTool.h
//  04-本地通知-跳转
//
//  Created by ww on 16/8/9.
//  Copyright © 2016年 hm04. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface FDBluetoothTool : NSObject

/*
    小米手环自带数据存储功能,每到00:00步数清0
    如果想自己写个APP来连接手环,先买个手环,再下载小米运动APP,用小米运动和手机连接,然后就可以把小米运动删掉了.这里只是借助小米运动来使得手机可以和手环连接,因为要注册设置用户信息,在自己写的APP上做的话比较麻烦.
 
 */

+ (instancetype)sharedBluetoothTool;


///  连接蓝牙
- (void)connectBluetooth;

///  是否连接
///
///  @return 
-(BOOL)isConnect ;

///  获得步数
///
///  @return
- (int )getStepData;

///  获得外设
///
///  @return
- (CBPeripheral *)getPeripheral;


///  写值
///
///  @return
- (void)writeValue:(NSData *)value toPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic;

///  获得闹钟特征
///
///  @return 
- (CBCharacteristic *)getClockCharacteristic;

///  获得步数的block
@property(nonatomic,copy) void (^getStepBlock)(int);


@end
