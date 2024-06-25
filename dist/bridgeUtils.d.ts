import { DeviceBean } from 'device';
import { DeviceSchemaItem } from 'home';
export declare const GROUPLISTENER = "groupListener";
export declare const HARDWAREUPGRADELISTENER = "hardwareUpgradeListener";
export declare const DEVLISTENER = "devListener";
export declare const SUBDEVLISTENER = "subDevListener";
export declare const HOMESTATUS = "homeStatus";
export declare const HOMECHANGE = "homeChange";
export declare const SINGLETRANSFER = "SingleTransfer";
export declare function addEvent(eventName: string, callback: (data: any) => any): import("react-native").EmitterSubscription;
export declare const bridge: (key: string, id: string | number) => string;
export declare const prepareDeviceBean: (device: DeviceBean & {
    schema: string;
}) => {
    schemaMap: Record<string, DeviceSchemaItem>;
    productBean: {
        schemaInfo: {
            dpCodeSchemaMap: Record<string, DeviceSchemaItem>;
        };
    };
    productId: string;
    devId: string;
    verSw: string;
    name: string;
    dps: import("./device").DeviceDps;
    deviceType?: number | undefined;
    address?: string | undefined;
    homeId: number;
    isOnline: boolean;
    homeDisplayOrder: number;
    roomId: number;
    mac: string;
    ip: string;
    uuid: string;
    timezoneId: string;
    schema: string;
};
