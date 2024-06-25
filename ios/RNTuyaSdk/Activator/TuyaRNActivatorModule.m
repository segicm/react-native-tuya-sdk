//
//  TuyaRNActivatorModule.m
//  TuyaRnDemo
//
//  Created by 浩天 on 2019/2/28.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "TuyaRNActivatorModule.h"
#import <ThingSmartActivatorKit/ThingSmartActivatorKit.h>
#import <ThingSmartBaseKit/ThingSmartBaseKit.h>
#import <ThingSmartDeviceKit/ThingSmartDeviceKit.h>
#import "TuyaRNUtils+Network.h"
#import "YYModel.h"

#define kTuyaRNActivatorModuleHomeId @"homeId"
#define kTuyaRNActivatorModuleSSID @"ssid"
#define kTuyaRNActivatorModulePassword @"password"
#define kTuyaRNActivatorModuleActivatorMode @"type"
#define kTuyaRNActivatorModuleOverTime @"time"
#define kTuyaRNActivatorModuleAcccessToken @"token"
#define kTuyaRNActivatorModuleDeviceId @"devId"

static TuyaRNActivatorModule * activatorInstance = nil;

@interface TuyaRNActivatorModule()<ThingSmartActivatorDelegate>

@property(copy, nonatomic) RCTPromiseResolveBlock promiseResolveBlock;
@property(copy, nonatomic) RCTPromiseRejectBlock promiseRejectBlock;

@end

@implementation TuyaRNActivatorModule

RCT_EXPORT_MODULE(TuyaActivatorModule)

/** 开始配网
 * @param homeId  当前用户的homeId
 * @param ssid   配网之后，设备工作WiFi的名称。（家庭网络）
 * @param password   配网之后，设备工作WiFi的密码。（家庭网络）
 * @param activatorModel:    现在给设备配网有以下两种方式:
 ActivatorModelEnum.TY_EZ: 传入该参数则进行EZ配网
 ActivatorModelEnum.TY_AP: 传入该参数则进行AP配网
 * @param timeout     配网的超时时间设置，默认是100s.
 */
RCT_EXPORT_METHOD(initActivator:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

  NSNumber *homeId = params[kTuyaRNActivatorModuleHomeId];
  NSString *ssid = params[kTuyaRNActivatorModuleSSID];
  NSString *password = params[kTuyaRNActivatorModulePassword];
  NSNumber *time = params[kTuyaRNActivatorModuleOverTime];
  NSString *type = params[kTuyaRNActivatorModuleActivatorMode];
  NSString *token = params[kTuyaRNActivatorModuleAcccessToken];

  ThingActivatorMode mode = ThingActivatorModeEZ;
  if ([type isEqualToString:@"TY_EZ"]) {
    mode = ThingActivatorModeEZ;
  } else if([type isEqualToString:@"TY_AP"]) {
    mode = ThingActivatorModeAP;
  } else if([type isEqualToString:@"TY_QR"]) {
    mode = ThingActivatorModeQRCode;
  }

  if (activatorInstance == nil) {
    activatorInstance = [TuyaRNActivatorModule new];
  }

  [ThingSmartActivator sharedInstance].delegate = activatorInstance;
  activatorInstance.promiseResolveBlock = resolver;
  activatorInstance.promiseRejectBlock = rejecter;

    if (token == nil){
        [[ThingSmartActivator sharedInstance] getTokenWithHomeId:homeId.longLongValue success:^(NSString *result) {
            //开始配置网络：
            [[ThingSmartActivator sharedInstance] startConfigWiFi:mode ssid:ssid password:password token:result timeout:time.doubleValue];
        } failure:^(NSError *error) {
            [TuyaRNUtils rejecterWithError:error handler:rejecter];
        }];
    } else {
        [[ThingSmartActivator sharedInstance] startConfigWiFi:mode ssid:ssid password:password token:token timeout:time.doubleValue];
    }
}


RCT_EXPORT_METHOD(stopConfig:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

  [[ThingSmartActivator sharedInstance] stopConfigWiFi];
}

//ZigBee子设备配网需要ZigBee网关设备云在线的情况下才能发起,且子设备处于配网状态。

RCT_EXPORT_METHOD(newGwSubDevActivator:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

  NSString *deviceId = params[kTuyaRNActivatorModuleDeviceId];
  NSNumber *time = params[kTuyaRNActivatorModuleOverTime];

  if (activatorInstance == nil) {
    activatorInstance = [TuyaRNActivatorModule new];
  }

  [ThingSmartActivator sharedInstance].delegate = activatorInstance;
  activatorInstance.promiseResolveBlock = resolver;
  activatorInstance.promiseRejectBlock = rejecter;

  [[ThingSmartActivator sharedInstance] activeSubDeviceWithGwId:deviceId timeout:time.doubleValue];

}

RCT_EXPORT_METHOD(stopNewGwSubDevActivatorConfig:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

  NSString *deviceId = params[kTuyaRNActivatorModuleDeviceId];
  [[ThingSmartActivator sharedInstance] stopActiveSubDeviceWithGwId:deviceId];
}

/**
 获取wifi信息
 */
RCT_EXPORT_METHOD(getCurrentWifi:(NSDictionary *)params success:(RCTResponseSenderBlock)succ failure:(RCTResponseErrorBlock)fail) {
  NSString *ssid = [ThingSmartActivator currentWifiSSID];
  if ([ssid isKindOfClass:[NSString class]] && ssid.length > 0) {
    succ(@[ssid]);
  } else {
    fail(nil);
  }
}


//判断网络
RCT_EXPORT_METHOD(openNetworkSettings:(NSDictionary *)params resolver :(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

   [TuyaRNUtils openNetworkSettings];

}

RCT_EXPORT_METHOD(onDestory:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {

}


#pragma mark -
#pragma mark - delegate
/// 配网状态更新的回调，wifi单品，zigbee网关，zigbee子设备
- (void)activator:(ThingSmartActivator *)activator didReceiveDevice:(ThingSmartDeviceModel *)deviceModel error:(NSError *)error {

  if (error) {
    if (activatorInstance.promiseRejectBlock) {
      [TuyaRNUtils rejecterWithError:error handler:activatorInstance.promiseRejectBlock];
    }
    return;
  }

  //开始回调
  if (activatorInstance.promiseResolveBlock) {
    self.promiseResolveBlock([deviceModel yy_modelToJSONObject]);
  }
}

RCT_EXPORT_METHOD(getActivatorToken:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter) {
    NSNumber *homeId = params[kTuyaRNActivatorModuleHomeId];

    [[ThingSmartActivator sharedInstance] getTokenWithHomeId:homeId.longLongValue success:^(NSString *result) {
        resolver(result);
    } failure:^(NSError *error) {
      [TuyaRNUtils rejecterWithError:error handler:rejecter];
    }];}

@end
