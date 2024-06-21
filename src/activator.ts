import { DeviceBean } from 'device';
import { NativeModules, Platform } from 'react-native';
import { DeviceDetailResponse } from './home';
import { prepareDeviceBean } from './bridgeUtils'

const tuya = NativeModules.TuyaActivatorModule;
const tuyaBLEActivator = NativeModules.TuyaBLEActivatorModule;
const tuyaBLEScanner = NativeModules.TuyaBLEScannerModule;

export function openNetworkSettings() {
  return tuya.openNetworkSettings({});
}

export enum TuyaActivationType {
  EZ = 'TY_EZ',
  AP = 'TY_AP',
  QR = 'TY_QR',
}

export type InitActivatorParams = {
  homeId: number;
  ssid: string;
  password: string;
  time: number;
  type: TuyaActivationType;
};

export interface InitBluetoothActivatorParams {
  deviceId?: string;
  homeId: number;
  ssid: string;
  password: string;
}

export interface StartLeScanParams {
  timeout: number;
  homeId: number;
  scanType:
    | 'SINGLE'
    | 'SINGLE_QR'
    | 'MESH'
    | 'SIG_MESH'
    | 'NORMAL'
    | 'TY_BEACON';
}

type IOSBLEActivatorParams = {
  homeId: number;
  ssid: string;
  password: string;
  timeout: number;
  deviceId: string;
  productId: string;
};
type AndroidBLEActivatorParams = {
  homeId: number;
  ssid: string;
  password: string;
  timeout: number;
  uuid: string;
  deviceType: number;
  mac: string;
  address: string;
  token: string;
};
export type InitBluetoothActivatorFromScanBeanParams =
  | IOSBLEActivatorParams
  | AndroidBLEActivatorParams;

export async function initActivator(
  params: InitActivatorParams
): Promise<DeviceDetailResponse> {
  if (Platform.OS === 'ios') {
    const device = await tuya.initActivator(params);
    return prepareDeviceBean(device);
  }
  return tuya.initActivator(params);
}

export type GetActivatorTokenParams = {
  homeId: number;
};

export function getActivatorToken(params: GetActivatorTokenParams) {
  return tuya.getActivatorToken(params);
}

export type StartQRActivatorParams = {
  token: string;
  time: number;
};

export type ActiveBleParams = {deviceInfo: any, homeId: string};

export async function startQRActivator(params: StartQRActivatorParams): Promise<DeviceDetailResponse> {
  if (Platform.OS === 'ios') {
    const device = await tuya.initActivator({ ...params, type: 'TY_QR' });
    return prepareDeviceBean(device);
  }
  return tuya.startQRActivator(params);
}

export function stopQRActivator() {
  if (Platform.OS === 'ios') {
    return stopConfig();
  }
  return tuya.stopQRActivator();
}

export function stopConfig() {
  return tuya.stopConfig();
}

export function startBluetoothScan(params: StartLeScanParams) {
  if (Platform.OS === 'ios') {
    return tuyaBLEScanner.startBluetoothLEScan();
  }
  return tuya.startBluetoothScan(params);
}

export function activeBLE({deviceInfo, homeId}: ActiveBleParams) {
  return tuyaBLEScanner.activeBLE({deviceInfo, homeId});
}

export async function initBluetoothDualModeActivator(
  params: InitBluetoothActivatorParams
): Promise<DeviceBean> {
  if (Platform.OS === 'ios') {
    const device = await tuyaBLEActivator.initActivator(params);
    return prepareDeviceBean(device);
  }
  return tuya.initBluetoothDualModeActivator(params);
}

export async function initBluetoothDualModeActivatorFromScanBean(
  params: InitBluetoothActivatorFromScanBeanParams
): Promise<DeviceBean> {
  if (Platform.OS === 'ios') {
    const device = await tuyaBLEActivator.initActivator(params);
    return prepareDeviceBean(device);
  }
  return tuya.initBluetoothDualModeActivatorFromScanBean(params);
}

export function stopLeScan() {
  if (Platform.OS === 'ios') {
    return tuyaBLEScanner.stopBluetoothScan();
  }
  return tuya.stopBluetoothScan();
}

export function stopLePairing() {
  if (Platform.OS === 'ios') {
    return tuyaBLEActivator.stopLePairing();
  }
  return tuya.stopLeActivation();
}

export function getCurrentWifi(
  success: (ssid: string) => void,
  error: () => void
) {
  // We need the Allow While Using App location permission to use this.
  return tuya.getCurrentWifi({}, success, error);
}
