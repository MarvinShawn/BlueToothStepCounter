//
//  FDBluetoothTool.m
//  04-本地通知-跳转
//
//  Created by ww on 16/8/9.
//  Copyright © 2016年 hm04. All rights reserved.
//

#import "FDBluetoothTool.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface FDBluetoothTool ()<CBCentralManagerDelegate,CBPeripheralDelegate>

///  用于保存被发现设备,让其不被释放
@property (nonatomic,strong) CBPeripheral  *peripheral;

@property (nonatomic,strong) CBCentralManager *manager;

@property (nonatomic,weak) CBCharacteristic *characteristic;

@property (nonatomic,weak) CBPeripheral *connectPeripheral;

@property (nonatomic,assign) BOOL isConnected;

@property (nonatomic,assign) int stepNum;

@end
@implementation FDBluetoothTool

+ (instancetype)sharedBluetoothTool {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}




- (void)connectBluetooth {
    
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    
}

-(BOOL)isConnect {
    
    return self.isConnected;
    
}


- (CBCharacteristic *)getClockCharacteristic {
    
    
    return self.characteristic;
    
}

- (CBPeripheral *)getPeripheral {
    
    return self.peripheral;
    
}

- (int )getStepData {
    
    
    return self.stepNum;
    
}

//把数据写到哪个外设的哪个特征里面  这个不是代理方法
- (void)writeValue:(NSData *)value toPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic {
    
    //只有 characteristic.properties 有write的权限才可以写
    if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) {
        
        [peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
        
    }else {
        
        NSLog(@"该特征不可写入值");
        
    }
    
}


#pragma mark -  methods of CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    // 蓝牙可用, 接下来开始扫描外设
    if (central.state != CBCentralManagerStatePoweredOn) {
//        [SVProgressHUD setMinimumDismissTimeInterval:1];
//        [SVProgressHUD showErrorWithStatus:@"蓝牙未打开"];
        return;
    }
    
    [self.manager scanForPeripheralsWithServices:nil options:nil];  //通过代理回调
    
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    //接下来可以连接设备,最好用UUID来筛选设备,我偷懒用的名字
    if ([peripheral.name isEqualToString:@"MI"]) {
        
        self.peripheral = peripheral;
        
        [self.manager connectPeripheral:peripheral options:nil];  //通过代理方法来判断是否连接成功
    }
    
}
///  连接成功
///
///  @param central
///  @param peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    
    peripheral.delegate = self;
    
    //扫描外设的Services服务,成功后会进入方法: -(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{}
    [peripheral discoverServices:nil];
    
    
    self.isConnected = YES;
    
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
//    [SVProgressHUD showErrorWithStatus:@"连接到小米手环失败"];
    
    self.isConnected = NO;
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    //若断开连接,则重新连接
    //清除之前保存的所有信息
    self.peripheral = nil;
    //重新搜索
    [self.manager scanForPeripheralsWithServices:nil options:nil];
    
    
}

//扫描到服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    if (error) {
        
//        [SVProgressHUD showErrorWithStatus:@"小米手环有点问题"];
        return;
        
    }
    
    for (CBService *service in peripheral.services) {
        
        
        CBUUID *notifyUUID1 = [CBUUID UUIDWithString:@"FF06"]; //计步的特征uuid
        CBUUID *notifyUUID2 = [CBUUID UUIDWithString:@"2A06"];//震动的特征uuid
        [peripheral discoverCharacteristics:@[notifyUUID1,notifyUUID2] forService:service];
        
    }
    
}

//发现某个服务的某个特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    
    if (error) {
        
        NSLog(@"error Discover characteristic for %@ with error: %@",service.UUID,error);
        
        return;
        
    }
    
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        CBUUID *notifyUUID2 = [CBUUID UUIDWithString:@"2A06"];
        if ([characteristic.UUID isEqual:notifyUUID2]) {
            
            self.characteristic = characteristic;
        }else {
            
            //监听跑步的特征
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        
        
        
    }
    
}

//[peripheral setNotifyValue:YES forCharacteristic:characteristic];的代理回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error) {
        NSLog(@"订阅特征值出错%@",error);
        return;
    }
    
    [peripheral readValueForCharacteristic:characteristic];   //结果在代理里面
    
}


//找到某个特征的某个value
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    
    
    if (error) {
        
        NSLog(@"找特征值出现错误,%@",error);
        return;
    }
    NSData *data = characteristic.value;
    
    int i;
    [data getBytes:&i length:sizeof(i)]; //2进制转int类型
    
    self.stepNum = i;
    
    !self.getStepBlock ? : self.getStepBlock(i);
    
    
}




@end
