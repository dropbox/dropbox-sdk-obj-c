///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBTasks.h"

@class DBASYNCLaunchEmptyResult;
@class DBASYNCLaunchResultBase;
@class DBASYNCPollError;
@class DBFILESLookupError;
@class DBNilObject;
@class DBSHARINGAccessInheritance;
@class DBSHARINGAccessLevel;
@class DBSHARINGAclUpdatePolicy;
@class DBSHARINGAddFileMemberError;
@class DBSHARINGAddFolderMemberError;
@class DBSHARINGAddMember;
@class DBSHARINGAddMemberSelectorError;
@class DBSHARINGCreateSharedLinkError;
@class DBSHARINGCreateSharedLinkWithSettingsError;
@class DBSHARINGExpectedSharedContentLinkMetadata;
@class DBSHARINGFileAction;
@class DBSHARINGFileMemberActionError;
@class DBSHARINGFileMemberActionIndividualResult;
@class DBSHARINGFileMemberActionResult;
@class DBSHARINGFileMemberRemoveActionResult;
@class DBSHARINGFilePermission;
@class DBSHARINGFolderAction;
@class DBSHARINGFolderPermission;
@class DBSHARINGFolderPolicy;
@class DBSHARINGGetFileMetadataBatchResult;
@class DBSHARINGGetFileMetadataError;
@class DBSHARINGGetFileMetadataIndividualResult;
@class DBSHARINGGetSharedLinkFileError;
@class DBSHARINGGetSharedLinksError;
@class DBSHARINGGetSharedLinksResult;
@class DBSHARINGGroupMembershipInfo;
@class DBSHARINGInsufficientQuotaAmounts;
@class DBSHARINGInviteeMembershipInfo;
@class DBSHARINGJobError;
@class DBSHARINGJobStatus;
@class DBSHARINGLinkAudience;
@class DBSHARINGLinkExpiry;
@class DBSHARINGLinkMetadata;
@class DBSHARINGLinkPassword;
@class DBSHARINGLinkPermissions;
@class DBSHARINGLinkSettings;
@class DBSHARINGListFileMembersBatchResult;
@class DBSHARINGListFileMembersContinueError;
@class DBSHARINGListFileMembersError;
@class DBSHARINGListFileMembersIndividualResult;
@class DBSHARINGListFilesContinueError;
@class DBSHARINGListFilesResult;
@class DBSHARINGListFolderMembersContinueError;
@class DBSHARINGListFoldersContinueError;
@class DBSHARINGListFoldersResult;
@class DBSHARINGListSharedLinksError;
@class DBSHARINGListSharedLinksResult;
@class DBSHARINGMemberAccessLevelResult;
@class DBSHARINGMemberAction;
@class DBSHARINGMemberPolicy;
@class DBSHARINGMemberSelector;
@class DBSHARINGModifySharedLinkSettingsError;
@class DBSHARINGMountFolderError;
@class DBSHARINGParentFolderAccessInfo;
@class DBSHARINGPathLinkMetadata;
@class DBSHARINGPendingUploadMode;
@class DBSHARINGRelinquishFileMembershipError;
@class DBSHARINGRelinquishFolderMembershipError;
@class DBSHARINGRemoveFileMemberError;
@class DBSHARINGRemoveFolderMemberError;
@class DBSHARINGRemoveMemberJobStatus;
@class DBSHARINGRequestedLinkAccessLevel;
@class DBSHARINGRequestedVisibility;
@class DBSHARINGRevokeSharedLinkError;
@class DBSHARINGSetAccessInheritanceError;
@class DBSHARINGShareFolderError;
@class DBSHARINGShareFolderJobStatus;
@class DBSHARINGShareFolderLaunch;
@class DBSHARINGSharePathError;
@class DBSHARINGSharedContentLinkMetadata;
@class DBSHARINGSharedFileMembers;
@class DBSHARINGSharedFileMetadata;
@class DBSHARINGSharedFolderAccessError;
@class DBSHARINGSharedFolderMemberError;
@class DBSHARINGSharedFolderMembers;
@class DBSHARINGSharedFolderMetadata;
@class DBSHARINGSharedLinkAlreadyExistsMetadata;
@class DBSHARINGSharedLinkError;
@class DBSHARINGSharedLinkMetadata;
@class DBSHARINGSharedLinkPolicy;
@class DBSHARINGSharedLinkSettings;
@class DBSHARINGSharedLinkSettingsError;
@class DBSHARINGSharingFileAccessError;
@class DBSHARINGSharingUserError;
@class DBSHARINGTeamMemberInfo;
@class DBSHARINGTransferFolderError;
@class DBSHARINGUnmountFolderError;
@class DBSHARINGUnshareFileError;
@class DBSHARINGUnshareFolderError;
@class DBSHARINGUpdateFolderMemberError;
@class DBSHARINGUpdateFolderPolicyError;
@class DBSHARINGUserFileMembershipInfo;
@class DBSHARINGUserMembershipInfo;
@class DBSHARINGViewerInfoPolicy;
@class DBSHARINGVisibility;
@class DBUSERSTeam;

@protocol DBTransportClient;

///
/// Routes for the `Sharing` namespace
///

NS_ASSUME_NONNULL_BEGIN

@interface DBSHARINGAppAuthRoutes : NSObject

/// An instance of the networking client that each route will use to submit a
/// request.
@property (nonatomic, readonly) id<DBTransportClient> client;

/// Initializes the `DBSHARINGAppAuthRoutes` namespace container object with a
/// networking client.
- (instancetype)init:(id<DBTransportClient>)client;

///
/// Get the shared link's metadata.
///
/// @param url URL of the shared link.
///
/// @return Through the response callback, the caller will receive a `DBSHARINGSharedLinkMetadata` object on success or
/// a `DBSHARINGSharedLinkError` object on failure.
///
- (DBRpcTask<DBSHARINGSharedLinkMetadata *, DBSHARINGSharedLinkError *> *)getSharedLinkMetadata:(NSString *)url;

///
/// Get the shared link's metadata.
///
/// @param url URL of the shared link.
/// @param path If the shared link is to a folder, this parameter can be used to retrieve the metadata for a specific
/// file or sub-folder in this folder. A relative path should be used.
/// @param linkPassword If the shared link has a password, this parameter can be used.
///
/// @return Through the response callback, the caller will receive a `DBSHARINGSharedLinkMetadata` object on success or
/// a `DBSHARINGSharedLinkError` object on failure.
///
- (DBRpcTask<DBSHARINGSharedLinkMetadata *, DBSHARINGSharedLinkError *> *)
    getSharedLinkMetadata:(NSString *)url
                     path:(nullable NSString *)path
             linkPassword:(nullable NSString *)linkPassword;

@end

NS_ASSUME_NONNULL_END
