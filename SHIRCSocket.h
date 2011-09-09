//
//  SHIRCSocket.h
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Foundation/NSStream.h"
@class SHIRCChannel;
@class SHIRCSocket;
typedef enum SHSocketStaus
{
    SHSocketStausNotOpen,
    SHSocketStausConnecting,
    SHSocketStausOpen,
    SHSocketStausClosed
} SHSocketStaus;
@interface SHIRCSocket : NSObject <NSStreamDelegate>
{
    NSInputStream* input;
    NSOutputStream* output;
    NSString* server;
    int port;
    BOOL usesSSL;
    SHSocketStaus status;
    NSMutableString* data;
    BOOL didRegister;
    NSMutableArray* commandsWaiting;
    NSMutableString* queuedCommands;
    NSMutableArray* channels;
    NSString* nick_;
    BOOL canWrite;
}
@property(retain, readwrite) NSInputStream* input;
@property(retain, readwrite) NSOutputStream* output;
@property(retain, readwrite) NSString* server;
@property(retain, readwrite) NSString* nick_;
@property(assign, readwrite) NSMutableArray* channels;
@property(assign, readwrite) int port;
@property(assign, readwrite) BOOL usesSSL;
@property(assign, readwrite) BOOL didRegister;
@property(assign, readwrite) SHSocketStaus status;
+ (SHIRCSocket*)socketWithServer:(NSString *)srv andPort:(int)prt usesSSL:(BOOL)ssl;
- (BOOL)connectWithNick:(NSString *)nick andUser:(NSString *)user;
- (BOOL)sendCommand:(NSString *)command withArguments:(NSString *)args;
- (BOOL)sendCommand:(NSString *)command withArguments:(NSString*)args waitUntilRegistered:(BOOL)wur;
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent;
- (void)disconnect;
- (void)addChannel:(SHIRCChannel*)chan;
- (void)removeChannel:(SHIRCChannel*)chan;
- (void)setDidRegister:(BOOL)didReg;
- (void)dealloc;
- (SHIRCChannel*)retainedChannelWithFormattedName:(NSString*)fName;
@end
