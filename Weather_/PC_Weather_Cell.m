//
//  PC_Weather_Cell.m
//  HearThis
//
//  Created by Thanh Hai Tran on 5/14/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

#import "PC_Weather_Cell.h"

#import "DateValueFormatter.h"

#import "Nhà_Nông_Xanh-Swift.h"

#include <math.h>

@import Charts;

@interface PC_Weather_Cell ()<ChartViewDelegate>
{
    NSMutableArray * dataSource, * titles;
    
    IBOutlet UILabel * date, * temprature, * unit, * up, * down, * current, * rainy;
    
    IBOutlet UIImageView * state;
}

@property (nonatomic, strong) IBOutlet LineChartView *chartView;

@end

@implementation PC_Weather_Cell

@synthesize data;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self chartState: YES];
}

- (NSString*)returnValue:(NSString*)key {
    NSDictionary * currently = data[@"currently"];
    
    if ([key isEqualToString:@"precipProbability"]) {
        NSString * value = [NSString stringWithFormat:@"%.0f", [[currently getValueFromKey:key] floatValue]];
        return value;
    }

    double tempo = [[self getValue:@"deg"] isEqualToString:@"0"] ? [[currently getValueFromKey:key] doubleValue] : ([[currently getValueFromKey:key] doubleValue] * 9/5) + 32;

    NSString * value = [NSString stringWithFormat:@"%.f", ceil(tempo)];
    
    return value;
}

- (NSString*)returnValueH:(NSDictionary*)currently {
                
    NSString * key = @"temperature";

    double tempo = [[self getValue:@"deg"] isEqualToString:@"0"] ? [[currently getValueFromKey:key] doubleValue] : ([[currently getValueFromKey:key] doubleValue] * 9/5) + 32;

    NSString * value = [NSString stringWithFormat:@"%.0f", ceil(tempo)];
    
    return value;
}

- (void)chartState:(BOOL)show {
    _chartView.alpha = !show ? 0 : [Information token] == nil ? 0 : 1 ;
}

- (void)prepareForReuse {
    [super prepareForReuse];
        
    [self chartState: YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:[NSDate date]];
    
    NSDictionary * currently = data[@"currently"];

    date.text = [NSString stringWithFormat:@"Cập nhật lúc %@", [[currently getValueFromKey:@"time"] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@", year] withString:@""]];
    
    temprature.text = [self returnValue:@"temperature"];
    
    unit.text = [[self getValue:@"deg"] isEqualToString:@"0"] ? @"°C" : @"°F";
    
    up.text = [NSString stringWithFormat:@"%@°↑", [self returnValue:@"temperatureHigh"]];

    down.text = [NSString stringWithFormat:@"%@°↓", [self returnValue:@"temperatureLow"]];

    current.text = [NSString stringWithFormat:@"Thực tế ~ %@°", [self returnValue:@"apparentTemperature"]];
    
    rainy.text = [NSString stringWithFormat:@"Khả năng mưa %@ %@", [self returnValue:@"precipProbability"], @"%"];
        
    
    state.image = [UIImage imageNamed:[[currently getValueFromKey: @"icon"] stringByReplacingOccurrencesOfString:@"-" withString:@"_"]];
        
    dataSource = [@[] mutableCopy];

    titles = [@[] mutableCopy];

   _chartView.xAxis.labelPosition = XAxisLabelPositionBottom;
       

    _chartView.xAxis.valueFormatter = [[DateValueFormatter alloc] initForChart:_chartView];
    
       _chartView.leftAxis.enabled = NO;
       
    _chartView.leftAxis.axisMaximum =  [[self getValue:@"deg"] isEqualToString:@"0"] ? 100 : 212;

    _chartView.xAxis.avoidFirstLastClippingEnabled = YES;
    
       
       _chartView.delegate = self;
       
       _chartView.chartDescription.enabled = NO;
       
       _chartView.dragEnabled = NO;
    
       [_chartView setScaleEnabled:NO];
        
       _chartView.pinchZoomEnabled = YES;
//
//    _chartView.scaleXEnabled = NO;
//
//    _chartView.scaleYEnabled = YES;

//    pinchZoomEnabled, scaleXEnabled, scaleYEnabled
    
    
    
    _chartView.xAxis.labelTextColor = [UIColor whiteColor];
    
       _chartView.drawGridBackgroundEnabled = NO;

    _chartView.xAxis.granularity = 1;
    
       // x-axis limit line
       ChartLimitLine *llXAxis = [[ChartLimitLine alloc] initWithLimit:10.0 label:@"Index 10"];
       llXAxis.lineWidth = 4.0;
       llXAxis.lineDashLengths = @[@(10.f), @(10.f), @(0.f)];
       llXAxis.labelPosition = ChartLimitLabelPositionBottomRight;
       llXAxis.valueFont = [UIFont systemFontOfSize:10.f];
           
       _chartView.xAxis.gridLineDashLengths = @[@10.0, @10.0];
       _chartView.xAxis.gridLineDashPhase = 0.f;
       
       ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:150.0 label:@"Upper Limit"];
       ll1.lineWidth = 4.0;
       ll1.lineDashLengths = @[@5.f, @5.f];
       ll1.labelPosition = ChartLimitLabelPositionTopRight;
       ll1.valueFont = [UIFont systemFontOfSize:10.0];
       
       ChartLimitLine *ll2 = [[ChartLimitLine alloc] initWithLimit:-30.0 label:@"Lower Limit"];
       ll2.lineWidth = 4.0;
       ll2.lineDashLengths = @[@5.f, @5.f];
       ll2.labelPosition = ChartLimitLabelPositionBottomRight;
       ll2.valueFont = [UIFont systemFontOfSize:10.0];
       
       ChartYAxis *leftAxis = _chartView.leftAxis;
       [leftAxis removeAllLimitLines];
       [leftAxis addLimitLine:ll1];
       [leftAxis addLimitLine:ll2];
       leftAxis.axisMaximum = 200.0;
       leftAxis.axisMinimum = -50.0;
       leftAxis.gridLineDashLengths = @[@5.f, @5.f];
       leftAxis.drawZeroLineEnabled = NO;
       leftAxis.drawLimitLinesBehindDataEnabled = YES;
       
       _chartView.rightAxis.enabled = NO;
       
       self.chartView.xAxis.drawGridLinesEnabled = NO;
       self.chartView.leftAxis.drawLabelsEnabled = NO;
       self.chartView.legend.enabled = NO;
    
    _chartView.dragEnabled = YES;
//     [_chartView setScaleEnabled:YES];
    _chartView.scaleYEnabled = NO;
    _chartView.scaleXEnabled = YES;
     _chartView.pinchZoomEnabled = YES;
     _chartView.drawGridBackgroundEnabled = NO;
    
//    [_chartView ];
    
    if (data.allKeys.count != 0) {
        [self updateChartData];
    }
}

- (void)updateChartData
{
    _chartView.leftAxis.axisMaximum =  [[self getValue:@"deg"] isEqualToString:@"0"] ? 100 : 212;

    [self setDataCount];
}

- (NSDate*)date:(NSString*)dateString
{
    NSString *dateStr = dateString;

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm dd/MM/yyyy"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    return date;
    
    NSLog(@"%@", dateString);

    NSLog(@"%@", [dateString dateWithFormat:@"HH:mm dd/MM/yyyy"]);
    return [dateString dateWithFormat:@"HH:mm dd/MM/yyyy"];
}

- (void)setDataCount
{
    NSMutableArray *values = [[NSMutableArray alloc] init];
        
    NSMutableArray *temp = [[NSMutableArray alloc] init];

    for (int i = 0; i < 24; i++)
    {
        NSTimeInterval now = [[self date:data[@"hourly"][i][@"time"]] timeIntervalSince1970];
                        
//        NSLog(@"--%@", data[@"hourly"][i][@"time"]);
        NSDateFormatter * dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"HH:mm dd/MM/yyyy"];
        NSDate *date = [dateFormatter dateFromString:data[@"hourly"][i][@"time"]];
//        NSLog(@"date=%@",date);
        NSTimeInterval interval  = [date timeIntervalSince1970];
//        NSLog(@"interval=%f",interval);
//        NSDate *methodStart = [NSDate dateWithTimeIntervalSince1970:interval];
//        NSLog(@"result: %@", [dateFormatter stringFromDate:methodStart]);
//
//        NSLog(@"%f", interval);
        
        double val = [[self returnValueH:data[@"hourly"][i]] doubleValue];
        
        [values addObject:[[ChartDataEntry alloc] initWithX:i y:val icon:[UIImage imageNamed:@"trans"]]];
        
        [temp addObject: data[@"hourly"][i]];
    }
    
    _chartView.accessibilityLabel = [temp bv_jsonStringWithPrettyPrint:YES];
    
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        [set1 replaceEntries: values];
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithEntries:values label:@""];
        set1.valueColors = @[[UIColor whiteColor]];
        set1.highlightColor = [UIColor clearColor];
        set1.drawIconsEnabled = NO;
        set1.lineWidth = 1.0;
        set1.circleRadius = 3.0;
        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        set1.formLineDashLengths = @[@5.f, @2.5f];
        set1.formLineWidth = 1.0;
        set1.formSize = 15.0;
        
        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#00A34B"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#FFFFFF"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set1.fillAlpha = 1.f;
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set1.drawFilledEnabled = YES;
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        _chartView.data = data;
        
        
         for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawCirclesEnabled = NO;
            set.mode = LineChartModeCubicBezier;
        }
            
        NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
           pFormatter.numberStyle = kCFNumberFormatterPercentStyle;
           pFormatter.maximumFractionDigits = 100;
           pFormatter.multiplier = @1;
        pFormatter.percentSymbol = @"°";
        
        [set1 setValueFormatter: [[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];

        
        [_chartView setNeedsDisplay];
    }
}

#pragma mark - ChartViewDelegate

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
