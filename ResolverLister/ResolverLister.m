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

- (NSArray<ResolverInfo*>*)generateResolverArray
{
    res_state res = malloc(sizeof(struct __res_state));
    
    if ( res_ninit(res) != 0 ) {
        return nil;
    }

    NSMutableArray *result = [NSMutableArray new];
    
    
    for (int i = 0; i < res->nscount; i++) {
        ResolverInfo* resultItem = [ResolverInfo new];
        
        sa_family_t family = res->nsaddr_list[i].sin_family;
        if (family == AF_INET) {
            resultItem.type = IpType_IPV4;
            
            char str[INET_ADDRSTRLEN];
            inet_ntop(AF_INET, & (res->nsaddr_list[i].sin_addr.s_addr), str, INET_ADDRSTRLEN);
            resultItem.ipRepresentation = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
        } else if (family == AF_INET6) {
            resultItem.type = IpType_IPV6;
            
            char str[INET6_ADDRSTRLEN];
            inet_ntop(AF_INET6, & (res->nsaddr_list[i].sin_addr.s_addr), str, INET6_ADDRSTRLEN);
            resultItem.ipRepresentation = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
        }
        
        resultItem.port = ntohs(res->nsaddr_list[i].sin_port);
        
        [result addObject:resultItem];
    }
    res_ndestroy(res);
    
    return result;
}


@end