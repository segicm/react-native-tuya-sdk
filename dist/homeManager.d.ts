export declare type CreateHomeParams = {
    name: string;
    geoName: string;
    lon: number;
    lat: number;
    rooms: string[];
};
export declare function createHome(params: CreateHomeParams): Promise<{
    homeId: number;
} & Partial<HomeDetailsResponse>>;
export declare type HomeDetailsResponse = {
    name: string;
    admin: boolean;
    background: string;
    dealStatus: 1 | 2;
    displayOrder: number;
    geoName: string;
    gid: number;
    homeId: number;
    lat: number;
    lon: number;
};
export declare type QueryHomeListResponse = HomeDetailsResponse[];
export declare function queryHomeList(): Promise<QueryHomeListResponse>;
export declare type JoinFamilyParams = {
    homeId: number;
    action: boolean;
};
export declare function joinFamily(params: JoinFamilyParams): any;
