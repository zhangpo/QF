//
//  SWPieChartLayer.h
//  PieChart
//
//  Created by Wu Stan on 12-1-4.
//  Copyright (c) 2012年 CheersDigi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kIndicatorAngle     M_PI/2

@protocol SWPieChartLayerDelegate

- (void)didRunIntoRegion:(NSUInteger)index;

@end

@interface SWPieChartLayer : CALayer{
    float angle;
    NSUInteger currentRegion;
    BOOL canShowLabel;
    NSArray *aryColors,*aryValues,*aryInfo;
    float radius;
    

    uint64_t lastKick;
    
    id<SWPieChartLayerDelegate> __weak pieDelegate;
}
@property (nonatomic,weak) id<SWPieChartLayerDelegate> pieDelegate;
@property (nonatomic,strong) NSArray *aryColors,*aryValues,*aryInfo;
@property float radius;


- (id)initWithFrame:(CGRect)frame colors:(NSArray *)colors values:(NSArray *)values;
- (void)rotate:(float)angleToRotate;
- (void)rotate:(float)angleToRotate animated:(BOOL)animated;
- (void)inertiaRotate:(float)angleToRotate;
- (void)adjustAngle;
- (void)didRunIntoRegion:(NSUInteger)index;

- (void)hideLabels;
- (void)showLabels;

- (NSUInteger)currentRegion;

@end
