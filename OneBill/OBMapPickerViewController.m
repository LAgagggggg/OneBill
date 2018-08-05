//
//  OBMapPickerViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/8/5.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "OBMapPickerViewController.h"

@interface OBMapPickerViewController ()
@property (strong,nonatomic)MKMapView * mapView;
@end

@implementation OBMapPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    if (self.location) {
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.location.coordinate,2000, 2000) animated:YES];
    }
    else{
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate,2000, 2000) animated:YES];
    }
}

- (void)setUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
    UIBarButtonItem * cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClicked)];
    UIBarButtonItem * doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneBtnClicked)];
    self.navigationItem.leftBarButtonItem=cancelBtn;
    self.navigationItem.rightBarButtonItem=doneBtn;
    self.mapView=[[MKMapView alloc]initWithFrame:self.view.frame];
    self.mapView.showsUserLocation=YES;
    [self.view addSubview:self.mapView];
}

- (void)cancelBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.locationPickDoneHandler(self.location);
}

@end
