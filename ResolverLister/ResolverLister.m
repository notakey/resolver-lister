//
//  ResolverLister.m
//  ResolverLister
//
//  Created by Janis Kirsteins on 03.08.16.
//  Copyright © 2016. g. Notakey Latvia. All rights reserved.
//

#import "ResolverLister.h"

#import <Foundation/Foundation.h>
#import <resolv.h>
//#include <sys/socket.h>
//#include <netinet/in.h>
#import <arpa/inet.h>

@implementation ResolverInfo

- (NSString *)description {
    return [NSString stringWithFormat:@"%@:%d (%@)", self.ipRepresentation, self.port, self.type == IpType_IPV4 ? @"IPv4" : @"IPv6"];
}

@end

@implementation ResolverLister

- (NSArray<ResolverInfo*>*)generateResolverArray
{
    res_state res = malloc(sizeof(struct __res_state));
    
    if ( res_ninit(res) != 0 ) {
        return nil;
    }

    union res_9_sockaddr_union *addr_union = malloc(res->nscount * sizeof(union res_9_sockaddr_union));
    res_getservers(res, addr_union, res->nscount);
    
    NSMutableArray *result = [NSMutableArray new];
    
    for (int i = 0; i < res->nscount; i++) {
        ResolverInfo* resultItem = [ResolverInfo new];
        
        sa_family_t family = addr_union[i].sin.sin_family;
        if (family == AF_INET) {
            resultItem.type = IpType_IPV4;
            resultItem.port = ntohs(addr_union[i].sin.sin_port);
            
            char str[INET_ADDRSTRLEN];
            inet_ntop(AF_INET, & (addr_union[i].sin.sin_addr.s_addr), str, INET_ADDRSTRLEN);
            resultItem.ipRepresentation = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
        } else if (family == AF_INET6) {
            resultItem.type = IpType_IPV6;
            resultItem.port = ntohs(addr_union[i].sin6.sin6_port);
            
            char str[INET6_ADDRSTRLEN];
            inet_ntop(AF_INET6, & (addr_union[i].sin6.sin6_addr), str, INET6_ADDRSTRLEN);
            resultItem.ipRepresentation = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
        }
        
        
        
        [result addObject:resultItem];
    }
    res_ndestroy(res);
    
    return result;
}


@end