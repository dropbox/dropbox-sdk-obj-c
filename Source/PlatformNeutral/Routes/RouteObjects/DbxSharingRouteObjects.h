/// 
/// Stone Route Objects
/// 

#import "DbxStoneBase.h"

@interface DbxSharingRouteObjects : NSObject 

+ (DbxRoute *)dbxSharingAddFileMember;

+ (DbxRoute *)dbxSharingAddFolderMember;

+ (DbxRoute *)dbxSharingChangeFileMemberAccess;

+ (DbxRoute *)dbxSharingCheckJobStatus;

+ (DbxRoute *)dbxSharingCheckRemoveMemberJobStatus;

+ (DbxRoute *)dbxSharingCheckShareJobStatus;

+ (DbxRoute *)dbxSharingCreateSharedLink;

+ (DbxRoute *)dbxSharingCreateSharedLinkWithSettings;

+ (DbxRoute *)dbxSharingGetFileMetadata;

+ (DbxRoute *)dbxSharingGetFileMetadataBatch;

+ (DbxRoute *)dbxSharingGetFolderMetadata;

+ (DbxRoute *)dbxSharingGetSharedLinkFile;

+ (DbxRoute *)dbxSharingGetSharedLinkMetadata;

+ (DbxRoute *)dbxSharingGetSharedLinks;

+ (DbxRoute *)dbxSharingListFileMembers;

+ (DbxRoute *)dbxSharingListFileMembersBatch;

+ (DbxRoute *)dbxSharingListFileMembersContinue;

+ (DbxRoute *)dbxSharingListFolderMembers;

+ (DbxRoute *)dbxSharingListFolderMembersContinue;

+ (DbxRoute *)dbxSharingListFolders;

+ (DbxRoute *)dbxSharingListFoldersContinue;

+ (DbxRoute *)dbxSharingListMountableFolders;

+ (DbxRoute *)dbxSharingListMountableFoldersContinue;

+ (DbxRoute *)dbxSharingListReceivedFiles;

+ (DbxRoute *)dbxSharingListReceivedFilesContinue;

+ (DbxRoute *)dbxSharingListSharedLinks;

+ (DbxRoute *)dbxSharingModifySharedLinkSettings;

+ (DbxRoute *)dbxSharingMountFolder;

+ (DbxRoute *)dbxSharingRelinquishFileMembership;

+ (DbxRoute *)dbxSharingRelinquishFolderMembership;

+ (DbxRoute *)dbxSharingRemoveFileMember;

+ (DbxRoute *)dbxSharingRemoveFileMember2;

+ (DbxRoute *)dbxSharingRemoveFolderMember;

+ (DbxRoute *)dbxSharingRevokeSharedLink;

+ (DbxRoute *)dbxSharingShareFolder;

+ (DbxRoute *)dbxSharingTransferFolder;

+ (DbxRoute *)dbxSharingUnmountFolder;

+ (DbxRoute *)dbxSharingUnshareFile;

+ (DbxRoute *)dbxSharingUnshareFolder;

+ (DbxRoute *)dbxSharingUpdateFolderMember;

+ (DbxRoute *)dbxSharingUpdateFolderPolicy;

@end
