/// 
/// Stone Route Objects
/// 

#import "DbxStoneBase.h"

@interface DbxTeamRouteObjects : NSObject 

+ (DbxRoute *)dbxTeamAlphaGroupsCreate;

+ (DbxRoute *)dbxTeamAlphaGroupsGetInfo;

+ (DbxRoute *)dbxTeamAlphaGroupsList;

+ (DbxRoute *)dbxTeamAlphaGroupsListContinue;

+ (DbxRoute *)dbxTeamAlphaGroupsUpdate;

+ (DbxRoute *)dbxTeamDevicesListMemberDevices;

+ (DbxRoute *)dbxTeamDevicesListMembersDevices;

+ (DbxRoute *)dbxTeamDevicesListTeamDevices;

+ (DbxRoute *)dbxTeamDevicesRevokeDeviceSession;

+ (DbxRoute *)dbxTeamDevicesRevokeDeviceSessionBatch;

+ (DbxRoute *)dbxTeamGetInfo;

+ (DbxRoute *)dbxTeamGroupsCreate;

+ (DbxRoute *)dbxTeamGroupsDelete;

+ (DbxRoute *)dbxTeamGroupsGetInfo;

+ (DbxRoute *)dbxTeamGroupsJobStatusGet;

+ (DbxRoute *)dbxTeamGroupsList;

+ (DbxRoute *)dbxTeamGroupsListContinue;

+ (DbxRoute *)dbxTeamGroupsMembersAdd;

+ (DbxRoute *)dbxTeamGroupsMembersList;

+ (DbxRoute *)dbxTeamGroupsMembersListContinue;

+ (DbxRoute *)dbxTeamGroupsMembersRemove;

+ (DbxRoute *)dbxTeamGroupsMembersSetAccessType;

+ (DbxRoute *)dbxTeamGroupsUpdate;

+ (DbxRoute *)dbxTeamLinkedAppsListMemberLinkedApps;

+ (DbxRoute *)dbxTeamLinkedAppsListMembersLinkedApps;

+ (DbxRoute *)dbxTeamLinkedAppsListTeamLinkedApps;

+ (DbxRoute *)dbxTeamLinkedAppsRevokeLinkedApp;

+ (DbxRoute *)dbxTeamLinkedAppsRevokeLinkedAppBatch;

+ (DbxRoute *)dbxTeamMembersAdd;

+ (DbxRoute *)dbxTeamMembersAddJobStatusGet;

+ (DbxRoute *)dbxTeamMembersGetInfo;

+ (DbxRoute *)dbxTeamMembersList;

+ (DbxRoute *)dbxTeamMembersListContinue;

+ (DbxRoute *)dbxTeamMembersRecover;

+ (DbxRoute *)dbxTeamMembersRemove;

+ (DbxRoute *)dbxTeamMembersRemoveJobStatusGet;

+ (DbxRoute *)dbxTeamMembersSendWelcomeEmail;

+ (DbxRoute *)dbxTeamMembersSetAdminPermissions;

+ (DbxRoute *)dbxTeamMembersSetProfile;

+ (DbxRoute *)dbxTeamMembersSuspend;

+ (DbxRoute *)dbxTeamMembersUnsuspend;

+ (DbxRoute *)dbxTeamPropertiesTemplateAdd;

+ (DbxRoute *)dbxTeamPropertiesTemplateGet;

+ (DbxRoute *)dbxTeamPropertiesTemplateList;

+ (DbxRoute *)dbxTeamPropertiesTemplateUpdate;

+ (DbxRoute *)dbxTeamReportsGetActivity;

+ (DbxRoute *)dbxTeamReportsGetDevices;

+ (DbxRoute *)dbxTeamReportsGetMembership;

+ (DbxRoute *)dbxTeamReportsGetStorage;

@end
