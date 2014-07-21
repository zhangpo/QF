//
//  SWPieChart.m
//  PieChart
//
//  Created by Wu Stan on 12-1-4.
//  Copyright (c) 2012年 CheersDigi. All rights reserved.
//

#import "SWPieChart.h"
#import "CVPieUtil.h"
#import "QuartzCore/CADisplayLink.h"

#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f)
#define CC_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f)

@implementation SWPieChart
@synthesize aryColors,aryValues;
@synthesize delegate;

- (void)dealloc{
    [timer invalidate];

    [super dealloc];
}

- (CGPoint) cgpSub:(CGPoint)v1: (CGPoint)v2
{
    CGPoint point;
    point.x = v1.x - v2.x;
    point.y = v1.y - v2.y;
    
    return point; 
}
- (float) toAngle:(CGPoint) v
{
    return atan2f(v.x, v.y);
}

- (void)update
{
    if(updateEnable)
    {
        if(fabs(angle)>1)
        {
            [pieChartLayer rotate:CC_DEGREES_TO_RADIANS(angle)];
            angle = 0.99*angle;
        }
        else 
        {
            angle = 0;
            updateEnable = NO;
            [pieChartLayer showLabels];
            [pieChartLayer adjustAngle];
        }  
    }
    
}

- (id)initWithFrame:(CGRect)frame colors:(NSArray *)colors values:(NSArray *)values{
    self = [super initWithFrame:frame];
    if (self) {
        self.exclusiveTouch = YES;
        

        updateEnable = NO;
        angle = 0;
        self.backgroundColor = [UIColor clearColor];
        
        double total = 0;
        
        NSMutableArray *mutnewary = [NSMutableArray array];
        for (int i=0;i<[values count];i++)
            [mutnewary addObject:[[values objectAtIndex:i] objectForKey:@"Val"]];
        values = [NSArray arrayWithArray:mutnewary];
        
        for (NSNumber *num in values){
            total += [num doubleValue];
        }
        
        NSMutableArray *mutary = [NSMutableArray array];
        [mutary addObject:[NSNumber numberWithFloat:0]];
        
        float percent = 0;
        for (int i=0;i<[values count]-1;i++){
            percent += (float)([[values objectAtIndex:i] doubleValue]/total);
            [mutary addObject:[NSNumber numberWithFloat:percent]];
        }
        // Initialization code
        pieChartLayer = [[SWPieChartLayer alloc] initWithFrame:self.bounds colors:colors values:mutary];
        pieChartLayer.needsDisplayOnBoundsChange = YES;
        pieChartLayer.pieDelegate = self;
        [self.layer addSublayer:pieChartLayer];
        [pieChartLayer performSelector:@selector(addInfoLayers)];
        [pieChartLayer setNeedsDisplay];
        
        
        self.aryColors = colors;
        mutary = [NSMutableArray array];
        percent = 0;
        for (int i=0;i<[values count];i++){
            percent = (float)([[values objectAtIndex:i] doubleValue]/total);
            [mutary addObject:[NSNumber numberWithFloat:percent]];
        }
        self.aryValues = [NSArray arrayWithArray:mutary];
        
        
        


        
        
//        timer = [NSTimer timerWithTimeInterval:1.0f/60 target:self selector:@selector(update) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    

    pieChartLayer.frame = self.bounds;
    pieChartLayer.bounds = self.bounds;
    
    imgvBG.frame = self.bounds;
    imgvCover.frame = self.bounds;
        
    [pieChartLayer setNeedsDisplay];
    
    
}

- (NSUInteger)currentRegion{
    return pieChartLayer.currentRegion;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    updateEnable = NO;
    angle = 0;
    [pieChartLayer hideLabels];
    [pieChartLayer removeAllAnimations];
    UITouch *touch = [touches anyObject];
    ptPrev = [touch locationInView:self];
    prevTime = CACurrentMediaTime();
    fRotateSpeed = 0;
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [pieChartLayer hideLabels];
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint pt = [touch locationInView:self];
    
    float r = self.bounds.size.width/2;
    
    float prevAngle = getAngle(ptPrev, CGPointMake(r, r));
    float currAngle = getAngle(pt, CGPointMake(r, r));
    
    angle = prevAngle-currAngle;
    
    [pieChartLayer rotate:angle];
    
    CGFloat maxSpeed = M_PI;
    CFTimeInterval nowTime = CACurrentMediaTime();
    CFTimeInterval deltaTime = nowTime-prevTime;
    
    if (deltaTime==0)
        fRotateSpeed = angle>0?maxSpeed:-maxSpeed;
    else
        fRotateSpeed = angle/deltaTime;
    
    if (fabsf(fRotateSpeed)>maxSpeed)
        fRotateSpeed = angle>0?maxSpeed:-maxSpeed;
    
    NSLog(@"Rotate Speed:%f",fRotateSpeed);

    ptPrev = pt;
    prevTime = nowTime;
}

- (void)enableTouches{
    self.userInteractionEnabled = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    
    float a = M_PI*0.5f;
    float t = fabsf(fRotateSpeed/a);
    t = t>1?t:1;
    NSLog(@"Rotate Duration:%f",t);
    float angleToRotate = 0.5f*a*t*t;

    [pieChartLayer inertiaRotate:fRotateSpeed>0?angleToRotate:-angleToRotate];
    

}



- (void)didRunIntoRegion:(NSUInteger)index{
    [delegate pieChart:self didRunIntoRegion:index];
}

@end
