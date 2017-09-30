//
//  PGPOnePassSignaturePacket.m
//  ObjectivePGP
//
//  Created by Marcin Krzyzanowski on 29/05/14.
//  Copyright (c) 2014 Marcin Krzyżanowski. All rights reserved.
//

#import "PGPOnePassSignaturePacket.h"
#import "PGPKeyID.h"
#import "PGPMacros.h"
#import "PGPMacros+Private.h"
#import "PGPFoundation.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PGPOnePassSignaturePacket

- (id)init {
    if (self = [super init]) {
        _version = 0x03;
    }
    return self;
}

- (PGPPacketTag)tag {
    return PGPOnePassSignaturePacketTag;
}

- (NSUInteger)parsePacketBody:(NSData *)packetBody error:(NSError *__autoreleasing *)error {
    NSUInteger position = [super parsePacketBody:packetBody error:error];

    [packetBody getBytes:&_version range:(NSRange){position, 1}];
    position = position + 1;

    [packetBody getBytes:&_signatureType range:(NSRange){position, 1}];
    position = position + 1;

    [packetBody getBytes:&_hashAlgorith range:(NSRange){position, 1}];
    position = position + 1;

    [packetBody getBytes:&_publicKeyAlgorithm range:(NSRange){position, 1}];
    position = position + 1;

    PGPKeyID *keyID = [[PGPKeyID alloc] initWithLongKey:[packetBody subdataWithRange:(NSRange){position, 8}]];
    self.keyID = keyID;
    position = position + 8;

    [packetBody getBytes:&_notNested range:(NSRange){position, 1}];
    position = position + 1;

    return position;
}

#pragma mark - isEqual

- (BOOL)isEqual:(id)other {
    if (self == other) { return YES; }
    if ([super isEqual:other] && [other isKindOfClass:self.class]) {
        return [self isEqualToOnePassSignaturePacket:other];
    }
    return NO;
}

- (BOOL)isEqualToOnePassSignaturePacket:(PGPOnePassSignaturePacket *)packet {
    return self.version = packet.version &&
           self.signatureType == packet.signatureType &&
           self.hashAlgorith == packet.hashAlgorith &&
           self.publicKeyAlgorithm == packet.publicKeyAlgorithm &&
           PGPEqualObjects(self.keyID, packet.keyID) &&
           self.notNested == packet.notNested;
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = [super hash];
    result = prime * result + self.version;
    result = prime * result + self.signatureType;
    result = prime * result + self.hashAlgorith;
    result = prime * result + self.publicKeyAlgorithm;
    result = prime * result + self.keyID.hash;
    result = prime * result + self.notNested;
    return result;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(nullable NSZone *)zone {
    let _Nullable copy = PGPCast([super copyWithZone:zone], PGPOnePassSignaturePacket);
    if (!copy) {
        return nil;
    }

    copy.version = self.version;
    copy.signatureType = self.signatureType;
    copy.hashAlgorith = self.hashAlgorith;
    copy.publicKeyAlgorithm = self.publicKeyAlgorithm;
    copy.keyID = [self.keyID copy];
    copy.notNested = self.notNested;
    return copy;
}

#pragma mark - PGPExportable

- (nullable NSData *)export:(NSError *__autoreleasing _Nullable *)error {
    NSAssert(self.keyID, @"Missing keyID");

    weakify(self);
    return [PGPPacket buildPacketOfType:self.tag withBody:^NSData * {
        strongify(self)
        let bodyData = [NSMutableData data];

        [bodyData appendBytes:&self->_version length:1];
        [bodyData appendBytes:&self->_signatureType length:1];
        [bodyData appendBytes:&self->_hashAlgorith length:1];
        [bodyData appendBytes:&self->_publicKeyAlgorithm length:1];
        [bodyData appendData:[self.keyID export:nil]];

        [bodyData appendBytes:&self->_notNested length:1];

        return bodyData;
    }];
}

@end

NS_ASSUME_NONNULL_END