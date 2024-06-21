//
//  TuyaBLERNScannerModule.m
//  TuyaRnDemo
//
//  Created by 浩天 on 2019/2/28.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "TuyaBLERNScannerModule.h"
#import <ThingSmartActivatorKit/ThingSmartActivatorKit.h>
#import <ThingSmartBaseKit/ThingSmartBaseKit.h>
#import <ThingSmartDeviceKit/ThingSmartDeviceKit.h>
#import <ThingSmartBLEKit/ThingSmartBLEManager+Biz.h>
#import "TuyaRNUtils+Network.h"
#import "YYModel.h"
#import "TuyaEventSender.h"
#import "TuyaRNHomeModule.h"

// Bluetooth Pairing
static TuyaBLERNScannerModule * scannerInstance = nil;


@interface TuyaBLERNScannerModule()<ThingSmartBLEManagerDelegate>

@property(copy, nonatomic) RCTPromiseResolveBlock promiseResolveBlock;
@property(copy, nonatomic) RCTPromiseRejectBlock promiseRejectBlock;


@end

@implementation TuyaBLERNScannerModule

#define kTuyaDevId @"devId"
#define kTuyaHomeId @"homeId"
#define kTuyaDeviceInfo @"deviceInfo"

RCT_EXPORT_MODULE(TuyaBLEScannerModule)

// Using on Android
RCT_EXPORT_METHOD(startBluetoothScan:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  TuyaEventSender * eventSender = [TuyaEventSender allocWithZone: nil];
  [eventSender sendEvent2RN:tuyaEventSenderScanLEEvent body:@"startBluetoothScan + sendEvent2RN"];
  if (scannerInstance == nil) {
    scannerInstance = [TuyaBLERNScannerModule new];
  }

  [ThingSmartBLEManager sharedInstance].delegate = scannerInstance;
  scannerInstance.promiseResolveBlock = resolver;
  scannerInstance.promiseRejectBlock = rejecter;

  [[ThingSmartBLEManager sharedInstance] startListening:YES];
}

RCT_EXPORT_METHOD(activeBLE:(NSDictionary *)params resolver:(RCTPromiseResolveBlock) rejecter:(RCTPromiseRejectBlock)rejecter) {
  NSString *deviceInfo = params[kTuyaDeviceInfo];
  NSString *homeId = params[kTuyaHomeId];

  if(deviceInfo.length == 0 || homeId.length == 0) {
    return;
  }

    TuyaEventSender * eventSender = [TuyaEventSender allocWithZone: nil];
    [eventSender sendEvent2RN:tuyaEventSenderScanLEEvent body:@"startBluetoothScan + sendEvent2RN"];

  [ThingSmartBLEManager.sharedInstance activeBLE:deviceInfo homeId:homeId success:^(ThingSmartDeviceModel * _Nonnull deviceModel) {
    NSString *name = deviceModel.name?deviceModel.name:NSLocalizedString(@"Unknown Name", @"Unknown name device.");
      NSLog(@"Successfully paired with device! %@", name);
   } failure:^{
      NSLog(@"Failed to pair with device!");
   }];
}

- (void)didDiscoveryDeviceWithDeviceInfo:(ThingBLEAdvModel *)deviceInfo {
  NSLog(@"didDiscoveryDeviceWithDeviceInfo");
  if (deviceInfo.bleType == ThingSmartBLETypeBLEWifi ||
      deviceInfo.bleType == ThingSmartBLETypeBLEWifiSecurity ||
      deviceInfo.bleType == ThingSmartBLETypeBLEWifiPlugPlay ||
      deviceInfo.bleType == ThingSmartBLETypeBLEWifiPriorBLE ||
      deviceInfo.bleType == ThingSmartBLETypeBLELTESecurity) {
      NSLog(@"Please use Dual Mode to pair: %@", deviceInfo.uuid);
      return;
  }
  TuyaEventSender * eventSender = [TuyaEventSender allocWithZone: nil];
  [eventSender sendEvent2RN:tuyaEventSenderScanLEEvent body:[deviceInfo yy_modelToJSONObject]];
  NSLog(@"Found a device with info: %@", [deviceInfo yy_modelToJSONObject]);
//     long long homeId = [TuyaRNHomeModule getCurrentHome].homeId;

    [ThingSmartBLEManager.sharedInstance activeBLE:deviceInfo homeId:195256480 success:^(ThingSmartDeviceModel * _Nonnull deviceModel) {
        NSString *name = deviceModel.name?deviceModel.name:NSLocalizedString(@"Unknown Name", @"Unknown name device.");
        NSLog(@"Successfully paired with device! %@", name);
     } failure:^{
        NSLog(@"Failed to pair with device!");
     }];
      if (scannerInstance.promiseResolveBlock) {
        self.promiseResolveBlock([deviceInfo yy_modelToJSONObject]);
      }
}

// Using on iOS
RCT_EXPORT_METHOD(startBluetoothLEScan:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  if (scannerInstance == nil) {
    scannerInstance = [TuyaBLERNScannerModule new];
  }
  [ThingSmartBLEManager sharedInstance].delegate = scannerInstance;
  [[ThingSmartBLEManager sharedInstance] startListening:YES];
  TuyaEventSender * eventSender = [TuyaEventSender allocWithZone: nil];
  [eventSender sendEvent2RN:tuyaEventSenderScanLEEvent body:@"startBluetoothScan + sendEvent2RN"];
  resolver(@"BLE scan started!!!");
}

RCT_EXPORT_METHOD(stopBluetoothScan:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
  [[ThingSmartBLEManager sharedInstance] stopListening:YES];
}

@end
