import { NativeModules, EmitterSubscription } from 'react-native';
import { addEvent, bridge, DEVLISTENER } from './bridgeUtils';
import { DeviceSchemaItem } from './home';

const tuya = NativeModules.TuyaDeviceModule;

export type DeviceBean = {
  productId: string;
  devId: string;
  verSw: string;
  name: string;
  dps: DeviceDps;
  deviceType?: number;
  address?: string;
  homeId: number;
  isOnline: boolean;
  homeDisplayOrder: number;
  roomId: number;
  mac: string;
  ip: string;
  uuid: string;
  timezoneId: string;
  schemaMap: Record<number, DeviceSchemaItem>;
  productBean: {
    schemaInfo: {
      dpCodeSchemaMap: Record<string, DeviceSchemaItem>;
    };
  }
};

export type DevListenerParams = {
  devId: string;
};

export type DevListenerType =
  | 'onDpUpdate'
  | 'onRemoved'
  | 'onStatusChanged'
  | 'onNetworkStatusChanged'
  | 'onDevInfoUpdate'
  | 'onFirmwareUpgradeSuccess'
  | 'onFirmwareUpgradeFailure'
  | 'onFirmwareUpgradeProgress';

let devListenerSubs: { [devId: string]: EmitterSubscription } = {};

export function registerDevListener(
  params: DevListenerParams,
  type: DevListenerType,
  callback: (data: any) => void
) {
  tuya.registerDevListener(params);
  const sub = addEvent(bridge(DEVLISTENER, params.devId), data => {
    if (data.type === type) {
      callback(data);
    }
  });
  devListenerSubs[params.devId] = sub;
}

export function unRegisterAllDevListeners() {
  for (const devId in devListenerSubs) {
    const sub = devListenerSubs[devId];
    sub.remove();
    tuya.unRegisterDevListener({ devId });
  }
  devListenerSubs = {};
}

export type DeviceDpValue = boolean | number | string;
export type DeviceDps = {
  [dpId: string]: DeviceDpValue;
};
export type SendParams = {
  devId: string;
} & DeviceDps;

export function send(params: object) {
  return tuya.send(params);
}

export type RemoveDeviceParams = { devId: string };

export function removeDevice(params: RemoveDeviceParams): Promise<string> {
  return tuya.removeDevice(params);
}

export type RenameDeviceParams = { devId: string; name: string };

export function renameDevice(params: RenameDeviceParams): Promise<string> {
  return tuya.renameDevice(params);
}

export type GetDataPointStatsParams = {
  devId: string;
  DataPointTypeEnum: 'DAY' | 'WEEK' | 'MONTH';
  number: number; // number of historical data result values, up to 50
  dpId: string;
  startTime: number; // in ms
};

export function getDataPointStat(
  params: GetDataPointStatsParams
): Promise<any> {
  return tuya.getDataPointStat(params);
}

export function getLockMemberList(devId: string): Promise<any> {
  return tuya.getProLockMemberListWithDevId(devId);
}

export function getDp(dpId: object): Promise<any> {
  return tuya.getDp(dpId);
}

export function checkIsBLEConnected(devId: string): Promise<boolean> {
  return tuya.checkIsBLEConnected(devId);
}

export function getProBoundUnlockOpModeListWithDevId(devId: string, userId: string): Promise<boolean> {
  return tuya.getProBoundUnlockOpModeListWithDevId(devId, userId);
}

export function isProNeedAllocUnlockOpMode(devId: string): Promise<boolean> {
  return tuya.isProNeedAllocUnlockOpMode(devId);
}

export function getProOfflinePasswordWithDevId(devId: string): Promise<boolean> {
  return tuya.getProOfflinePasswordWithDevId(devId);
}

export function getLockDynamicPasswordWithSuccess(devId: string): Promise<string> {
  return tuya.getLockDynamicPasswordWithSuccess(devId);
}

export function getProUnboundUnlockOpModeListWithDevId(devId: string): Promise<boolean> {
  return tuya.getProUnboundUnlockOpModeListWithDevId(devId);
}

export function addMemberWithUserName(devId: string, date: Date): Promise<boolean> {
  return tuya.addMemberWithUserName(devId, date);
}

export function getProPasswordListWithDevId(devId: string): Promise<boolean> {
  return tuya.getProPasswordListWithDevId(devId);
}

export function checkDeviceConnectionStatus(devId: string): Promise<boolean> {
  return tuya.checkIsOnline(devId);
}

export function getProCurrentMemberDetailWithDevId(devId: string): Promise<any> {
  return tuya.getProCurrentMemberDetailWithDevId(devId);
}

export function bleManualLockDevice(devId: string): Promise<any> {
  return tuya.bleManualLockDevice(devId);
}
