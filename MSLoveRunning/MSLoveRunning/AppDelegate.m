//
//  AppDelegate.m
//  MSLoveRunning
//
//  Created by ww on 16/8/12.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "AppDelegate.h"
#import "FDBluetoothTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //蓝牙连接
    [[FDBluetoothTool sharedBluetoothTool] connectBluetooth];
    
    /*===通知配置 =======*/
    UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge;
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
    
    // 注册结果 , 是通过 AppDelegate 的方法来回应
    [application registerUserNotificationSettings:settings];
    
    

    
    return YES;
}
#pragma mark -  methods of 本地通知代理方法
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    int dataStr = 2; //2震6下  1震1下 0停止震动
    
    NSData *data = [NSData dataWithBytes:&dataStr length:sizeof(dataStr) ];
    
    [[FDBluetoothTool sharedBluetoothTool] writeValue:data toPeripheral:[[FDBluetoothTool sharedBluetoothTool] getPeripheral] characteristic:[[FDBluetoothTool sharedBluetoothTool] getClockCharacteristic]];
    
    
    
}


@end
