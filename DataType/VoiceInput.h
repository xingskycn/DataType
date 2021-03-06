/**
 * 2012 Takumi SAKAMOTO <takumi.saka@gmail.com> All rights reserved.
 * License: Apache License 2.0
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "GCDAsyncUdpSocket.h"

@protocol CheckFeedBackDelegate <NSObject>

-(void)changeTheLable:(NSString *)lableText;

@end

@interface VoiceInput : NSObject 
{
    AudioQueueRef audioQueueObject;
    UInt32 numPacketsToWrite;
    SInt64 startingPacketCount;
    id<CheckFeedBackDelegate> delegate;
    
    GCDAsyncUdpSocket *socket;
    long tag;
    NSString *dstHost;
    NSInteger dstPort;
}

-(void)start;
-(void)stop;

-(void)prepareAudioQueue;

@property UInt32 numPacketsToWrite;
@property SInt64 startingPacketCount;

@property (retain) GCDAsyncUdpSocket *socket;
@property (retain) NSString *dstHost;
@property (retain) id <CheckFeedBackDelegate> delegate;
@property NSInteger dstPort;
@property long tag;

@end