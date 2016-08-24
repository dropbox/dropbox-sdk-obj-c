/// 
/// Stone Route Objects
/// 

#import "DbxStoneBase.h"
#import "DbxTeamRouteObjects.h"
#import "DbxTeamRoutes.h"

@implementation DbxTeamRouteObjects 

static DbxRoute *dbxTeamAlphaGroupsCreate = nil;
static DbxRoute *dbxTeamAlphaGroupsGetInfo = nil;
static DbxRoute *dbxTeamAlphaGroupsList = nil;
static DbxRoute *dbxTeamAlphaGroupsListContinue = nil;
static DbxRoute *dbxTeamAlphaGroupsUpdate = nil;
static DbxRoute *dbxTeamDevicesListMemberDevices = nil;
static DbxRoute *dbxTeamDevicesListMembersDevices = nil;
static DbxRoute *dbxTeamDevicesListTeamDevices = nil;
static DbxRoute *dbxTeamDevicesRevokeDeviceSession = nil;
static DbxRoute *dbxTeamDevicesRevokeDeviceSessionBatch = nil;
static DbxRoute *dbxTeamGetInfo = nil;
static DbxRoute *dbxTeamGroupsCreate = nil;
static DbxRoute *dbxTeamGroupsDelete = nil;
static DbxRoute *dbxTeamGroupsGetInfo = nil;
static DbxRoute *dbxTeamGroupsJobStatusGet = nil;
static DbxRoute *dbxTeamGroupsList = nil;
static DbxRoute *dbxTeamGroupsListContinue = nil;
static DbxRoute *dbxTeamGroupsMembersAdd = nil;
static DbxRoute *dbxTeamGroupsMembersList = nil;
static DbxRoute *dbxTeamGroupsMembersListContinue = nil;
static DbxRoute *dbxTeamGroupsMembersRemove = nil;
static DbxRoute *dbxTeamGroupsMembersSetAccessType = nil;
static DbxRoute *dbxTeamGroupsUpdate = nil;
static DbxRoute *dbxTeamLinkedAppsListMemberLinkedApps = nil;
static DbxRoute *dbxTeamLinkedAppsListMembersLinkedApps = nil;
static DbxRoute *dbxTeamLinkedAppsListTeamLinkedApps = nil;
static DbxRoute *dbxTeamLinkedAppsRevokeLinkedApp = nil;
static DbxRoute *dbxTeamLinkedAppsRevokeLinkedAppBatch = nil;
static DbxRoute *dbxTeamMembersAdd = nil;
static DbxRoute *dbxTeamMembersAddJobStatusGet = nil;
static DbxRoute *dbxTeamMembersGetInfo = nil;
static DbxRoute *dbxTeamMembersList = nil;
static DbxRoute *dbxTeamMembersListContinue = nil;
static DbxRoute *dbxTeamMembersRecover = nil;
static DbxRoute *dbxTeamMembersRemove = nil;
static DbxRoute *dbxTeamMembersRemoveJobStatusGet = nil;
static DbxRoute *dbxTeamMembersSendWelcomeEmail = nil;
static DbxRoute *dbxTeamMembersSetAdminPermissions = nil;
static DbxRoute *dbxTeamMembersSetProfile = nil;
static DbxRoute *dbxTeamMembersSuspend = nil;
static DbxRoute *dbxTeamMembersUnsuspend = nil;
static DbxRoute *dbxTeamPropertiesTemplateAdd = nil;
static DbxRoute *dbxTeamPropertiesTemplateGet = nil;
static DbxRoute *dbxTeamPropertiesTemplateList = nil;
static DbxRoute *dbxTeamPropertiesTemplateUpdate = nil;
static DbxRoute *dbxTeamReportsGetActivity = nil;
static DbxRoute *dbxTeamReportsGetDevices = nil;
static DbxRoute *dbxTeamReportsGetMembership = nil;
static DbxRoute *dbxTeamReportsGetStorage = nil;

+ (DbxRoute *)dbxTeamAlphaGroupsCreate {
    if (!dbxTeamAlphaGroupsCreate) {
        dbxTeamAlphaGroupsCreate = [[DbxRoute alloc] init:
            @"alpha/groups/create"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGroupFullInfo class]
            errorType:[DbxTeamGroupCreateError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamAlphaGroupsCreate;
}

+ (DbxRoute *)dbxTeamAlphaGroupsGetInfo {
    if (!dbxTeamAlphaGroupsGetInfo) {
        dbxTeamAlphaGroupsGetInfo = [[DbxRoute alloc] init:
            @"alpha/groups/get_info"
            namespace_:@"team"
            deprecated:@NO
            resultType:[NSArray<DbxTeamGroupsGetInfoItem *> class]
            errorType:[DbxTeamGroupsGetInfoError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:^id(id array) { return [DbxArraySerializer deserialize:array withBlock:^id(id elem) { return [DbxTeamGroupsGetInfoItemSerializer deserialize:elem]; }]; }
        ];
    }
    return dbxTeamAlphaGroupsGetInfo;
}

+ (DbxRoute *)dbxTeamAlphaGroupsList {
    if (!dbxTeamAlphaGroupsList) {
        dbxTeamAlphaGroupsList = [[DbxRoute alloc] init:
            @"alpha/groups/list"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGroupsListResult class]
            errorType:nil
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamAlphaGroupsList;
}

+ (DbxRoute *)dbxTeamAlphaGroupsListContinue {
    if (!dbxTeamAlphaGroupsListContinue) {
        dbxTeamAlphaGroupsListContinue = [[DbxRoute alloc] init:
            @"alpha/groups/list/continue"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGroupsListResult class]
            errorType:[DbxTeamGroupsListContinueError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamAlphaGroupsListContinue;
}

+ (DbxRoute *)dbxTeamAlphaGroupsUpdate {
    if (!dbxTeamAlphaGroupsUpdate) {
        dbxTeamAlphaGroupsUpdate = [[DbxRoute alloc] init:
            @"alpha/groups/update"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGroupFullInfo class]
            errorType:[DbxTeamGroupUpdateError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamAlphaGroupsUpdate;
}

+ (DbxRoute *)dbxTeamDevicesListMemberDevices {
    if (!dbxTeamDevicesListMemberDevices) {
        dbxTeamDevicesListMemberDevices = [[DbxRoute alloc] init:
            @"devices/list_member_devices"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamListMemberDevicesResult class]
            errorType:[DbxTeamListMemberDevicesError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamDevicesListMemberDevices;
}

+ (DbxRoute *)dbxTeamDevicesListMembersDevices {
    if (!dbxTeamDevicesListMembersDevices) {
        dbxTeamDevicesListMembersDevices = [[DbxRoute alloc] init:
            @"devices/list_members_devices"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamListMembersDevicesResult class]
            errorType:[DbxTeamListMembersDevicesError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamDevicesListMembersDevices;
}

+ (DbxRoute *)dbxTeamDevicesListTeamDevices {
    if (!dbxTeamDevicesListTeamDevices) {
        dbxTeamDevicesListTeamDevices = [[DbxRoute alloc] init:
            @"devices/list_team_devices"
            namespace_:@"team"
            deprecated:@YES
            resultType:[DbxTeamListTeamDevicesResult class]
            errorType:[DbxTeamListTeamDevicesError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamDevicesListTeamDevices;
}

+ (DbxRoute *)dbxTeamDevicesRevokeDeviceSession {
    if (!dbxTeamDevicesRevokeDeviceSession) {
        dbxTeamDevicesRevokeDeviceSession = [[DbxRoute alloc] init:
            @"devices/revoke_device_session"
            namespace_:@"team"
            deprecated:@NO
            resultType:nil
            errorType:[DbxTeamRevokeDeviceSessionError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamDevicesRevokeDeviceSession;
}

+ (DbxRoute *)dbxTeamDevicesRevokeDeviceSessionBatch {
    if (!dbxTeamDevicesRevokeDeviceSessionBatch) {
        dbxTeamDevicesRevokeDeviceSessionBatch = [[DbxRoute alloc] init:
            @"devices/revoke_device_session_batch"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamRevokeDeviceSessionBatchResult class]
            errorType:[DbxTeamRevokeDeviceSessionBatchError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamDevicesRevokeDeviceSessionBatch;
}

+ (DbxRoute *)dbxTeamGetInfo {
    if (!dbxTeamGetInfo) {
        dbxTeamGetInfo = [[DbxRoute alloc] init:
            @"get_info"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamTeamGetInfoResult class]
            errorType:nil
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamGetInfo;
}

+ (DbxRoute *)dbxTeamGroupsCreate {
    if (!dbxTeamGroupsCreate) {
        dbxTeamGroupsCreate = [[DbxRoute alloc] init:
            @"groups/create"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGroupFullInfo class]
            errorType:[DbxTeamGroupCreateError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamGroupsCreate;
}

+ (DbxRoute *)dbxTeamGroupsDelete {
    if (!dbxTeamGroupsDelete) {
        dbxTeamGroupsDelete = [[DbxRoute alloc] init:
            @"groups/delete"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxAsyncLaunchEmptyResult class]
            errorType:[DbxTeamGroupDeleteError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamGroupsDelete;
}

+ (DbxRoute *)dbxTeamGroupsGetInfo {
    if (!dbxTeamGroupsGetInfo) {
        dbxTeamGroupsGetInfo = [[DbxRoute alloc] init:
            @"groups/get_info"
            namespace_:@"team"
            deprecated:@NO
            resultType:[NSArray<DbxTeamGroupsGetInfoItem *> class]
            errorType:[DbxTeamGroupsGetInfoError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:^id(id array) { return [DbxArraySerializer deserialize:array withBlock:^id(id elem) { return [DbxTeamGroupsGetInfoItemSerializer deserialize:elem]; }]; }
        ];
    }
    return dbxTeamGroupsGetInfo;
}

+ (DbxRoute *)dbxTeamGroupsJobStatusGet {
    if (!dbxTeamGroupsJobStatusGet) {
        dbxTeamGroupsJobStatusGet = [[DbxRoute alloc] init:
            @"groups/job_status/get"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxAsyncPollEmptyResult class]
            errorType:[DbxTeamGroupsPollError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamGroupsJobStatusGet;
}

+ (DbxRoute *)dbxTeamGroupsList {
    if (!dbxTeamGroupsList) {
        dbxTeamGroupsList = [[DbxRoute alloc] init:
            @"groups/list"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGroupsListResult class]
            errorType:nil
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamGroupsList;
}

+ (DbxRoute *)dbxTeamGroupsListContinue {
    if (!dbxTeamGroupsListContinue) {
        dbxTeamGroupsListContinue = [[DbxRoute alloc] init:
            @"groups/list/continue"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGroupsListResult class]
            errorType:[DbxTeamGroupsListContinueError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamGroupsListContinue;
}

+ (DbxRoute *)dbxTeamGroupsMembersAdd {
    if (!dbxTeamGroupsMembersAdd) {
        dbxTeamGroupsMembersAdd = [[DbxRoute alloc] init:
            @"groups/members/add"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGroupMembersChangeResult class]
            errorType:[DbxTeamGroupMembersAddError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamGroupsMembersAdd;
}

+ (DbxRoute *)dbxTeamGroupsMembersList {
    if (!dbxTeamGroupsMembersList) {
        dbxTeamGroupsMembersList = [[DbxRoute alloc] init:
            @"groups/members/list"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGroupsMembersListResult class]
            errorType:[DbxTeamGroupSelectorError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamGroupsMembersList;
}

+ (DbxRoute *)dbxTeamGroupsMembersListContinue {
    if (!dbxTeamGroupsMembersListContinue) {
        dbxTeamGroupsMembersListContinue = [[DbxRoute alloc] init:
            @"groups/members/list/continue"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGroupsMembersListResult class]
            errorType:[DbxTeamGroupsMembersListContinueError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamGroupsMembersListContinue;
}

+ (DbxRoute *)dbxTeamGroupsMembersRemove {
    if (!dbxTeamGroupsMembersRemove) {
        dbxTeamGroupsMembersRemove = [[DbxRoute alloc] init:
            @"groups/members/remove"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGroupMembersChangeResult class]
            errorType:[DbxTeamGroupMembersRemoveError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamGroupsMembersRemove;
}

+ (DbxRoute *)dbxTeamGroupsMembersSetAccessType {
    if (!dbxTeamGroupsMembersSetAccessType) {
        dbxTeamGroupsMembersSetAccessType = [[DbxRoute alloc] init:
            @"groups/members/set_access_type"
            namespace_:@"team"
            deprecated:@NO
            resultType:[NSArray<DbxTeamGroupsGetInfoItem *> class]
            errorType:[DbxTeamGroupMemberSetAccessTypeError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:^id(id array) { return [DbxArraySerializer deserialize:array withBlock:^id(id elem) { return [DbxTeamGroupsGetInfoItemSerializer deserialize:elem]; }]; }
        ];
    }
    return dbxTeamGroupsMembersSetAccessType;
}

+ (DbxRoute *)dbxTeamGroupsUpdate {
    if (!dbxTeamGroupsUpdate) {
        dbxTeamGroupsUpdate = [[DbxRoute alloc] init:
            @"groups/update"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGroupFullInfo class]
            errorType:[DbxTeamGroupUpdateError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamGroupsUpdate;
}

+ (DbxRoute *)dbxTeamLinkedAppsListMemberLinkedApps {
    if (!dbxTeamLinkedAppsListMemberLinkedApps) {
        dbxTeamLinkedAppsListMemberLinkedApps = [[DbxRoute alloc] init:
            @"linked_apps/list_member_linked_apps"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamListMemberAppsResult class]
            errorType:[DbxTeamListMemberAppsError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamLinkedAppsListMemberLinkedApps;
}

+ (DbxRoute *)dbxTeamLinkedAppsListMembersLinkedApps {
    if (!dbxTeamLinkedAppsListMembersLinkedApps) {
        dbxTeamLinkedAppsListMembersLinkedApps = [[DbxRoute alloc] init:
            @"linked_apps/list_members_linked_apps"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamListMembersAppsResult class]
            errorType:[DbxTeamListMembersAppsError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamLinkedAppsListMembersLinkedApps;
}

+ (DbxRoute *)dbxTeamLinkedAppsListTeamLinkedApps {
    if (!dbxTeamLinkedAppsListTeamLinkedApps) {
        dbxTeamLinkedAppsListTeamLinkedApps = [[DbxRoute alloc] init:
            @"linked_apps/list_team_linked_apps"
            namespace_:@"team"
            deprecated:@YES
            resultType:[DbxTeamListTeamAppsResult class]
            errorType:[DbxTeamListTeamAppsError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamLinkedAppsListTeamLinkedApps;
}

+ (DbxRoute *)dbxTeamLinkedAppsRevokeLinkedApp {
    if (!dbxTeamLinkedAppsRevokeLinkedApp) {
        dbxTeamLinkedAppsRevokeLinkedApp = [[DbxRoute alloc] init:
            @"linked_apps/revoke_linked_app"
            namespace_:@"team"
            deprecated:@NO
            resultType:nil
            errorType:[DbxTeamRevokeLinkedAppError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamLinkedAppsRevokeLinkedApp;
}

+ (DbxRoute *)dbxTeamLinkedAppsRevokeLinkedAppBatch {
    if (!dbxTeamLinkedAppsRevokeLinkedAppBatch) {
        dbxTeamLinkedAppsRevokeLinkedAppBatch = [[DbxRoute alloc] init:
            @"linked_apps/revoke_linked_app_batch"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamRevokeLinkedAppBatchResult class]
            errorType:[DbxTeamRevokeLinkedAppBatchError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamLinkedAppsRevokeLinkedAppBatch;
}

+ (DbxRoute *)dbxTeamMembersAdd {
    if (!dbxTeamMembersAdd) {
        dbxTeamMembersAdd = [[DbxRoute alloc] init:
            @"members/add"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamMembersAddLaunch class]
            errorType:nil
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamMembersAdd;
}

+ (DbxRoute *)dbxTeamMembersAddJobStatusGet {
    if (!dbxTeamMembersAddJobStatusGet) {
        dbxTeamMembersAddJobStatusGet = [[DbxRoute alloc] init:
            @"members/add/job_status/get"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamMembersAddJobStatus class]
            errorType:[DbxAsyncPollError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamMembersAddJobStatusGet;
}

+ (DbxRoute *)dbxTeamMembersGetInfo {
    if (!dbxTeamMembersGetInfo) {
        dbxTeamMembersGetInfo = [[DbxRoute alloc] init:
            @"members/get_info"
            namespace_:@"team"
            deprecated:@NO
            resultType:[NSArray<DbxTeamMembersGetInfoItem *> class]
            errorType:[DbxTeamMembersGetInfoError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:^id(id array) { return [DbxArraySerializer deserialize:array withBlock:^id(id elem) { return [DbxTeamMembersGetInfoItemSerializer deserialize:elem]; }]; }
        ];
    }
    return dbxTeamMembersGetInfo;
}

+ (DbxRoute *)dbxTeamMembersList {
    if (!dbxTeamMembersList) {
        dbxTeamMembersList = [[DbxRoute alloc] init:
            @"members/list"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamMembersListResult class]
            errorType:[DbxTeamMembersListError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamMembersList;
}

+ (DbxRoute *)dbxTeamMembersListContinue {
    if (!dbxTeamMembersListContinue) {
        dbxTeamMembersListContinue = [[DbxRoute alloc] init:
            @"members/list/continue"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamMembersListResult class]
            errorType:[DbxTeamMembersListContinueError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamMembersListContinue;
}

+ (DbxRoute *)dbxTeamMembersRecover {
    if (!dbxTeamMembersRecover) {
        dbxTeamMembersRecover = [[DbxRoute alloc] init:
            @"members/recover"
            namespace_:@"team"
            deprecated:@NO
            resultType:nil
            errorType:[DbxTeamMembersRecoverError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamMembersRecover;
}

+ (DbxRoute *)dbxTeamMembersRemove {
    if (!dbxTeamMembersRemove) {
        dbxTeamMembersRemove = [[DbxRoute alloc] init:
            @"members/remove"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxAsyncLaunchEmptyResult class]
            errorType:[DbxTeamMembersRemoveError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamMembersRemove;
}

+ (DbxRoute *)dbxTeamMembersRemoveJobStatusGet {
    if (!dbxTeamMembersRemoveJobStatusGet) {
        dbxTeamMembersRemoveJobStatusGet = [[DbxRoute alloc] init:
            @"members/remove/job_status/get"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxAsyncPollEmptyResult class]
            errorType:[DbxAsyncPollError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamMembersRemoveJobStatusGet;
}

+ (DbxRoute *)dbxTeamMembersSendWelcomeEmail {
    if (!dbxTeamMembersSendWelcomeEmail) {
        dbxTeamMembersSendWelcomeEmail = [[DbxRoute alloc] init:
            @"members/send_welcome_email"
            namespace_:@"team"
            deprecated:@NO
            resultType:nil
            errorType:[DbxTeamMembersSendWelcomeError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamMembersSendWelcomeEmail;
}

+ (DbxRoute *)dbxTeamMembersSetAdminPermissions {
    if (!dbxTeamMembersSetAdminPermissions) {
        dbxTeamMembersSetAdminPermissions = [[DbxRoute alloc] init:
            @"members/set_admin_permissions"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamMembersSetPermissionsResult class]
            errorType:[DbxTeamMembersSetPermissionsError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamMembersSetAdminPermissions;
}

+ (DbxRoute *)dbxTeamMembersSetProfile {
    if (!dbxTeamMembersSetProfile) {
        dbxTeamMembersSetProfile = [[DbxRoute alloc] init:
            @"members/set_profile"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamTeamMemberInfo class]
            errorType:[DbxTeamMembersSetProfileError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamMembersSetProfile;
}

+ (DbxRoute *)dbxTeamMembersSuspend {
    if (!dbxTeamMembersSuspend) {
        dbxTeamMembersSuspend = [[DbxRoute alloc] init:
            @"members/suspend"
            namespace_:@"team"
            deprecated:@NO
            resultType:nil
            errorType:[DbxTeamMembersSuspendError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamMembersSuspend;
}

+ (DbxRoute *)dbxTeamMembersUnsuspend {
    if (!dbxTeamMembersUnsuspend) {
        dbxTeamMembersUnsuspend = [[DbxRoute alloc] init:
            @"members/unsuspend"
            namespace_:@"team"
            deprecated:@NO
            resultType:nil
            errorType:[DbxTeamMembersUnsuspendError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamMembersUnsuspend;
}

+ (DbxRoute *)dbxTeamPropertiesTemplateAdd {
    if (!dbxTeamPropertiesTemplateAdd) {
        dbxTeamPropertiesTemplateAdd = [[DbxRoute alloc] init:
            @"properties/template/add"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamAddPropertyTemplateResult class]
            errorType:[DbxPropertiesModifyPropertyTemplateError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamPropertiesTemplateAdd;
}

+ (DbxRoute *)dbxTeamPropertiesTemplateGet {
    if (!dbxTeamPropertiesTemplateGet) {
        dbxTeamPropertiesTemplateGet = [[DbxRoute alloc] init:
            @"properties/template/get"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxPropertiesGetPropertyTemplateResult class]
            errorType:[DbxPropertiesPropertyTemplateError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamPropertiesTemplateGet;
}

+ (DbxRoute *)dbxTeamPropertiesTemplateList {
    if (!dbxTeamPropertiesTemplateList) {
        dbxTeamPropertiesTemplateList = [[DbxRoute alloc] init:
            @"properties/template/list"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxPropertiesListPropertyTemplateIds class]
            errorType:[DbxPropertiesPropertyTemplateError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamPropertiesTemplateList;
}

+ (DbxRoute *)dbxTeamPropertiesTemplateUpdate {
    if (!dbxTeamPropertiesTemplateUpdate) {
        dbxTeamPropertiesTemplateUpdate = [[DbxRoute alloc] init:
            @"properties/template/update"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamUpdatePropertyTemplateResult class]
            errorType:[DbxPropertiesModifyPropertyTemplateError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamPropertiesTemplateUpdate;
}

+ (DbxRoute *)dbxTeamReportsGetActivity {
    if (!dbxTeamReportsGetActivity) {
        dbxTeamReportsGetActivity = [[DbxRoute alloc] init:
            @"reports/get_activity"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGetActivityReport class]
            errorType:[DbxTeamDateRangeError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamReportsGetActivity;
}

+ (DbxRoute *)dbxTeamReportsGetDevices {
    if (!dbxTeamReportsGetDevices) {
        dbxTeamReportsGetDevices = [[DbxRoute alloc] init:
            @"reports/get_devices"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGetDevicesReport class]
            errorType:[DbxTeamDateRangeError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamReportsGetDevices;
}

+ (DbxRoute *)dbxTeamReportsGetMembership {
    if (!dbxTeamReportsGetMembership) {
        dbxTeamReportsGetMembership = [[DbxRoute alloc] init:
            @"reports/get_membership"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGetMembershipReport class]
            errorType:[DbxTeamDateRangeError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamReportsGetMembership;
}

+ (DbxRoute *)dbxTeamReportsGetStorage {
    if (!dbxTeamReportsGetStorage) {
        dbxTeamReportsGetStorage = [[DbxRoute alloc] init:
            @"reports/get_storage"
            namespace_:@"team"
            deprecated:@NO
            resultType:[DbxTeamGetStorageReport class]
            errorType:[DbxTeamDateRangeError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxTeamReportsGetStorage;
}

@end
