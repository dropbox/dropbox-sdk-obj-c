/// 
/// Stone Route Objects
/// 

#import "DbxAsyncLaunchEmptyResult.h"
#import "DbxAsyncLaunchResultBase.h"
#import "DbxAsyncPollArg.h"
#import "DbxAsyncPollEmptyResult.h"
#import "DbxAsyncPollError.h"
#import "DbxAsyncPollResultBase.h"
#import "DbxPropertiesGetPropertyTemplateArg.h"
#import "DbxPropertiesGetPropertyTemplateResult.h"
#import "DbxPropertiesListPropertyTemplateIds.h"
#import "DbxPropertiesModifyPropertyTemplateError.h"
#import "DbxPropertiesPropertyFieldTemplate.h"
#import "DbxPropertiesPropertyGroupTemplate.h"
#import "DbxPropertiesPropertyTemplateError.h"
#import "DbxStoneBase.h"
#import "DbxTeamActiveWebSession.h"
#import "DbxTeamAddPropertyTemplateArg.h"
#import "DbxTeamAddPropertyTemplateResult.h"
#import "DbxTeamAdminTier.h"
#import "DbxTeamApiApp.h"
#import "DbxTeamBaseDfbReport.h"
#import "DbxTeamCommonGroupManagementType.h"
#import "DbxTeamCommonGroupSummary.h"
#import "DbxTeamDateRange.h"
#import "DbxTeamDateRangeError.h"
#import "DbxTeamDesktopClientSession.h"
#import "DbxTeamDeviceSessionArg.h"
#import "DbxTeamDevicesActive.h"
#import "DbxTeamGetActivityReport.h"
#import "DbxTeamGetDevicesReport.h"
#import "DbxTeamGetMembershipReport.h"
#import "DbxTeamGetStorageReport.h"
#import "DbxTeamGroupAccessType.h"
#import "DbxTeamGroupCreateArg.h"
#import "DbxTeamGroupCreateError.h"
#import "DbxTeamGroupDeleteError.h"
#import "DbxTeamGroupFullInfo.h"
#import "DbxTeamGroupMemberInfo.h"
#import "DbxTeamGroupMemberSelector.h"
#import "DbxTeamGroupMemberSelectorError.h"
#import "DbxTeamGroupMemberSetAccessTypeError.h"
#import "DbxTeamGroupMembersAddArg.h"
#import "DbxTeamGroupMembersAddError.h"
#import "DbxTeamGroupMembersChangeResult.h"
#import "DbxTeamGroupMembersRemoveArg.h"
#import "DbxTeamGroupMembersRemoveError.h"
#import "DbxTeamGroupMembersSelectorError.h"
#import "DbxTeamGroupMembersSetAccessTypeArg.h"
#import "DbxTeamGroupSelector.h"
#import "DbxTeamGroupSelectorError.h"
#import "DbxTeamGroupUpdateArgs.h"
#import "DbxTeamGroupUpdateError.h"
#import "DbxTeamGroupsGetInfoError.h"
#import "DbxTeamGroupsGetInfoItem.h"
#import "DbxTeamGroupsListArg.h"
#import "DbxTeamGroupsListContinueArg.h"
#import "DbxTeamGroupsListContinueError.h"
#import "DbxTeamGroupsListResult.h"
#import "DbxTeamGroupsMembersListArg.h"
#import "DbxTeamGroupsMembersListContinueArg.h"
#import "DbxTeamGroupsMembersListContinueError.h"
#import "DbxTeamGroupsMembersListResult.h"
#import "DbxTeamGroupsPollError.h"
#import "DbxTeamGroupsSelector.h"
#import "DbxTeamIncludeMembersArg.h"
#import "DbxTeamListMemberAppsArg.h"
#import "DbxTeamListMemberAppsError.h"
#import "DbxTeamListMemberAppsResult.h"
#import "DbxTeamListMemberDevicesArg.h"
#import "DbxTeamListMemberDevicesError.h"
#import "DbxTeamListMemberDevicesResult.h"
#import "DbxTeamListMembersAppsArg.h"
#import "DbxTeamListMembersAppsError.h"
#import "DbxTeamListMembersAppsResult.h"
#import "DbxTeamListMembersDevicesArg.h"
#import "DbxTeamListMembersDevicesError.h"
#import "DbxTeamListMembersDevicesResult.h"
#import "DbxTeamListTeamAppsArg.h"
#import "DbxTeamListTeamAppsError.h"
#import "DbxTeamListTeamAppsResult.h"
#import "DbxTeamListTeamDevicesArg.h"
#import "DbxTeamListTeamDevicesError.h"
#import "DbxTeamListTeamDevicesResult.h"
#import "DbxTeamMemberAccess.h"
#import "DbxTeamMemberAddArg.h"
#import "DbxTeamMemberAddResult.h"
#import "DbxTeamMemberDevices.h"
#import "DbxTeamMemberLinkedApps.h"
#import "DbxTeamMemberSelectorError.h"
#import "DbxTeamMembersAddArg.h"
#import "DbxTeamMembersAddJobStatus.h"
#import "DbxTeamMembersAddLaunch.h"
#import "DbxTeamMembersDeactivateArg.h"
#import "DbxTeamMembersDeactivateError.h"
#import "DbxTeamMembersGetInfoArgs.h"
#import "DbxTeamMembersGetInfoError.h"
#import "DbxTeamMembersGetInfoItem.h"
#import "DbxTeamMembersListArg.h"
#import "DbxTeamMembersListContinueArg.h"
#import "DbxTeamMembersListContinueError.h"
#import "DbxTeamMembersListError.h"
#import "DbxTeamMembersListResult.h"
#import "DbxTeamMembersRecoverArg.h"
#import "DbxTeamMembersRecoverError.h"
#import "DbxTeamMembersRemoveArg.h"
#import "DbxTeamMembersRemoveError.h"
#import "DbxTeamMembersSendWelcomeError.h"
#import "DbxTeamMembersSetPermissionsArg.h"
#import "DbxTeamMembersSetPermissionsError.h"
#import "DbxTeamMembersSetPermissionsResult.h"
#import "DbxTeamMembersSetProfileArg.h"
#import "DbxTeamMembersSetProfileError.h"
#import "DbxTeamMembersSuspendError.h"
#import "DbxTeamMembersUnsuspendArg.h"
#import "DbxTeamMembersUnsuspendError.h"
#import "DbxTeamMobileClientSession.h"
#import "DbxTeamPoliciesTeamMemberPolicies.h"
#import "DbxTeamRevokeDesktopClientArg.h"
#import "DbxTeamRevokeDeviceSessionArg.h"
#import "DbxTeamRevokeDeviceSessionBatchArg.h"
#import "DbxTeamRevokeDeviceSessionBatchError.h"
#import "DbxTeamRevokeDeviceSessionBatchResult.h"
#import "DbxTeamRevokeDeviceSessionError.h"
#import "DbxTeamRevokeDeviceSessionStatus.h"
#import "DbxTeamRevokeLinkedApiAppArg.h"
#import "DbxTeamRevokeLinkedApiAppBatchArg.h"
#import "DbxTeamRevokeLinkedAppBatchError.h"
#import "DbxTeamRevokeLinkedAppBatchResult.h"
#import "DbxTeamRevokeLinkedAppError.h"
#import "DbxTeamRevokeLinkedAppStatus.h"
#import "DbxTeamRouteObjects.h"
#import "DbxTeamRoutes.h"
#import "DbxTeamStorageBucket.h"
#import "DbxTeamTeamGetInfoResult.h"
#import "DbxTeamTeamMemberInfo.h"
#import "DbxTeamTeamMemberProfile.h"
#import "DbxTeamUpdatePropertyTemplateArg.h"
#import "DbxTeamUpdatePropertyTemplateResult.h"
#import "DbxTeamUserSelectorArg.h"
#import "DbxTeamUserSelectorError.h"

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
            errorType: [DbxTeamGroupCreateError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamGroupsGetInfoError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: nil
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamGroupsListContinueError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamGroupUpdateError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamListMemberDevicesError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamListMembersDevicesError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamListTeamDevicesError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamRevokeDeviceSessionError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamRevokeDeviceSessionBatchError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: nil
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamGroupCreateError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamGroupDeleteError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamGroupsGetInfoError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamGroupsPollError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: nil
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamGroupsListContinueError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamGroupMembersAddError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamGroupSelectorError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamGroupsMembersListContinueError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamGroupMembersRemoveError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamGroupMemberSetAccessTypeError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamGroupUpdateError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamListMemberAppsError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamListMembersAppsError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamListTeamAppsError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamRevokeLinkedAppError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamRevokeLinkedAppBatchError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: nil
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxAsyncPollError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamMembersGetInfoError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamMembersListError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamMembersListContinueError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamMembersRecoverError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamMembersRemoveError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxAsyncPollError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamMembersSendWelcomeError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamMembersSetPermissionsError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamMembersSetProfileError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamMembersSuspendError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamMembersUnsuspendError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxPropertiesModifyPropertyTemplateError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxPropertiesPropertyTemplateError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxPropertiesPropertyTemplateError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxPropertiesModifyPropertyTemplateError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamDateRangeError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamDateRangeError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamDateRangeError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
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
            errorType: [DbxTeamDateRangeError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
        ];
    }
    return dbxTeamReportsGetStorage;
}

@end
