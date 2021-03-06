#import "TRWeatherLocation.h"

@interface TRWeatherLocation ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readwrite) NSString *city;
@property (nonatomic, copy, readwrite) NSString *state;

@end

@implementation TRWeatherLocation

- (instancetype)initWithPlacemark:(CLPlacemark *)placemark
{
    self = [super init];
    if (!self) return nil;

    self.coordinate = placemark.location.coordinate;
    self.city = placemark.locality;
    self.state = placemark.administrativeArea;

    return self;
}

@end
