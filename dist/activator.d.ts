import { DeviceBean } from 'device';
import { DeviceDetailResponse } from './home';
export declare function openNetworkSettings(): any;
export declare enum TuyaActivationType {
    EZ = "TY_EZ",
    AP = "TY_AP",
    QR = "TY_QR"
}
export declare type InitActivatorParams = {
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
    scanType: 'SINGLE' | 'SINGLE_QR' | 'MESH' | 'SIG_MESH' | 'NORMAL' | 'TY_BEACON';
}
declare type IOSBLEActivatorParams = {
    homeId: number;
    ssid: string;
    password: string;
    timeout: number;
    deviceId: string;
    productId: string;
};
declare type AndroidBLEActivatorParams = {
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
export declare type InitBluetoothActivatorFromScanBeanParams = IOSBLEActivatorParams | AndroidBLEActivatorParams;
export declare function initActivator(params: InitActivatorParams): Promise<DeviceDetailResponse>;
export declare type GetActivatorTokenParams = {
    homeId: number;
};
export declare function getActivatorToken(params: GetActivatorTokenParams): any;
export declare type StartQRActivatorParams = {
    token: string;
    time: number;
};
export declare type ActiveBleParams = {
    deviceInfo: any;
    homeId: string;
};
export declare function startQRActivator(params: StartQRActivatorParams): Promise<DeviceDetailResponse>;
export declare function stopQRActivator(): any;
export declare function stopConfig(): any;
export declare function startBluetoothScan(params: StartLeScanParams): any;
export declare function activeBLE({ deviceInfo, homeId }: ActiveBleParams): any;
export declare function initBluetoothDualModeActivator(params: InitBluetoothActivatorParams): Promise<DeviceBean>;
export declare function initBluetoothDualModeActivatorFromScanBean(params: InitBluetoothActivatorFromScanBeanParams): Promise<DeviceBean>;
export declare function stopLeScan(): any;
export declare function stopLePairing(): any;
export declare function getCurrentWifi(success: (ssid: string) => void, error: () => void): any;
export {};
