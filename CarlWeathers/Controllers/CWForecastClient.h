//
//  CWForecastClient.h
//  CarlWeathers
//
//  Created by Mark Adams on 12/11/14.
//  Copyright (c) 2014 thoughtbot. All rights reserved.
//

@import Foundation;

@class CWCurrentConditions;

typedef void (^CWCurrentConditionsResult)(CWCurrentConditions *currentConditions);

@interface CWForecastClient : NSObject

- (void)fetchCurrentConditionsAtLatitude:(double)latitude longitude:(double)longitude completion:(CWCurrentConditionsResult)completion;

@end
