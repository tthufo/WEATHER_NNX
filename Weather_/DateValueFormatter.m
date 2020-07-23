//
//  DateValueFormatter.m
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//


#import "DateValueFormatter.h"

@interface DateValueFormatter ()
{
    NSDateFormatter *_dateFormatter;
    
    __weak LineChartView *_chart;
}
@end

@implementation DateValueFormatter

- (id)init
{
    self = [super init];
    if (self)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = NSLocale.currentLocale;
        _dateFormatter.dateFormat = @"HH:mm";
    }
    return self;
}

- (id)initForChart:(LineChartView *)chart
{
    self = [super init];
    if (self)
    {
        self->_chart = chart;
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = NSLocale.currentLocale;
        _dateFormatter.dateFormat = @"HH:mm";
    }
    return self;
}

- (NSString*)timer:(NSString*)time {    
    if ([[time componentsSeparatedByString:@" "] count] != 1) {
        NSString * val = [[time componentsSeparatedByString:@" "] firstObject];
        return val;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:[NSDate date]];
       
    NSString * val = [time stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@", year] withString:@""];
    return val;
}


- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    NSArray * data = [_chart.accessibilityLabel objectFromJSONString];
    
       int myInt = (int)value;
       
//    NSLog(@"%i", myInt);

//       if (myInt > data.count) {
//           myInt = data.count - 1;
//       }
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"HH:mm dd/MM/yyyy"];
    NSDate *methodStart = [NSDate dateWithTimeIntervalSince1970:value];
//    NSLog(@"result: %@", [_dateFormatter stringFromDate:methodStart]);
    NSLog(@"result: %@", [dateFormatter stringFromDate:methodStart]);

//    return [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:value]];

    return [self timer: data[myInt][@"time"]];
}

@end
