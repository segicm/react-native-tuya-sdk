import { DeviceSchemaItem } from './home';
export declare type DeviceBean = {
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
    };
};
export declare type DevListenerParams = {
    devId: string;
};
export declare type DevListenerType = 'onDpUpdate' | 'onRemoved' | 'onStatusChanged' | 'onNetworkStatusChanged' | 'onDevInfoUpdate' | 'onFirmwareUpgradeSuccess' | 'onFirmwareUpgradeFailure' | 'onFirmwareUpgradeProgress';
export declare function registerDevListener(params: DevListenerParams, type: DevListenerType, callback: (data: any) => void): void;
export declare function unRegisterAllDevListeners(): void;
export declare type DeviceDpValue = boolean | number | string;
export declare type DeviceDps = {
    [dpId: string]: DeviceDpValue;
};
export declare type SendParams = {
    devId: string;
} & DeviceDps;
export declare function send(params: object): any;
export declare type RemoveDeviceParams = {
    devId: string;
};
export declare function removeDevice(params: RemoveDeviceParams): Promise<string>;
export declare type RenameDeviceParams = {
    devId: string;
    name: string;
};
export declare function renameDevice(params: RenameDeviceParams): Promise<string>;
export declare type GetDataPointStatsParams = {
    devId: string;
    DataPointTypeEnum: 'DAY' | 'WEEK' | 'MONTH';
    number: number;
    dpId: string;
    startTime: number;
};
export declare function getDataPointStat(params: GetDataPointStatsParams): Promise<any>;
export declare function getLockMemberList(devId: string): Promise<any>;
export declare function getDp(dpId: object): Promise<any>;
export declare function checkIsBLEConnected(devId: string): Promise<boolean>;
export declare function getProBoundUnlockOpModeListWithDevId(devId: string, userId: string): Promise<boolean>;
export declare function isProNeedAllocUnlockOpMode(devId: string): Promise<boolean>;
export declare function getProOfflinePasswordWithDevId(devId: string): Promise<boolean>;
export declare function getLockDynamicPasswordWithSuccess(devId: string): Promise<string>;
export declare function getProUnboundUnlockOpModeListWithDevId(devId: string): Promise<boolean>;
export declare function addMemberWithUserName(devId: string, date: Date): Promise<boolean>;
export declare function getProPasswordListWithDevId(devId: string): Promise<boolean>;
export declare function checkDeviceConnectionStatus(devId: string): Promise<boolean>;
export declare function getProCurrentMemberDetailWithDevId(devId: string): Promise<any>;
export declare function bleManualLockDevice(devId: string): Promise<any>;
