//
//  HSScanViewController.m
//  HSDoctor
//
//  Created by lbw on 2016/9/26.
//  Copyright © 2016年 mortal. All rights reserved.
//

#import "HSScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HSKit.h"

@interface HSScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureDeviceInput * input;
@property (nonatomic, strong) AVCaptureMetadataOutput * output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * scanView;

@end

@implementation HSScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setupScan];
    self.view.backgroundColor = [UIColor hs_colorWithHex:0x000000 alpha:0.7];
    
    [self setupCoverLayer];
    
}

- (void)setupScan {
    NSError *error;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:&error];
    
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
        _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    }
    
    _scanView = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    _scanView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    _scanView.bounds = CGRectMake(0, 0, 300, 300);
    _scanView.position = self.view.center;
    
    [self.view.layer addSublayer:_scanView];
    
    [_session startRunning];

}

- (void)setupCoverLayer {
    
    
    CGSize scanSize = CGSizeMake(300, 300);
    CGFloat kWidth = self.view.bounds.size.width,
    kHeight = self.view.bounds.size.height,
    hornLength = 20,
    hornWidth = 4,
    rectX = (kWidth - scanSize.width) * 0.5,
    rectY = (kHeight - scanSize.height) * 0.5;
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectMake( rectX, rectY, scanSize.width, scanSize.height)];
    CAShapeLayer *rectLayer = [CAShapeLayer layer];
    
    rectLayer.path = rectPath.CGPath;
    rectLayer.lineWidth = 1;
    rectLayer.strokeColor = [UIColor whiteColor].CGColor;
    rectLayer.fillColor = nil;
    
    [self.view.layer addSublayer:rectLayer];
    
    //左上角
    CAShapeLayer *leftTopLayer = [CAShapeLayer layer];
    UIBezierPath *leftTopPath = [UIBezierPath bezierPath];
    [leftTopPath moveToPoint:CGPointZero];
    [leftTopPath addLineToPoint:CGPointMake(0, -hornLength)];
    [leftTopPath addLineToPoint:CGPointMake(hornLength, -hornLength)];
    
    leftTopLayer.lineWidth = hornWidth;
    leftTopLayer.path = leftTopPath.CGPath;
    leftTopLayer.strokeColor = [UIColor hs_colorWithHex:0x60a0ff].CGColor;
    leftTopLayer.fillColor = nil;
    
    leftTopLayer.bounds = CGRectMake(0, 0, hornLength, hornLength);
    leftTopLayer.anchorPoint = CGPointZero;
    leftTopLayer.position = CGPointMake(rectX - 1, rectY - 1 + hornLength);
    
    [self.view.layer addSublayer:leftTopLayer];
    
    //右上角
    CAShapeLayer *rightTopLayer = [CAShapeLayer layer];
    UIBezierPath *rightTopPath = [UIBezierPath bezierPath];
    [rightTopPath moveToPoint:CGPointZero];
    [rightTopPath addLineToPoint:CGPointMake(0, -hornLength)];
    [rightTopPath addLineToPoint:CGPointMake(-hornLength, -hornLength)];
    
    rightTopLayer.lineWidth = hornWidth;
    rightTopLayer.path = rightTopPath.CGPath;
    rightTopLayer.strokeColor = [UIColor hs_colorWithHex:0x60a0ff].CGColor;
    rightTopLayer.fillColor = nil;
    
    rightTopLayer.bounds = CGRectMake(0, 0, hornLength, hornLength);
    rightTopLayer.anchorPoint = CGPointZero;
    rightTopLayer.position = CGPointMake(rectX + 1 + scanSize.width, rectY - 1 + hornLength);
    
    [self.view.layer addSublayer:rightTopLayer];
    
    //左下角
    CAShapeLayer *leftBottomLayer = [CAShapeLayer layer];
    UIBezierPath *leftBottomPath = [UIBezierPath bezierPath];
    [leftBottomPath moveToPoint:CGPointZero];
    [leftBottomPath addLineToPoint:CGPointMake(0, hornLength)];
    [leftBottomPath addLineToPoint:CGPointMake(hornLength, hornLength)];
    
    leftBottomLayer.lineWidth = hornWidth;
    leftBottomLayer.path = leftBottomPath.CGPath;
    leftBottomLayer.strokeColor = [UIColor hs_colorWithHex:0x60a0ff].CGColor;
    leftBottomLayer.fillColor = nil;
    
    leftBottomLayer.bounds = CGRectMake(0, 0, hornLength, hornLength);
    leftBottomLayer.position = CGPointMake((kWidth - scanSize.width) * 0.5, (kHeight + scanSize.height) * 0.5);
    leftBottomLayer.bounds = CGRectMake(0, 0, hornLength, hornLength);
    leftBottomLayer.anchorPoint = CGPointZero;
    leftBottomLayer.position = CGPointMake(rectX - 1, rectY + 1 + scanSize.height - hornLength);
    
    [self.view.layer addSublayer:leftBottomLayer];
    
    //右下角
    CAShapeLayer *rightBottomLayer = [CAShapeLayer layer];
    UIBezierPath *rightBottomPath = [UIBezierPath bezierPath];
    [rightBottomPath moveToPoint:CGPointZero];
    [rightBottomPath addLineToPoint:CGPointMake(0, hornLength)];
    [rightBottomPath addLineToPoint:CGPointMake(-hornLength, hornLength)];
    
    rightBottomLayer.lineWidth = hornWidth;
    rightBottomLayer.path = rightBottomPath.CGPath;
    rightBottomLayer.strokeColor = [UIColor hs_colorWithHex:0x60a0ff].CGColor;
    rightBottomLayer.fillColor = nil;
    
    
    rightBottomLayer.bounds = CGRectMake(0, 0, hornLength, hornLength);
    rightBottomLayer.position = CGPointMake((kWidth + scanSize.width) * 0.5, (kHeight + scanSize.height) * 0.5);
    rightBottomLayer.bounds = CGRectMake(0, 0, hornLength, hornLength);
    rightBottomLayer.anchorPoint = CGPointZero;
    rightBottomLayer.position = CGPointMake(rectX + 1 + scanSize.width, rectY + 1 + scanSize.height - hornLength);
    
    [self.view.layer addSublayer:rightBottomLayer];
    
    
//    CALayer *lineLayer = [CALayer layer];
//    lineLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"line"].CGImage);
//    lineLayer.contentsGravity = kCAGravityResizeAspectFill;
//    lineLayer.bounds = CGRectMake(0, 0, scanSize.width - 40, 3);
//    lineLayer.position = CGPointMake(self.view.center.x, rectY + 20);
//    
//    [self.view.layer addSublayer:lineLayer];
//    
//    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
//    basicAnimation.duration = 2;
//    basicAnimation.repeatCount = 20;
//    basicAnimation.autoreverses = YES;
//    
//    basicAnimation.toValue = @(rectY + scanSize.height - 20);
//    [lineLayer addAnimation:basicAnimation forKey:nil];
    
}

//MARK:~~~~AVCaptureMetadataOutputObjectsDelegate~~~~
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    AVMetadataMachineReadableCodeObject *obj = metadataObjects.lastObject;
    [_session stopRunning];
    
    UIAlertController *alert = [UIAlertController hs_alertControllerWithTitle:@"打开连接?" message:obj.stringValue];
    [alert hs_addDefaultActionWithTitle:@"确定" handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alert hs_addCancelActionWithTitle:@"取消" handler:^(UIAlertAction *action) {
        
        NSLog(@"%@",obj.stringValue);
        [_session startRunning];
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}



@end
