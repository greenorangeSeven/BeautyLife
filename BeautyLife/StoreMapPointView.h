//
//  StoreMapPointView.h
//  NewWorld
//
//  Created by Seven on 14-7-28.
//  Copyright (c) 2014年 Seven. All rights reserved.
//百度地图自定义描点界面
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface StoreMapPointView : UIViewController<BMKMapViewDelegate>
{
    IBOutlet BMKMapView* _mapView;
}

@property CLLocationCoordinate2D storeCoor;
@property (strong, nonatomic) NSString *storeTitle;

@end
