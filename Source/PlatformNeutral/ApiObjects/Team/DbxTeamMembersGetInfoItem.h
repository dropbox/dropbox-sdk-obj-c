///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>
#import "DbxStoneSerializers.h"

@class DbxTeamMembersGetInfoItem;
@class DbxTeamTeamMemberInfo;

/// 
/// The DbxTeamMembersGetInfoItem union.
/// 
/// Describes a result obtained for a single user whose id was specified in the
/// parameter of membersGetInfo.
/// 
@interface DbxTeamMembersGetInfoItem : NSObject <DbxSerializable> 

typedef NS_ENUM(NSInteger, TeamMembersGetInfoItemTag) {
    /// An ID that was provided as a parameter to membersGetInfo, and did not
    /// match a corresponding user. This might be a team_member_id, an email, or
    /// an external ID, depending on how the method was called.
    TeamMembersGetInfoItemIdNotFound,
    /// Info about a team member.
    TeamMembersGetInfoItemMemberInfo,
};

- (nonnull instancetype)initWithIdNotFound:(NSString * _Nonnull)idNotFound;

- (nonnull instancetype)initWithMemberInfo:(DbxTeamTeamMemberInfo * _Nonnull)memberInfo;

- (BOOL)isIdNotFound;

- (BOOL)isMemberInfo;

- (NSString * _Nonnull)getTagName;

+ (NSDictionary * _Nonnull)serialize:(id _Nonnull)obj;

+ (id _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

- (NSString * _Nonnull)description;

/// Current state of the DbxTeamMembersGetInfoItem union type.
@property (nonatomic) TeamMembersGetInfoItemTag tag;
@property (nonatomic, copy) NSString * _Nonnull idNotFound;
@property (nonatomic) DbxTeamTeamMemberInfo * _Nonnull memberInfo;

@end


@interface DbxTeamMembersGetInfoItemSerializer : NSObject 

+ (NSDictionary * _Nonnull)serialize:(DbxTeamMembersGetInfoItem * _Nonnull)obj;

+ (DbxTeamMembersGetInfoItem * _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

@end