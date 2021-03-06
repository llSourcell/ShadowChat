//
//  SHIRCChannel.h
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHIRCSocket.h"
#import "SHChatPanel.h"
#import "SHIRCChannel.h"

typedef enum SHMessageFlavor {
    SHMessageFlavorNormal,
    SHMessageFlavorAction,
    SHMessageFlavorNotice
} SHMessageFlavor;

typedef enum SHEventType {
    SHEventTypePart,
    SHEventTypeMode,
    SHEventTypeJoin,
    SHEventTypeKick
} SHEventType;

@interface SHIRCChannel : NSObject {
    NSString *net;
    NSString *name;
	BOOL joined;
	NSMutableArray *users;
    SHIRCSocket* socket;
    id delegate;
}
@property (retain) NSString *net;
@property (retain) NSString *name;
@property (assign) SHIRCSocket *socket;
@property (nonatomic, retain) NSMutableArray *users;
@property (retain) id delegate;
- (id)initWithSocket:(SHIRCSocket *)sock andChanName:(NSString *)chName;
- (BOOL)sendMessage:(NSString *)message flavor:(SHMessageFlavor)flavor;
- (NSString *)formattedName;
- (void)part;
- (void)setIsJoined:(BOOL)joind;
- (BOOL)isJoined;
- (void)addUsers:(NSArray *)users;
- (void)didRecieveMessageFrom:(NSString *)nick text:(NSString *)ircMessage;
- (void)parseCommand:(NSString *)command;
- (void)parseAndEventuallySendMessage:(NSString *)command;
- (void)didRecieveActionFrom:(NSString*)nick text:(NSString *)ircMessage;
- (void)didRecieveEvent:(SHEventType)nick from:(NSString *)from to:(NSString *)to extra:(NSString *)extra;
- (void)didRecieveNamesList:(NSArray *)array;
@end
