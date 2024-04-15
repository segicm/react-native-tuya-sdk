import { NativeEventEmitter, NativeModules } from 'react-native';
import { DeviceBean } from 'device'
import { DeviceSchemaItem } from 'home'

export const GROUPLISTENER = 'groupListener';
export const HARDWAREUPGRADELISTENER = 'hardwareUpgradeListener';
export const DEVLISTENER = 'devListener';
export const SUBDEVLISTENER = 'subDevListener';
export const HOMESTATUS = 'homeStatus';
export const HOMECHANGE = 'homeChange';
export const SINGLETRANSFER = 'SingleTransfer';

let eventEmitter = new NativeEventEmitter(NativeModules.TuyaRNEventEmitter);

export function addEvent(eventName: string, callback: (data: any) => any) {
  return eventEmitter.addListener(eventName, callback);
}
export const bridge = (key: string, id: string | number) => `${key}//${id}`;

/*
 * On iOS home devices list has differences in structure, soo need to make it same as on android
 * */
export const prepareDeviceBean = (device: DeviceBean & { schema: string}) => {
  const schema = JSON.parse(device.schema) as Array<DeviceSchemaItem>;
  const schemaMap = schema.reduce((acc, item) => {
    return {
      ...acc,
      [item.id]: item,
    };
  }, {});
  return {
    ...device,
    schemaMap,
  };
};
