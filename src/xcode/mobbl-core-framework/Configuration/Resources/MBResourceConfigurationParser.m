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

#import "MBResourceConfigurationParser.h"
#import "MBResourceDefinition.h"
#import "MBResourceConfiguration.h"
#import "MBBundleDefinition.h"

@implementation MBResourceConfigurationParser

@synthesize resourceAttributes = _resourceAttributes;
@synthesize bundleAttributes = _bundleAttributes;

- (void)dealloc {
    [_bundleAttributes release];
    [_resourceAttributes release];
    [super dealloc];
}

- (id) parseData:(NSData *)data ofDocument:(NSString*) documentName {
	
    self.resourceAttributes = [NSArray arrayWithObjects:@"xmlns",@"id",@"url",@"cacheable",@"ttl",nil];
    self.bundleAttributes = [NSArray arrayWithObjects:@"xmlns",@"languageCode",@"url",nil];
    return [super parseData:data ofDocument: documentName];
}

- (BOOL) processElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"Resources"]) { // start config file
		MBResourceConfiguration *confDef = [[MBResourceConfiguration alloc] init];
		[_stack addObject:confDef];
		[confDef release];
	}
	else if ([elementName isEqualToString:@"Resource"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_resourceAttributes];

		MBResourceDefinition *resourceDef = [[MBResourceDefinition alloc] init];
		resourceDef.resourceId = [attributeDict valueForKey:@"id"];
		resourceDef.url = [attributeDict valueForKey:@"url"];
		resourceDef.cacheable = [[attributeDict valueForKey:@"cacheable"] boolValue];	
		resourceDef.ttl = [[attributeDict valueForKey:@"ttl"] intValue];
		[[_stack lastObject] performSelector:@selector(addResource:) withObject:resourceDef];
		[_stack addObject:resourceDef];
		[resourceDef release];
	}
	else if ([elementName isEqualToString:@"Bundle"]) {
        [self checkAttributesForElement: elementName withAttributes:attributeDict withValids:_bundleAttributes];
		MBBundleDefinition *bundleDef = [[MBBundleDefinition alloc]init];
		bundleDef.url = [attributeDict valueForKey:@"url"];
		bundleDef.languageCode = [attributeDict valueForKey:@"languageCode"];
		[[_stack lastObject] performSelector:@selector(addBundle:) withObject:bundleDef];
		[_stack addObject:bundleDef];
		[bundleDef release];
	}
	else
		return NO;
	
	return YES;
}

- (void) didProcessElement:(NSString*)elementName {
	if (![elementName isEqualToString:@"Resources"]) // end config file
		[_stack removeLastObject];	
}

- (BOOL) isConcreteElement:(NSString*)element {
	return ([element isEqualToString:@"Resource"] ||
			[element isEqualToString:@"Bundle"] ||
			[element isEqualToString:@"Resources"]) ;
}

- (BOOL) isIgnoredElement:(NSString*)element {
	return NO;
}

@end
