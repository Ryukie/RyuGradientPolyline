//
//  ViewController.m
//  RyuGradientPolyline
//
//  Created by 王荣庆 on 16/3/28.
//  Copyright © 2016年 Ryukie. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GradientPolylineOverlay.h"
#import "GradientPolylineRenderer.h"

static int MAX_LOCATIONS = 3000;

@interface ViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>{
    //    CLLocationCoordinate2D *allLocations;
    //    float *allSpeed;
    //    int locationCount;
}
@property (weak, nonatomic) IBOutlet MKMapView *mv_mapView;
@property (nonatomic,strong) CLLocationManager *locateManager;
@property (nonatomic,strong) MKPolygon *polygon;//绘制多边形
@property (weak, nonatomic) IBOutlet UILabel *signal;
@property (weak, nonatomic) IBOutlet UILabel *state;


@property (nonatomic,strong) NSArray *allLocationArr;
@property (nonatomic,strong) NSMutableArray *tempA;

@property (nonatomic,strong) GradientPolylineOverlay *polyline;




@end

@implementation ViewController

- (CLLocationManager *)locateManager {
    if (!_locateManager) {
        _locateManager = [[CLLocationManager alloc] init];
    }
    return  _locateManager;
}
- (NSArray *)allLocationArr {
    if (!_allLocationArr) {
        _allLocationArr = [NSArray array];
    }
    return _allLocationArr;
}
- (NSMutableArray *)tempA {
    if (!_tempA) {
        _tempA = [NSMutableArray array];
    }
    return _tempA;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mv_mapView.delegate = self;//设置地图代理
    //始终获取定位
    [self.locateManager requestAlwaysAuthorization];
    self.locateManager.delegate = self;
    self.locateManager.desiredAccuracy = kCLLocationAccuracyBest;
    //定位  corelocation
    //设置定位模式
    self.mv_mapView.userTrackingMode = MKUserTrackingModeFollow;
    //设置地图显示类型
    self.mv_mapView.mapType = MKMapTypeStandard;
    
    self.signal.backgroundColor = [UIColor grayColor];
}
- (IBAction)startLocate:(id)sender {
    
}
- (IBAction)startTrack:(id)sender {
    [self.locateManager startUpdatingLocation];
}
- (IBAction)pauseTrack:(id)sender {
    [self.locateManager stopUpdatingLocation];
}
- (IBAction)endTrack:(id)sender {
    [self.locateManager stopUpdatingLocation];
    
    CLLocationCoordinate2D *points;
    float *velocity;
    points = malloc(sizeof(CLLocationCoordinate2D)*MAX_LOCATIONS);
    velocity = malloc(sizeof(float)*MAX_LOCATIONS);
    NSLog(@"%ld",self.allLocationArr.count);
    [self.allLocationArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CLLocation *location = obj;
        velocity[idx] = location.speed;
        NSLog(@"%lf",location.speed);
        points[idx] = location.coordinate;
    }];
    self.polyline = [[GradientPolylineOverlay alloc] initWithPoints:points velocity:velocity count:self.allLocationArr.count];
    [self.mv_mapView addOverlay:self.polyline];
}

- (IBAction)drawPolygon:(id)sender {

}
#pragma mark - locationManager delegate
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = (CLLocation*)locations.lastObject;
    if (location.horizontalAccuracy < 0)
    {
        self.signal.text = @"No Singal";
        self.signal.textColor = [UIColor redColor];
    }
    else if (location.horizontalAccuracy > 163)
    {
        self.signal.text = @"POOR";
        self.signal.textColor = [UIColor orangeColor];
    }
    else if (location.horizontalAccuracy > 48)
    {
        self.signal.text = @"AVERAGE";
        self.signal.textColor = [UIColor yellowColor];
    }
    else
    {
        self.signal.text = @"STRONG";
        self.signal.textColor = [UIColor greenColor];
    }
    
    NSString *str = [NSString stringWithFormat:@"%lf,%lf,%lf",location.coordinate.longitude,location.coordinate.latitude,location.speed];
    self.state.text = str;
    
    [self.tempA addObject:location];
    self.allLocationArr = self.tempA.copy;
}
#pragma mark - Ryukie:MapView 绘制蒙版的代理
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    GradientPolylineRenderer *polylineRenderer = [[GradientPolylineRenderer alloc] initWithOverlay:overlay];
    polylineRenderer.lineWidth = 8.0f;
    return polylineRenderer;
}

@end
