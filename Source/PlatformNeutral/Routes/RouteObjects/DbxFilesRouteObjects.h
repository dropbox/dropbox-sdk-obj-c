/// 
/// Stone Route Objects
/// 

#import "DbxStoneBase.h"

@interface DbxFilesRouteObjects : NSObject 

+ (DbxRoute *)dbxFilesAlphaGetMetadata;

+ (DbxRoute *)dbxFilesAlphaUpload;

+ (DbxRoute *)dbxFilesDCopy;

+ (DbxRoute *)dbxFilesDCopyReferenceGet;

+ (DbxRoute *)dbxFilesDCopyReferenceSave;

+ (DbxRoute *)dbxFilesCreateFolder;

+ (DbxRoute *)dbxFilesDelete_;

+ (DbxRoute *)dbxFilesDownload;

+ (DbxRoute *)dbxFilesGetMetadata;

+ (DbxRoute *)dbxFilesGetPreview;

+ (DbxRoute *)dbxFilesGetTemporaryLink;

+ (DbxRoute *)dbxFilesGetThumbnail;

+ (DbxRoute *)dbxFilesListFolder;

+ (DbxRoute *)dbxFilesListFolderContinue;

+ (DbxRoute *)dbxFilesListFolderGetLatestCursor;

+ (DbxRoute *)dbxFilesListFolderLongpoll;

+ (DbxRoute *)dbxFilesListRevisions;

+ (DbxRoute *)dbxFilesMove;

+ (DbxRoute *)dbxFilesPermanentlyDelete;

+ (DbxRoute *)dbxFilesPropertiesAdd;

+ (DbxRoute *)dbxFilesPropertiesOverwrite;

+ (DbxRoute *)dbxFilesPropertiesRemove;

+ (DbxRoute *)dbxFilesPropertiesTemplateGet;

+ (DbxRoute *)dbxFilesPropertiesTemplateList;

+ (DbxRoute *)dbxFilesPropertiesUpdate;

+ (DbxRoute *)dbxFilesRestore;

+ (DbxRoute *)dbxFilesSaveUrl;

+ (DbxRoute *)dbxFilesSaveUrlCheckJobStatus;

+ (DbxRoute *)dbxFilesSearch;

+ (DbxRoute *)dbxFilesUpload;

+ (DbxRoute *)dbxFilesUploadSessionAppend;

+ (DbxRoute *)dbxFilesUploadSessionAppendV2;

+ (DbxRoute *)dbxFilesUploadSessionFinish;

+ (DbxRoute *)dbxFilesUploadSessionFinishBatch;

+ (DbxRoute *)dbxFilesUploadSessionFinishBatchCheck;

+ (DbxRoute *)dbxFilesUploadSessionStart;

@end
