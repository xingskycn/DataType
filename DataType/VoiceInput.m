/**
 * 2012 Takumi SAKAMOTO <takumi.saka@gmail.com> All rights reserved.
 * License: Apache License 2.0
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */

#import "VoiceInput.h"

@implementation VoiceInput

@synthesize numPacketsToWrite;
@synthesize startingPacketCount;

@synthesize socket;
@synthesize dstHost;
@synthesize dstPort;
@synthesize tag;
@synthesize delegate;

static void inputCallback(void *                               inUserData,
                          AudioQueueRef                        inAQ,
                          AudioQueueBufferRef                  inBuffer,
                          const AudioTimeStamp *               inStartTime,
                          UInt32                               inNumberPacketDescriptions,
                          const AudioStreamPacketDescription   *inPacketDescs)
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    VoiceInput *input =(VoiceInput *)inUserData;
    
    NSUInteger length = inBuffer->mAudioDataByteSize;
    NSData *packet = [NSData dataWithBytes:inBuffer->mAudioData length:length]; 
    NSLog(@"发出的Data为:%@",packet);
    [input.socket sendData:packet toHost:input.dstHost port:input.dstPort 
                  withTimeout:-1 tag:input.tag];
    
    
    input.startingPacketCount += inNumberPacketDescriptions;
    
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    
    [pool release];
}

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        NSError *error = nil;
        if (![self.socket bindToPort:0 error:&error])
        {
            NSLog(@"[ERROR] Binding: %@", error);
            return nil  ;
        }
        if (![self.socket beginReceiving:&error])
        {
            NSLog(@"[ERROR] Receiving: %@", error);
            return nil;
        }
        tag = 0;
        
        NSLog(@" new VoiceInput:%@", self);
        
        
        
        [self prepareAudioQueue];
        
    }
    return self;
    
}

-(void)dealloc
{
    NSLog(@" dealloc VoiceInput");
    
    [self.socket close];
    [self.socket release];
    
	[super dealloc];
}

-(void)prepareAudioQueue
{
    AudioStreamBasicDescription audioFormat;
    
//    pcm
    audioFormat.mSampleRate			= 8000.0;
    audioFormat.mFormatID			= kAudioFormatLinearPCM;
    audioFormat.mFormatFlags        = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    audioFormat.mBytesPerPacket		= 2;
    audioFormat.mFramesPerPacket	= 1;
    audioFormat.mBytesPerFrame		= 2;
    audioFormat.mChannelsPerFrame	= 1;
    audioFormat.mBitsPerChannel		= 16;
    audioFormat.mReserved			= 0;
    
//    ulaw
    
//    audioFormat.mSampleRate			= 8000.0;
//    audioFormat.mFormatID			= kAudioFormatULaw;
//    audioFormat.mFormatFlags        = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked;
//    audioFormat.mBytesPerPacket		= 1;
//    audioFormat.mFramesPerPacket	= 1;
//    audioFormat.mBytesPerFrame		= 1;
//    audioFormat.mChannelsPerFrame	= 1;
//    audioFormat.mBitsPerChannel		= 16;
//    audioFormat.mReserved			= 0;
    
    AudioQueueNewInput(&audioFormat, 
                       inputCallback, 
                       self, 
                       NULL, 
                       NULL, 
                       0,
                       &audioQueueObject);
    
    startingPacketCount = 0;
    AudioQueueBufferRef buffers[3];
    
    numPacketsToWrite = 512;
    UInt32 bufferByteSize = numPacketsToWrite * audioFormat.mBytesPerPacket;
    
    int bufferIndex;
    for(bufferIndex = 0; bufferIndex < 3; bufferIndex++){
        AudioQueueAllocateBuffer(audioQueueObject,
                                 bufferByteSize,
                                 &buffers[bufferIndex]);
        AudioQueueEnqueueBuffer(audioQueueObject, buffers[bufferIndex], 0, NULL);
    }
}

-(void)start
{
    OSStatus err = AudioQueueStart(audioQueueObject, NULL);
    if(err){
		NSLog(@"AudioQueueStart = %ld", err);
	}
}

-(void)stop
{
    OSStatus err = AudioQueueStop(audioQueueObject, YES);
    if(err){
		NSLog(@"AudioQueueStart = %ld", err);
	}
   AudioQueueDispose(audioQueueObject, YES);    
    [self prepareAudioQueue];
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
	NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
        if ([delegate respondsToSelector:@selector(changeTheLable:)]) {
            
            [self.delegate changeTheLable:msg];
            
        }
    else {
        NSLog(@"Delegate is failed!");
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    
}


@end