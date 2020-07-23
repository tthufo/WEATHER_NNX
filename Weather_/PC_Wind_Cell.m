//
//  PC_Wind_Cell.m
//  HearThis
//
//  Created by Thanh Hai Tran on 5/16/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

#import "PC_Wind_Cell.h"

@import Charts;

#import "DayAxisValueFormatter.h"

#import "DateValueFormatter.h"

#include <math.h>

@interface PC_Wind_Cell ()<ChartViewDelegate>
{
    IBOutlet UIButton * daily, * weekLy;
    
    IBOutlet UILabel * speed, * bearing;
        
    BOOL day;
}

@property (nonatomic, strong) IBOutlet BarChartView *chartView;

@end

@implementation PC_Wind_Cell

@synthesize data;

- (void)awakeFromNib {
    [super awakeFromNib];

    [self optional];
    
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//
//               [self updateChartData];
//
//        });
}

- (IBAction)didPressOption:(UIButton*)button {
    day = button.tag != 11;
    [self optional];
    [self updateChartData];
}

- (void)optional {
    [daily withBorder:@{@"Bcolor": [self color: @"#5530F5"], @"Bground": [self color: !day ? @"#5530F5" : @"#FFFFFF"], @"Bwidth": !day ? @"1" : @"0", @"Bcorner": @"16"}];
    [weekLy withBorder:@{@"Bcolor": [self color: @"#5530F5"], @"Bground": [self color: !day ? @"#FFFFFF" : @"5530F5"], @"Bwidth": !day ? @"0" : @"1", @"Bcorner": @"16"}];
    
    [daily setTitleColor:[self color: !day ? @"#FFFFFF" : @"#5530F5"] forState:UIControlStateNormal];
    [weekLy setTitleColor:[self color: !day ? @"#5530F5" : @"#FFFFFF"] forState:UIControlStateNormal];
}

- (UIColor*)color:(NSString*)color {
    return [AVHexColor colorWithHexString:color];
}

- (NSString*)returnValue:(NSString*)key {
            
    NSDictionary * currently = data[@"currently"];

    double tempo = [[self getValue:@"deg"] isEqualToString:@"0"] ? [[currently getValueFromKey:key] doubleValue] : ([[currently getValueFromKey:key] doubleValue] * 9/5) + 32;

    NSString * value = [NSString stringWithFormat:@"%.f", ceil(tempo)];
    
    return value;
}

- (NSString*)returnValueH:(NSDictionary*)currently {
                
    NSString * key = @"windSpeed";

    double tempo = [[currently getValueFromKey:key] floatValue] * 1.609344;
    
    NSString * value = [NSString stringWithFormat:@"%.f", ceil(tempo)];
    
    return value;
}

- (void)prepareForReuse {
    [super prepareForReuse];
        
    NSDictionary * currently = data[@"currently"];

    speed.text = [self returnValueH:currently];

    bearing.text = [currently getValueFromKey:@"windBearing"];

    [self setupBarLineChartView:_chartView];

    _chartView.delegate = self;
   
   _chartView.drawBarShadowEnabled = NO;
   _chartView.drawValueAboveBarEnabled = YES;
   
    _chartView.xAxis.labelRotationAngle = 45;

//   _chartView.maxVisibleCount = 60;
   
//    _chartView.xAxis.labelTextColor = [UIColor whiteColor];

   ChartXAxis *xAxis = _chartView.xAxis;
   xAxis.labelPosition = XAxisLabelPositionBottom;
   xAxis.labelFont = [UIFont systemFontOfSize:10.f];
   xAxis.drawGridLinesEnabled = NO;
   xAxis.granularity = 1.0; // only intervals of 1 day
   xAxis.valueFormatter = [[DayAxisValueFormatter alloc] initForChart:_chartView];
   
//   NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
//   leftAxisFormatter.minimumFractionDigits = 0;
//   leftAxisFormatter.maximumFractionDigits = 1;
//   leftAxisFormatter.negativeSuffix = @" $";
//   leftAxisFormatter.positiveSuffix = @" $";
   
   ChartYAxis *leftAxis = _chartView.leftAxis;
   leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
   leftAxis.labelCount = 8;
//   leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
   leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
   leftAxis.spaceTop = 0.15;
   leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
   
   ChartYAxis *rightAxis = _chartView.rightAxis;
   rightAxis.enabled = YES;
   rightAxis.drawGridLinesEnabled = NO;
   rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
   rightAxis.labelCount = 8;
   rightAxis.valueFormatter = leftAxis.valueFormatter;
   rightAxis.spaceTop = 0.15;
   rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
   
   ChartLegend *l = _chartView.legend;
   l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
   l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
   l.orientation = ChartLegendOrientationHorizontal;
   l.drawInside = NO;
   l.form = ChartLegendFormSquare;
   l.formSize = 9.0;
   l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
   l.xEntrySpace = 4.0;
    
    _chartView.rightAxis.enabled = NO;
          
          self.chartView.xAxis.drawGridLinesEnabled = NO;
          self.chartView.leftAxis.drawLabelsEnabled = NO;
          self.chartView.legend.enabled = NO;
    
    _chartView.leftAxis.enabled = NO;
          
          
          _chartView.delegate = self;
          
          _chartView.chartDescription.enabled = NO;
          
          _chartView.dragEnabled = YES;
          [_chartView setScaleEnabled:YES];
          _chartView.pinchZoomEnabled = YES;
          _chartView.drawGridBackgroundEnabled = NO;

//    [self updateChartData];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
       dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

              [self updateChartData];

       });
}

- (void)updateChartData
{
    [self setDataCount];
}

- (NSDate*)date:(NSString*)dateString
{
    return [dateString dateWithFormat:!day ? @"dd/MM/yyyy" : @"HH:mm dd/MM/yyyy"];
}

- (NSString*)returnVal:(NSString*)val {
    return [NSString stringWithFormat:@"%.01f", [val floatValue]];
}

- (NSString*)returnTime:(NSString*)val {
    if (!day) {
        return [[val componentsSeparatedByString:@" "] firstObject];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:[NSDate date]];

    return [[[val componentsSeparatedByString:@" "] firstObject] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@", year] withString:@""];
}

- (void)setDataCount
{
    NSMutableArray *values = [[NSMutableArray alloc] init];

    for (int i = 0; i < (!day ? 24 : ((NSArray*)data[@"daily"]).count) ; i++)
    {
        double val = [[self returnValueH:data[!day ? @"hourly" : @"daily"][i]] doubleValue];
        [values addObject:[[BarChartDataEntry alloc] initWithX:i y:val icon: [UIImage imageNamed:@"trans"]]];
    }
    
    
    
    _chartView.accessibilityLabel = [(NSArray*)data[!day ? @"hourly" : @"daily"] bv_jsonStringWithPrettyPrint:YES];
    
    BarChartDataSet *set1 = nil;
      if (_chartView.data.dataSetCount > 0)
      {
          set1 = (BarChartDataSet *)_chartView.data.dataSets[0];
          [set1 replaceEntries: values];
          [_chartView.data notifyDataChanged];
          [_chartView notifyDataSetChanged];
      }
      else
      {
          set1 = [[BarChartDataSet alloc] initWithEntries:values label:@""];
          [set1 setColors: @[[AVHexColor colorWithHexString:@"#5530F5"]]];
          set1.drawIconsEnabled = NO;

          NSMutableArray *dataSets = [[NSMutableArray alloc] init];
          [dataSets addObject:set1];
          
          BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
          [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
          
          data.barWidth = 0.9f;
          
          [_chartView.data notifyDataChanged];
          [_chartView notifyDataSetChanged];
          
          NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
             pFormatter.numberStyle = kCFNumberFormatterPercentStyle;
             pFormatter.maximumFractionDigits = 100;
             pFormatter.multiplier = @1;
          pFormatter.percentSymbol = @"";
          
          [set1 setValueFormatter: [[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
          
          _chartView.data = data;
      }
}

#pragma mark - ChartViewDelegate

- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView
{
    chartView.chartDescription.enabled = NO;
    
    chartView.drawGridBackgroundEnabled = NO;
    
    chartView.dragEnabled = NO;
    [chartView setScaleEnabled:YES];
    chartView.pinchZoomEnabled = NO;
        
    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    
    chartView.rightAxis.enabled = NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
