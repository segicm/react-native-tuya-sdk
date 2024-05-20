import { DeviceBean } from './device';
export declare type QueryRoomListParams = {
    homeId?: number;
};
export declare type QueryRoomListResponse = {
    name: string;
    displayOrder: number;
    id: number;
    roomId: number;
}[];
export declare function queryRoomList(params: QueryRoomListParams): Promise<QueryRoomListResponse>;
export declare type GetHomeDetailParams = {
    homeId: number;
};
export declare type DeviceSchemaItem = {
    id: number;
    code: string;
    name: string;
    extContent: string;
    type: 'obj' | 'raw';
    schemaType: 'bool' | 'value' | 'enum' | 'string';
    property: string;
    mode: string;
};
export declare type DeviceDetailResponse = DeviceBean;
export declare type GetHomeDetailResponse = {
    deviceList: DeviceDetailResponse[];
    groupList: any[];
    meshList: any[];
    sharedDeviceList: any[];
    sharedGroupList: any[];
};
export declare function getHomeDetail(params: GetHomeDetailParams): Promise<GetHomeDetailResponse>;
export declare type UpdateHomeParams = {
    homeId: number;
    name: string;
    geoName: string;
    lon: number;
    lat: number;
};
export declare function updateHome(params: UpdateHomeParams): Promise<string>;
export declare type DismissHomeParams = {
    homeId: number;
};
export declare function dismissHome(params: DismissHomeParams): Promise<string>;
export declare type SortRoomsParams = {
    idList: number[];
    homeId: number;
};
export declare function sortRoom(params: SortRoomsParams): Promise<string>;
