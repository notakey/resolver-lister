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
@end

@implementation ResolverLister

- (NSArray<ResolverInfo*>*)listIPv4ResolversAsIpStrings
{
    res_state res;
    res_ninit(&_res);

    NSMutableArray *result = [NSMutableArray new];
    
    for (int i = 0; i < res->nscount; i++) {
        sa_family_t family = res->nsaddr_list[i].sin_family;
        
        if (family != AF_INET) {
            continue;
        }
        
        ResolverInfo* resultItem = [ResolverInfo new];
        
        char str[INET_ADDRSTRLEN]; // String representation of address
        inet_ntop(AF_INET, & (res->nsaddr_list[i].sin_addr.s_addr), str, INET_ADDRSTRLEN);
        resultItem.ipRepresentation = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
        resultItem.port = ntohs(res->nsaddr_list[i].sin_port);
        
        [result addObject:resultItem];
    }
    res_ndestroy(res);
    
    return result;
}

- (NSArray<ResolverInfo*>*)listIPv6ResolversAsIpStrings
{
    res_state res;
    res_ninit(&_res);
    
    NSMutableArray *result = [NSMutableArray new];
    
    for (int i = 0; i < res->nscount; i++) {
        sa_family_t family = res->nsaddr_list[i].sin_family;
        
        if (family != AF_INET6) {
            continue;
        }
        
        ResolverInfo* resultItem = [ResolverInfo new];
        
        char str[INET6_ADDRSTRLEN]; // String representation of address
        inet_ntop(AF_INET6, & (res->nsaddr_list[i].sin_addr.s_addr), str, INET6_ADDRSTRLEN);
        resultItem.ipRepresentation = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
        resultItem.port = ntohs(res->nsaddr_list[i].sin_port);
        
        [result addObject:resultItem];
    }
    res_ndestroy(res);
    
    return result;
}

@end