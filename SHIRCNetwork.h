//
//  SHIRCNetwork.h
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHIRCSocket.h"
@interface SHIRCNetwork : NSObject {
    SHIRCSocket *socket;
    NSString *server;
    NSString *descr;
    NSString *username;
    NSString *nickname;
    NSString *realname;
    NSString *serverPassword;
    NSString *nickServPassword;
    int port;
    NSMutableArray* channels;
    BOOL hasSSL;

}
@property(retain) NSString* server;
@property(retain) NSString* descr;
@property(retain) NSString* username;
@property(retain) NSString* nickname;
@property(retain) NSString* realname;
@property(retain) NSString* serverPassword;
@property(retain) NSString* nickServPassword;
@property(retain) NSMutableArray* channels;
@property(assign) int port;
@property(assign) BOOL hasSSL;
@property(assign) SHIRCSocket* socket;
+ (SHIRCNetwork*)createNetworkWithServer:(NSString*)server andPort:(int)port isSSLEnabled:(BOOL)ssl
                            description:(NSString*)description withUsername:(NSString*)username andNickname:(NSString*)nickname
                            andRealname:(NSString*)realname serverPassword:(NSString*)password nickServPassword:(NSString*)nickserv;
- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;
+ (void)saveDefaults;
- (void)saveDefaults;
- (void)dealloc;
+ (NSMutableArray *)allNetworks;
+ (NSMutableArray *)allConnectedNetworks;
- (void)hasBeenRegisteredCallback:(SHIRCSocket *)sock;
- (void)disconnect;
- (BOOL)isOpen;
- (id)description;
- (SHIRCSocket *)connect;
- (BOOL)isRegistered;
@end
