export declare function registerAccountWithEmail(params: RegisterAccountWithEmailParams): Promise<any>;
export declare function getRegisterEmailValidateCode(params: GetEmailValidateCodeParams): Promise<any>;
export declare function sendVerifyCodeWithUserName(params: SendVerifyCodeWithUserNameParams): Promise<any>;
export declare function loginWithEmail(params: LoginWithEmailParams): Promise<any>;
export declare function getEmailValidateCode(params: GetEmailValidateCodeParams): Promise<any>;
export declare function resetEmailPassword(params: ResetEmailPasswordParams): Promise<any>;
export declare function logout(): Promise<string>;
export declare function getCurrentUser(): Promise<User | null>;
export declare function getUser(): Promise<User | null>;
export declare function cancelAccount(): Promise<string>;
export declare function loginWithUid(params: LoginWithUIDParams): Promise<any>;
export declare function loginOrRegisterWithUid(params: LoginOrRegisterWithUidParams): Promise<any>;
export declare type User = {
    email: string;
    username: string;
    sid: string;
    timezoneId: string;
    uid: string;
    userType: number;
    headPic: string;
    mobile: string;
    nickName: string;
    phoneCode: string;
};
export declare type RegisterAccountWithEmailParams = {
    countryCode: string;
    email: string;
    validateCode: string;
    password: string;
};
export declare type GetEmailValidateCodeParams = {
    countryCode: string;
    email: string;
};
export declare type SendVerifyCodeWithUserNameParams = {
    countryCode: string;
    email: string;
    region: string;
    type: 1 | 2 | 3;
};
export declare type LoginWithEmailParams = {
    email: string;
    password: string;
    countryCode: string;
};
export declare type ResetEmailPasswordParams = {
    email: string;
    countryCode: string;
    validateCode: string;
    newPassword: string;
};
export declare type LoginWithUIDParams = {
    uid: string;
    password: string;
    countryCode: string;
};
export declare type LoginOrRegisterWithUidParams = {
    uid: string;
    password: string;
    countryCode: string;
};
