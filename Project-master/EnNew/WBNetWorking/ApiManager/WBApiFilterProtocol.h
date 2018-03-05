//
//  WBNetworkFilterProtocol.h
//  WBNetWork
//
//  Created by Haisheng Liang on 16/8/19.
//  Copyright © 2016年 Haisheng Liang. All rights reserved.
//

#ifndef WBNetworkFilterProtocol_h
#define WBNetworkFilterProtocol_h

@protocol WBUrlFilterProtocol <NSObject>

- (NSString*)filterUrl:(NSString*)url;

@end

@protocol WBNetworkParameterFilterProtocol <NSObject>

- (NSDictionary*)filterParameters:(NSDictionary*)parameters;

@end

@protocol WBNetworkResponseFilterProtocol <NSObject>

- (id)filterResponseData:(id)response;

@end


#endif /* WBNetworkFilterProtocol_h */
