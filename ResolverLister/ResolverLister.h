//
//  ResolverLister.h
//  ResolverLister
//
//  Created by Janis Kirsteins on 03.08.16.
//  Copyright © 2016. g. Notakey Latvia. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for ResolverLister.
FOUNDATION_EXPORT double ResolverListerVersionNumber;

//! Project version string for ResolverLister.
FOUNDATION_EXPORT const unsigned char ResolverListerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ResolverLister/PublicHeader.h>

@interface ResolverInfo : NSObject

@property (nonatomic, strong) NSString *ipRepresentation;
@property (nonatomic) int port;

@end

@interface ResolverLister : NSObject

- (NSArray<ResolverInfo*>*)listIPv4ResolversAsIpStrings;
- (NSArray<ResolverInfo*>*)listIPv6ResolversAsIpStrings;

@end

