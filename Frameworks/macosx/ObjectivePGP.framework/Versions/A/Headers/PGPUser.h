//
//  Copyright (c) Marcin Krzyżanowski. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY
//  INTERNATIONAL COPYRIGHT LAW. USAGE IS BOUND TO THE LICENSE AGREEMENT.
//  This notice may not be removed from this file.
//

#import <ObjectivePGP/PGPMacros.h>
#import <Foundation/Foundation.h>

#import <ObjectivePGP/ObjectivePGP.h>
#import <ObjectivePGP/PGPUserIDPacket.h>
#import <ObjectivePGP/PGPUserAttributePacket.h>
#import <ObjectivePGP/PGPSignaturePacket.h>


NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(User) @interface PGPUser : NSObject <NSCopying>

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, nullable) NSData *image;

@property (nonatomic, copy) NSArray<PGPSignaturePacket *> *selfCertifications;
@property (nonatomic, copy) NSArray<PGPSignaturePacket *> *otherSignatures;
@property (nonatomic, copy) NSArray<PGPSignaturePacket *> *revocationSignatures;

@property (nonatomic, copy, nullable) PGPUserAttributePacket *userAttribute;
@property (nonatomic, copy, readonly) PGPUserIDPacket *userIDPacket;

@property (nonatomic, readonly) NSArray<PGPPacket *> *allPackets;

- (instancetype)initWithUserIDPacket:(PGPUserIDPacket *)userPacket NS_DESIGNATED_INITIALIZER;

- (nullable PGPSignaturePacket *)latestSelfCertificate;

PGP_EMPTY_INIT_UNAVAILABLE

@end

NS_ASSUME_NONNULL_END
