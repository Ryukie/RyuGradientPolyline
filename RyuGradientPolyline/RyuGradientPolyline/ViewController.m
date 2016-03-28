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
@property (nonatomic,strong) MKPolygon *polygon;//绘制多边形
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
- (IBAction)drawPolygon:(id)sender {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(23.29043, 112.81630), 500, 500);
    [_mv_mapView setRegion:region];
    
    
    CLLocationCoordinate2D points[4];//NSArry 只能存放OC对象   这里用MKPoint就可以用了
    CLLocationCoordinate2D lt = CLLocationCoordinate2DMake(23.29131,112.8155);
    CLLocationCoordinate2D rt = CLLocationCoordinate2DMake(23.29061, 112.8177);
    CLLocationCoordinate2D lb = CLLocationCoordinate2DMake(23.29014, 112.8151);
    CLLocationCoordinate2D rb = CLLocationCoordinate2DMake(23.28949, 112.8173);
    points[0] = lt;
    points[1] = rt;
    points[2] = rb;
    points[3] = lb;//需要注意顺序
    
    self.polygon = [MKPolygon polygonWithCoordinates:points count:4];
    //    [MKPolygon polygonWithPoints:<#(nonnull MKMapPoint *)#> count:<#(NSUInteger)#>]
    NSLog(@"%@",self.polygon);
    [self.mv_mapView addOverlay:_polygon level:MKOverlayLevelAboveLabels];
    //MKOverlayLevelAboveRoads = 0, // note that labels include shields and point of interest icons.
    //    MKOverlayLevelAboveLabels
}
#pragma mark - Ryukie:MapView 绘制蒙版的代理
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    UIColor* purpleColor = [UIColor colorWithRed:0.149f green:0.0f blue:0.40f alpha:0.5f];
    MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
    polygonRenderer.fillColor = purpleColor;
    return polygonRenderer;
}

@end
