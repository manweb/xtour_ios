//
//  XTCalendarViewController.m
//  XTour
//
//  Created by Manuel Weber on 26/09/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import "XTCalendarViewController.h"

@interface XTCalendarViewController ()

@end

@implementation XTCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    _calendarWidth = width - 30;
    _calendarHeight = 1.05*(width - 30);
    
    _calendarActiveColor = [[UIColor alloc] initWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    
    _monthTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, _calendarWidth-100, 20)];
    
    _monthTitle.textAlignment = NSTextAlignmentCenter;
    
    NSArray *days = [NSArray arrayWithObjects:@"Mo",@"Di",@"Mi",@"Do",@"Fr",@"Sa",@"So", nil];
    
    float stp = 290/7;
    for (int i = 0; i < 7; i++) {
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*stp, 30, stp, 20)];
        
        dayLabel.text = [days objectAtIndex:i];
        
        dayLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:dayLabel];
        
        [dayLabel release];
    }
    
    [self.view addSubview:_monthTitle];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LoadCalendarAtIndex:(NSUInteger)index
{
    NSArray *months = [NSArray arrayWithObjects:@"Januar",@"Februar",@"März",@"April",@"Mai",@"Juni",@"Juli",@"August",@"September",@"Oktober",@"November",@"Dezember", nil];
    
    int monthInt = index % 12;
    
    if (monthInt > 11) {return;}
    
    NSUInteger year = 2015 + index/12;
    
    NSString *month = [months objectAtIndex:monthInt];
    
    _monthTitle.text = [NSString stringWithFormat:@"%@ %lu",month,(unsigned long)year];
    
    NSString *time = [NSString stringWithFormat:@"%04lu-%02d-01 00:00:01",(unsigned long)year,monthInt+1];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *monthDate = [formatter dateFromString:time];
    
    NSCalendar *c = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponent = [c components:NSWeekdayCalendarUnit fromDate:monthDate];
    
    NSInteger weekday = dateComponent.weekday - 2;
    if (weekday == -1) {weekday = 6;}
    
    NSRange daysRange = [c rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:monthDate];
    
    NSInteger numberOfDays = daysRange.length;
    
    float dayLabelwidth = _calendarWidth/7;
    float dayLabelheight = _calendarWidth/7;
    
    NSInteger daysCount = 1;
    for (int i = 0; i < 42; i++) {
        if (i < weekday) {continue;}
        if (daysCount > numberOfDays) {continue;}
        
        int column = i % 7;
        int row = i/7;
        
        float dayLabelx = column*dayLabelwidth;
        float dayLabely = row*dayLabelheight;
        
        UIView *dayLabelView = [[UIView alloc] initWithFrame:CGRectMake(dayLabelx, dayLabely+55, dayLabelwidth, dayLabelheight)];
        
        dayLabelView.backgroundColor = [UIColor clearColor];
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dayLabelwidth, dayLabelheight)];
        
        dayLabel.text = [NSString stringWithFormat:@"%02ld",(long)daysCount];
        
        dayLabel.textColor = [UIColor grayColor];
        
        dayLabel.textAlignment = NSTextAlignmentCenter;
        
        if ([month isEqualToString:@"September"] && daysCount == 19) {
            dayLabelView.backgroundColor = _calendarActiveColor;
            dayLabelView.layer.cornerRadius = dayLabelwidth/2;
            
            dayLabel.textColor = [UIColor whiteColor];
        }
        
        [dayLabelView addSubview:dayLabel];
        
        [self.view addSubview:dayLabelView];
        
        [dayLabel release];
        [dayLabelView release];
        
        daysCount++;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
