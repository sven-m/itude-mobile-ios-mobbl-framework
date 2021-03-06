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

#import "MBForEachDefinition.h"
#import "MBDefinition.h"

@implementation MBForEachDefinition

@synthesize value = _value;
@synthesize children = _children;
@synthesize variables = _variables;
@synthesize suppressRowComponent = _suppressRowComponent;


- (id) init {
	if (self = [super init]) {
		_children = [NSMutableArray new];
		_variables = [NSMutableDictionary new];
	}
	return self;
}

- (void) dealloc {	
	[_children release];
	[_variables release];
	[_value release];
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<ForEach value='%@' suppressRowComponent=%@>\n", level, "", _value, _suppressRowComponent?@"TRUE":@"FALSE"];
	for (MBDefinition* child in _children)
		[result appendString:[child asXmlWithLevel:level+2]];
	for (MBDefinition* child in [_variables allValues])
		[result appendString:[child asXmlWithLevel:level+2]];
	[result appendFormat:@"%*s</ForEach>\n", level, ""];
	return result;
}

- (void) addChild:(MBDefinition*)child {
	[_children addObject:child];
}

- (void) addVariable:(MBVariableDefinition*)variable {
	[_variables setObject:variable forKey:variable.name];
}

- (MBVariableDefinition*) variable:(NSString*)name {
	return 	[_variables objectForKey:name];
}

@end
