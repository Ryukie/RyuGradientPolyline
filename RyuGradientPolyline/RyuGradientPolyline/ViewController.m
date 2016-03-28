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


@interface ViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mv_mapView;
@property (nonatomic,strong) CLLocationManager *locateManager;

@end

@implementation ViewController
- (CLLocationManager *)locateManager {
    if (!_locateManager) {
        _locateManager = [[CLLocationManager alloc] init];
    }
    return  _locateManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mv_mapView.delegate = self;//设置地图代理
    [self startLocate:nil];
}
- (IBAction)startLocate:(id)sender {
    //始终获取定位
    [self.locateManager requestAlwaysAuthorization];
    
    //定位  corelocation
    //设置定位模式
    /*
     MKUserTrackingModeNone = 0, // the user's location is not followed
     MKUserTrackingModeFollow, // the map follows the user's location
     MKUserTrackingModeFollowWithHeading,
     */
    self.mv_mapView.userTrackingMode = MKUserTrackingModeFollow;
    //设置地图显示类型
    /*
     MKMapTypeStandard = 0,
     MKMapTypeSatellite,
     MKMapTypeHybrid,
     MKMapTypeSatelliteFlyover NS_ENUM_AVAILABLE(10_11, 9_0),
     MKMapTypeHybridFlyover NS_ENUM_AVAILABLE(10_11, 9_0),
     */
    self.mv_mapView.mapType = MKMapTypeStandard;
}

@end
