/*
 * (C) Copyright ItudeMobile.
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
#import "MBDomainValidatorDefinition.h"
#import "MBDefinition.h"

@interface MBDomainDefinition : MBDefinition {
	NSString *_type;
	NSNumber *_maxLength;
	NSMutableArray *_validators;
}

- (void) addValidator:(MBDomainValidatorDefinition*)validator;
- (void) removeValidatorAtIndex:(NSUInteger)index;

@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSMutableArray* domainValidators;
@property (nonatomic, assign) NSNumber* maxLength;

@end