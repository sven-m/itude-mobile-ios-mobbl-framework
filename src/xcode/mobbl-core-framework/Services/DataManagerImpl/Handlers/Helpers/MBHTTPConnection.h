/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  MBHTTPConnection.h
//  mobbl-core-framework
//
//  Created by Sven Meyer on 16/07/14.

#import <Foundation/Foundation.h>
#import "MBHTTPConnectionDelegate.h"

@protocol MBHTTPConnection <NSObject>

@property (nonatomic, readonly) id<MBHTTPConnectionDelegate> delegate;

- (NSURLRequest *)originalRequest;
- (NSURLRequest *)currentRequest;

- (void)cancel;

@end
