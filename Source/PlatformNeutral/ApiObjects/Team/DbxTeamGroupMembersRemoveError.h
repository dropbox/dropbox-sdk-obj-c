///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>
#import "DbxStoneSerializers.h"
#import "DbxTeamGroupMembersSelectorError.h"

@class DbxTeamGroupMembersRemoveError;

/// 
/// The DbxTeamGroupMembersRemoveError union.
/// 
@interface DbxTeamGroupMembersRemoveError : NSObject <DbxSerializable> 

typedef NS_ENUM(NSInteger, TeamGroupMembersRemoveErrorTag) {
    /// No matching group found. No groups match the specified group ID.
    TeamGroupMembersRemoveErrorGroupNotFound,
    /// (no description)
    TeamGroupMembersRemoveErrorOther,
    /// At least one of the specified users is not a member of the group.
    TeamGroupMembersRemoveErrorMemberNotInGroup,
    /// Group is not in this team. You cannot remove members from a group that
    /// is outside of your team.
    TeamGroupMembersRemoveErrorGroupNotInTeam,
};

- (nonnull instancetype)initWithGroupNotFound;

- (nonnull instancetype)initWithOther;

- (nonnull instancetype)initWithMemberNotInGroup;

- (nonnull instancetype)initWithGroupNotInTeam;

- (BOOL)isGroupNotFound;

- (BOOL)isOther;

- (BOOL)isMemberNotInGroup;

- (BOOL)isGroupNotInTeam;

- (NSString * _Nonnull)getTagName;

+ (NSDictionary * _Nonnull)serialize:(id _Nonnull)obj;

+ (id _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

- (NSString * _Nonnull)description;

/// Current state of the DbxTeamGroupMembersRemoveError union type.
@property (nonatomic) TeamGroupMembersRemoveErrorTag tag;

@end


@interface DbxTeamGroupMembersRemoveErrorSerializer : NSObject 

+ (NSDictionary * _Nonnull)serialize:(DbxTeamGroupMembersRemoveError * _Nonnull)obj;

+ (DbxTeamGroupMembersRemoveError * _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

@end