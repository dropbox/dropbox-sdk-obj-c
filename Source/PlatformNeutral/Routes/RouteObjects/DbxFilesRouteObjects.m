/// 
/// Stone Route Objects
/// 

#import "DbxFilesRouteObjects.h"
#import "DbxFilesRoutes.h"
#import "DbxStoneBase.h"

@implementation DbxFilesRouteObjects 

static DbxRoute *dbxFilesAlphaGetMetadata = nil;
static DbxRoute *dbxFilesAlphaUpload = nil;
static DbxRoute *dbxFilesDCopy = nil;
static DbxRoute *dbxFilesDCopyReferenceGet = nil;
static DbxRoute *dbxFilesDCopyReferenceSave = nil;
static DbxRoute *dbxFilesCreateFolder = nil;
static DbxRoute *dbxFilesDelete_ = nil;
static DbxRoute *dbxFilesDownload = nil;
static DbxRoute *dbxFilesGetMetadata = nil;
static DbxRoute *dbxFilesGetPreview = nil;
static DbxRoute *dbxFilesGetTemporaryLink = nil;
static DbxRoute *dbxFilesGetThumbnail = nil;
static DbxRoute *dbxFilesListFolder = nil;
static DbxRoute *dbxFilesListFolderContinue = nil;
static DbxRoute *dbxFilesListFolderGetLatestCursor = nil;
static DbxRoute *dbxFilesListFolderLongpoll = nil;
static DbxRoute *dbxFilesListRevisions = nil;
static DbxRoute *dbxFilesMove = nil;
static DbxRoute *dbxFilesPermanentlyDelete = nil;
static DbxRoute *dbxFilesPropertiesAdd = nil;
static DbxRoute *dbxFilesPropertiesOverwrite = nil;
static DbxRoute *dbxFilesPropertiesRemove = nil;
static DbxRoute *dbxFilesPropertiesTemplateGet = nil;
static DbxRoute *dbxFilesPropertiesTemplateList = nil;
static DbxRoute *dbxFilesPropertiesUpdate = nil;
static DbxRoute *dbxFilesRestore = nil;
static DbxRoute *dbxFilesSaveUrl = nil;
static DbxRoute *dbxFilesSaveUrlCheckJobStatus = nil;
static DbxRoute *dbxFilesSearch = nil;
static DbxRoute *dbxFilesUpload = nil;
static DbxRoute *dbxFilesUploadSessionAppend = nil;
static DbxRoute *dbxFilesUploadSessionAppendV2 = nil;
static DbxRoute *dbxFilesUploadSessionFinish = nil;
static DbxRoute *dbxFilesUploadSessionFinishBatch = nil;
static DbxRoute *dbxFilesUploadSessionFinishBatchCheck = nil;
static DbxRoute *dbxFilesUploadSessionStart = nil;

+ (DbxRoute *)dbxFilesAlphaGetMetadata {
    if (!dbxFilesAlphaGetMetadata) {
        dbxFilesAlphaGetMetadata = [[DbxRoute alloc] init:
            @"alpha/get_metadata"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesMetadata class]
            errorType:[DbxFilesAlphaGetMetadataError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesAlphaGetMetadata;
}

+ (DbxRoute *)dbxFilesAlphaUpload {
    if (!dbxFilesAlphaUpload) {
        dbxFilesAlphaUpload = [[DbxRoute alloc] init:
            @"alpha/upload"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesFileMetadata class]
            errorType:[DbxFilesUploadErrorWithProperties class]
            attrs:@{@"host": @"content",
                    @"style": @"upload"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesAlphaUpload;
}

+ (DbxRoute *)dbxFilesDCopy {
    if (!dbxFilesDCopy) {
        dbxFilesDCopy = [[DbxRoute alloc] init:
            @"copy"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesMetadata class]
            errorType:[DbxFilesRelocationError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesDCopy;
}

+ (DbxRoute *)dbxFilesDCopyReferenceGet {
    if (!dbxFilesDCopyReferenceGet) {
        dbxFilesDCopyReferenceGet = [[DbxRoute alloc] init:
            @"copy_reference/get"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesGetCopyReferenceResult class]
            errorType:[DbxFilesGetCopyReferenceError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesDCopyReferenceGet;
}

+ (DbxRoute *)dbxFilesDCopyReferenceSave {
    if (!dbxFilesDCopyReferenceSave) {
        dbxFilesDCopyReferenceSave = [[DbxRoute alloc] init:
            @"copy_reference/save"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesSaveCopyReferenceResult class]
            errorType:[DbxFilesSaveCopyReferenceError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesDCopyReferenceSave;
}

+ (DbxRoute *)dbxFilesCreateFolder {
    if (!dbxFilesCreateFolder) {
        dbxFilesCreateFolder = [[DbxRoute alloc] init:
            @"create_folder"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesFolderMetadata class]
            errorType:[DbxFilesCreateFolderError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesCreateFolder;
}

+ (DbxRoute *)dbxFilesDelete_ {
    if (!dbxFilesDelete_) {
        dbxFilesDelete_ = [[DbxRoute alloc] init:
            @"delete"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesMetadata class]
            errorType:[DbxFilesDeleteError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesDelete_;
}

+ (DbxRoute *)dbxFilesDownload {
    if (!dbxFilesDownload) {
        dbxFilesDownload = [[DbxRoute alloc] init:
            @"download"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesFileMetadata class]
            errorType:[DbxFilesDownloadError class]
            attrs:@{@"host": @"content",
                    @"style": @"download"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesDownload;
}

+ (DbxRoute *)dbxFilesGetMetadata {
    if (!dbxFilesGetMetadata) {
        dbxFilesGetMetadata = [[DbxRoute alloc] init:
            @"get_metadata"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesMetadata class]
            errorType:[DbxFilesGetMetadataError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesGetMetadata;
}

+ (DbxRoute *)dbxFilesGetPreview {
    if (!dbxFilesGetPreview) {
        dbxFilesGetPreview = [[DbxRoute alloc] init:
            @"get_preview"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesFileMetadata class]
            errorType:[DbxFilesPreviewError class]
            attrs:@{@"host": @"content",
                    @"style": @"download"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesGetPreview;
}

+ (DbxRoute *)dbxFilesGetTemporaryLink {
    if (!dbxFilesGetTemporaryLink) {
        dbxFilesGetTemporaryLink = [[DbxRoute alloc] init:
            @"get_temporary_link"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesGetTemporaryLinkResult class]
            errorType:[DbxFilesGetTemporaryLinkError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesGetTemporaryLink;
}

+ (DbxRoute *)dbxFilesGetThumbnail {
    if (!dbxFilesGetThumbnail) {
        dbxFilesGetThumbnail = [[DbxRoute alloc] init:
            @"get_thumbnail"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesFileMetadata class]
            errorType:[DbxFilesThumbnailError class]
            attrs:@{@"host": @"content",
                    @"style": @"download"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesGetThumbnail;
}

+ (DbxRoute *)dbxFilesListFolder {
    if (!dbxFilesListFolder) {
        dbxFilesListFolder = [[DbxRoute alloc] init:
            @"list_folder"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesListFolderResult class]
            errorType:[DbxFilesListFolderError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesListFolder;
}

+ (DbxRoute *)dbxFilesListFolderContinue {
    if (!dbxFilesListFolderContinue) {
        dbxFilesListFolderContinue = [[DbxRoute alloc] init:
            @"list_folder/continue"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesListFolderResult class]
            errorType:[DbxFilesListFolderContinueError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesListFolderContinue;
}

+ (DbxRoute *)dbxFilesListFolderGetLatestCursor {
    if (!dbxFilesListFolderGetLatestCursor) {
        dbxFilesListFolderGetLatestCursor = [[DbxRoute alloc] init:
            @"list_folder/get_latest_cursor"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesListFolderGetLatestCursorResult class]
            errorType:[DbxFilesListFolderError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesListFolderGetLatestCursor;
}

+ (DbxRoute *)dbxFilesListFolderLongpoll {
    if (!dbxFilesListFolderLongpoll) {
        dbxFilesListFolderLongpoll = [[DbxRoute alloc] init:
            @"list_folder/longpoll"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesListFolderLongpollResult class]
            errorType:[DbxFilesListFolderLongpollError class]
            attrs:@{@"host": @"notify",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesListFolderLongpoll;
}

+ (DbxRoute *)dbxFilesListRevisions {
    if (!dbxFilesListRevisions) {
        dbxFilesListRevisions = [[DbxRoute alloc] init:
            @"list_revisions"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesListRevisionsResult class]
            errorType:[DbxFilesListRevisionsError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesListRevisions;
}

+ (DbxRoute *)dbxFilesMove {
    if (!dbxFilesMove) {
        dbxFilesMove = [[DbxRoute alloc] init:
            @"move"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesMetadata class]
            errorType:[DbxFilesRelocationError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesMove;
}

+ (DbxRoute *)dbxFilesPermanentlyDelete {
    if (!dbxFilesPermanentlyDelete) {
        dbxFilesPermanentlyDelete = [[DbxRoute alloc] init:
            @"permanently_delete"
            namespace_:@"files"
            deprecated:@NO
            resultType:nil
            errorType:[DbxFilesDeleteError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesPermanentlyDelete;
}

+ (DbxRoute *)dbxFilesPropertiesAdd {
    if (!dbxFilesPropertiesAdd) {
        dbxFilesPropertiesAdd = [[DbxRoute alloc] init:
            @"properties/add"
            namespace_:@"files"
            deprecated:@NO
            resultType:nil
            errorType:[DbxFilesAddPropertiesError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesPropertiesAdd;
}

+ (DbxRoute *)dbxFilesPropertiesOverwrite {
    if (!dbxFilesPropertiesOverwrite) {
        dbxFilesPropertiesOverwrite = [[DbxRoute alloc] init:
            @"properties/overwrite"
            namespace_:@"files"
            deprecated:@NO
            resultType:nil
            errorType:[DbxFilesInvalidPropertyGroupError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesPropertiesOverwrite;
}

+ (DbxRoute *)dbxFilesPropertiesRemove {
    if (!dbxFilesPropertiesRemove) {
        dbxFilesPropertiesRemove = [[DbxRoute alloc] init:
            @"properties/remove"
            namespace_:@"files"
            deprecated:@NO
            resultType:nil
            errorType:[DbxFilesRemovePropertiesError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesPropertiesRemove;
}

+ (DbxRoute *)dbxFilesPropertiesTemplateGet {
    if (!dbxFilesPropertiesTemplateGet) {
        dbxFilesPropertiesTemplateGet = [[DbxRoute alloc] init:
            @"properties/template/get"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxPropertiesGetPropertyTemplateResult class]
            errorType:[DbxPropertiesPropertyTemplateError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesPropertiesTemplateGet;
}

+ (DbxRoute *)dbxFilesPropertiesTemplateList {
    if (!dbxFilesPropertiesTemplateList) {
        dbxFilesPropertiesTemplateList = [[DbxRoute alloc] init:
            @"properties/template/list"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxPropertiesListPropertyTemplateIds class]
            errorType:[DbxPropertiesPropertyTemplateError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesPropertiesTemplateList;
}

+ (DbxRoute *)dbxFilesPropertiesUpdate {
    if (!dbxFilesPropertiesUpdate) {
        dbxFilesPropertiesUpdate = [[DbxRoute alloc] init:
            @"properties/update"
            namespace_:@"files"
            deprecated:@NO
            resultType:nil
            errorType:[DbxFilesUpdatePropertiesError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesPropertiesUpdate;
}

+ (DbxRoute *)dbxFilesRestore {
    if (!dbxFilesRestore) {
        dbxFilesRestore = [[DbxRoute alloc] init:
            @"restore"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesFileMetadata class]
            errorType:[DbxFilesRestoreError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesRestore;
}

+ (DbxRoute *)dbxFilesSaveUrl {
    if (!dbxFilesSaveUrl) {
        dbxFilesSaveUrl = [[DbxRoute alloc] init:
            @"save_url"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesSaveUrlResult class]
            errorType:[DbxFilesSaveUrlError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesSaveUrl;
}

+ (DbxRoute *)dbxFilesSaveUrlCheckJobStatus {
    if (!dbxFilesSaveUrlCheckJobStatus) {
        dbxFilesSaveUrlCheckJobStatus = [[DbxRoute alloc] init:
            @"save_url/check_job_status"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesSaveUrlJobStatus class]
            errorType:[DbxAsyncPollError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesSaveUrlCheckJobStatus;
}

+ (DbxRoute *)dbxFilesSearch {
    if (!dbxFilesSearch) {
        dbxFilesSearch = [[DbxRoute alloc] init:
            @"search"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesSearchResult class]
            errorType:[DbxFilesSearchError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesSearch;
}

+ (DbxRoute *)dbxFilesUpload {
    if (!dbxFilesUpload) {
        dbxFilesUpload = [[DbxRoute alloc] init:
            @"upload"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesFileMetadata class]
            errorType:[DbxFilesUploadError class]
            attrs:@{@"host": @"content",
                    @"style": @"upload"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesUpload;
}

+ (DbxRoute *)dbxFilesUploadSessionAppend {
    if (!dbxFilesUploadSessionAppend) {
        dbxFilesUploadSessionAppend = [[DbxRoute alloc] init:
            @"upload_session/append"
            namespace_:@"files"
            deprecated:@YES
            resultType:nil
            errorType:[DbxFilesUploadSessionLookupError class]
            attrs:@{@"host": @"content",
                    @"style": @"upload"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesUploadSessionAppend;
}

+ (DbxRoute *)dbxFilesUploadSessionAppendV2 {
    if (!dbxFilesUploadSessionAppendV2) {
        dbxFilesUploadSessionAppendV2 = [[DbxRoute alloc] init:
            @"upload_session/append_v2"
            namespace_:@"files"
            deprecated:@NO
            resultType:nil
            errorType:[DbxFilesUploadSessionLookupError class]
            attrs:@{@"host": @"content",
                    @"style": @"upload"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesUploadSessionAppendV2;
}

+ (DbxRoute *)dbxFilesUploadSessionFinish {
    if (!dbxFilesUploadSessionFinish) {
        dbxFilesUploadSessionFinish = [[DbxRoute alloc] init:
            @"upload_session/finish"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesFileMetadata class]
            errorType:[DbxFilesUploadSessionFinishError class]
            attrs:@{@"host": @"content",
                    @"style": @"upload"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesUploadSessionFinish;
}

+ (DbxRoute *)dbxFilesUploadSessionFinishBatch {
    if (!dbxFilesUploadSessionFinishBatch) {
        dbxFilesUploadSessionFinishBatch = [[DbxRoute alloc] init:
            @"upload_session/finish_batch"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxAsyncLaunchEmptyResult class]
            errorType:nil
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesUploadSessionFinishBatch;
}

+ (DbxRoute *)dbxFilesUploadSessionFinishBatchCheck {
    if (!dbxFilesUploadSessionFinishBatchCheck) {
        dbxFilesUploadSessionFinishBatchCheck = [[DbxRoute alloc] init:
            @"upload_session/finish_batch/check"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesUploadSessionFinishBatchJobStatus class]
            errorType:[DbxAsyncPollError class]
            attrs:@{@"host": @"api",
                    @"style": @"rpc"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesUploadSessionFinishBatchCheck;
}

+ (DbxRoute *)dbxFilesUploadSessionStart {
    if (!dbxFilesUploadSessionStart) {
        dbxFilesUploadSessionStart = [[DbxRoute alloc] init:
            @"upload_session/start"
            namespace_:@"files"
            deprecated:@NO
            resultType:[DbxFilesUploadSessionStartResult class]
            errorType:nil
            attrs:@{@"host": @"content",
                    @"style": @"upload"}
            arraySerialBlock:nil
            arrayDeserialBlock:nil
        ];
    }
    return dbxFilesUploadSessionStart;
}

@end
