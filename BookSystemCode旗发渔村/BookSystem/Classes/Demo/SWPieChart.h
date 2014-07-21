//
//  SWPieChart.h
//  PieChart
//
//  Created by Wu Stan on 12-1-4.
//  Copyright (c) 2012年 CheersDigi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWPieChartLayer.h"
#import "CVPieUtil.h"

@class SWPieChart;

@protocol SWPieChartDelegate

- (void)pieChart:(SWPieChart *)pieChart didRunIntoRegion:(NSUInteger)index;

@end

@interface SWPieChart : UIView<SWPieChartLayerDelegate>{
    UIImageView *imgvBG,*imgvCover;
    
    SWPieChartLayer *pieChartLayer;
    float angle;
    
    NSArray *aryColors,*aryValues;
    
    BOOL updateEnable;
    NSTimer *timer;
    
    CGPoint ptPrev;
    id<SWPieChartDelegate> __weak delegate;
    CFTimeInterval prevTime;
    float fRotateSpeed;
}
@property (nonatomic,strong) NSArray *aryColors,*aryValues;
@property (nonatomic,weak) id<SWPieChartDelegate> delegate;
- (id)initWithFrame:(CGRect)frame colors:(NSArray *)colors values:(NSArray *)values;
- (float)toAngle:(CGPoint)v;
- (CGPoint) cgpSub:(CGPoint)v1: (CGPoint)v2;
- (void)update;
- (NSUInteger)currentRegion;


@end
