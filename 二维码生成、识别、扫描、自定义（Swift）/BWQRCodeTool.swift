//
//  BWQRCodeTool.swift
//  01-二维码
//
//  Created by mortal on 16/11/8.
//  Copyright © 2016年 mortal. All rights reserved.
//

import UIKit
import AVFoundation

class BWQRCodeTool: NSObject {
    
    
    /// 生成二维码
    ///
    /// - Parameters:
    ///   - contentStr: 二维码的内容
    ///   - bigImageWH: 需要生成的二维码尺寸
    ///   - smallImage: 自定义的小图标
    ///   - smallImageWH: 自定义的小图标的尺寸
    /// - Returns: 自定义的二维码
    class func gerneratorQRCode(contentStr: String, bigImageWH: CGFloat, smallImage: UIImage, smallImageWH: CGFloat) -> UIImage? {
        // 1.创建一个二维码滤镜
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        // 1.1恢复默认值
        filter.setDefaults()
        
        // 2.设置内容 必须以KVC的方式设置
        // 二维码的值必须是 NSData
        let data = contentStr.data(using: .utf8)
        filter.setValue(data, forKeyPath: "inputMessage")
        
        // 2.1设置二维码的级别(纠错率) 级别越高，信息越丰富
        // key : inputCorrectionLevel
        // value : L: 7%   M(默认): 15%   Q: 25%   H: 30%
        filter.setValue("H", forKeyPath: "inputCorrectionLevel")
        
        // 3.从二维码滤镜中获取模糊的二维码
        guard let outputImage = filter.outputImage else { return nil }
        
        // 4.展示图片(生成的二维码默认大小为23*23)
        guard let imageUI = createClearImage(outputImage, sizeWH: bigImageWH) else { return nil }
        
        // 5.设置二维码颜色(必须放在清晰的二维码之后,否则无效)
        let imageCI = CIImage(image: imageUI)
        let colorFiler = CIFilter(name: "CIFalseColor")
        colorFiler?.setDefaults()
        // 5.1设置图片
        colorFiler?.setValue(imageCI, forKeyPath: "inputImage")
        // 5.2设置二维码颜色
        colorFiler?.setValue(CIColor.init(color: UIColor.white), forKeyPath: "inputColor0")
        // 5.3设置二维码背景颜色
        colorFiler?.setValue(CIColor.init(color: UIColor.black), forKeyPath: "inputColor1")
        // 5.4取出带颜色的二维码
        guard let colorOutputImage = colorFiler?.outputImage else { return nil }
        
        // 6.生成自定义的二维码
        let image  = UIImage(ciImage: colorOutputImage)
        return createCustomImage(bigImage: image, customImage: smallImage, customImageWH: smallImageWH)
    }

    
    /// 识别二维码，绘制边框
    ///
    /// - Parameter sourceImage: 源图片
    /// - Returns: 绘制出边框的二维码图片
    class func detectorQRCode(sourceImage : UIImage) -> UIImage? {
        //0.创建上下文
        let context = CIContext()
        
        //1.创建二维码的探测器
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh]) else { return nil }
        
        //2.探测图片
        guard let sourceImageCI = CIImage(image: sourceImage) else { return nil }
        guard let features = detector.features(in: sourceImageCI) as? [CIQRCodeFeature] else { return nil }
        
        //3.绘制识别的二维码边框
        return drawQRCodeBorder(features: features, sourceImage: sourceImage)
    }
    
    
    //扫描二维码
    // 单例对象
    static let shareInstance = BWQRCodeTool()
    ///懒加载
    /// 创建会话(添加输入和输出对象)
    fileprivate lazy var session : AVCaptureSession? = {
        // 1.获取摄像头设备
        guard let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {return nil}
        
        // 2.将摄像头作为输入对象
        var input : AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
            
        } catch {
            print(error)
            return nil
        }
        
        // 3.创建输出对象
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // 4.创建捕捉会话
        let session = AVCaptureSession()
        
        // 5.添加输入对象和输出对象到会话中
        if session.canAddInput(input!) && session.canAddOutput(output)  {
            session.addInput(input!)
            session.addOutput(output)
            
            // 注意:如果要扫描任何码制，必须制定扫描的类型
            // 必须在添加了输出对象之后再设置
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        }
        return session
    }()
    
    /// 创建预览图层
    fileprivate lazy var preViewLayer : AVCaptureVideoPreviewLayer? = {
        guard let preViewLayer = AVCaptureVideoPreviewLayer(session: self.session) else {return nil}
        return preViewLayer
    }()
    
    // 定义闭包
    typealias ScanResultBlock = (_ resultStr : String) -> ()
    var scanResultBlock : ScanResultBlock?
    
    /// 扫描二维码
    ///
    /// - Parameters:
    ///   - scanView: 扫描图层区域
    ///   - preView: 预览图层区域
    ///   - scanResultBlock: 扫描结果
    func scanQRCode(scanView : UIView, preView : UIView, scanResultBlock : @escaping ScanResultBlock) -> () {
        
        // 0.记录block
        self.scanResultBlock = scanResultBlock
        
        // 1.判断会话和预览图层是否有值
        if session == nil || preViewLayer == nil {
            return
        }
        
        if let subLayers = preView.layer.sublayers {
            let isHavePreViewLayer = subLayers.contains(preViewLayer!)
            if !isHavePreViewLayer {
                preView.layer.insertSublayer(preViewLayer!, at: 0)
                preViewLayer?.frame = preView.bounds
                
                guard let output = session!.outputs.first as? AVCaptureMetadataOutput  else {
                    return
                }
                
                // 设置扫描区域(内部会以坐标原点在右上角设置)
                let x = scanView.frame.origin.y / preView.bounds.height
                let y = scanView.frame.origin.x / preView.bounds.width
                let w = scanView.bounds.height / preView.bounds.height
                let h = scanView.bounds.width / preView.bounds.width
                output.rectOfInterest = CGRect(x: x, y: y, width: w, height: h)
            }
        }

        // 2.判断是否正在扫描
        if session!.isRunning {
            return
        }
        
        // 3.开始扫描
        session!.startRunning()
    }
    
    //控制手机手电筒
    class func turnLight(isOpen: Bool) {
        // 1.获取摄像头
        guard let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {return}
        
        // 2.获取设备的控制权
        do {
            try captureDevice.lockForConfiguration()
        } catch {
            print(error)
            return
        }
        
        if isOpen { // 打开手电筒
            captureDevice.torchMode = .on
            
        } else { // 关闭手电筒
            captureDevice.torchMode = .off
        }
        
        // 3.释放设备的控制权
        captureDevice.unlockForConfiguration()
    }
}

// MARK: - 生成二维码
extension BWQRCodeTool {
    
    /// 将模糊的二维码图片转为清晰的
    ///
    /// - parameter image: 模糊的二维码图片
    /// - parameter sizeWH: 需要生成的二维码尺寸
    ///
    /// - returns: 清晰的二维码图片
    fileprivate class func createClearImage(_ image : CIImage, sizeWH : CGFloat ) -> UIImage? {
        
        // 1.调整小数像素到整数像素,将origin下调(12.*->12),size上调(11.*->12)
        let extent = image.extent.integral
        
        // 2.将指定的大小与宽度和高度进行对比,获取最小的比值
        let scale = min(sizeWH / extent.width, sizeWH / extent.height)
        
        // 3.将图片放大到指定比例
        let width = extent.width * scale
        let height = extent.height * scale
        // 3.1创建依赖于设备的灰度颜色通道
        let cs = CGColorSpaceCreateDeviceGray();
        // 3.2创建位图上下文
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)
        
        // 4.创建上下文
        let context = CIContext(options: nil)
        
        // 5.将CIImage转为CGImage
        let bitmapImage = context.createCGImage(image, from: extent)
        
        // 6.设置上下文渲染等级
        bitmapRef!.interpolationQuality = .none
        
        // 7.改变上下文的缩放
        bitmapRef?.scaleBy(x: scale, y: scale)
        
        // 8.绘制一张图片在位图上下文中
        bitmapRef?.draw(bitmapImage!, in: extent)
        
        // 9.从位图上下文中取出图片(CGImage)
        guard let scaledImage = bitmapRef?.makeImage() else {return nil}
        
        // 10.将CGImage转为UIImage并返回
        return UIImage(cgImage: scaledImage)
    }
    
    /// 自定义二维码
    ///
    /// - Parameters:
    ///   - bigImage: 二维码图片
    ///   - customImage:  自定义添加的小图片
    ///   - smallImageWH: 小图片尺寸
    /// - Returns: 生成新的二维码图片
    fileprivate class func createCustomImage(bigImage : UIImage, customImage : UIImage, customImageWH : CGFloat) -> UIImage? {
        
        // 0.大图片的尺寸
        let bigImageSize = bigImage.size
        
        // 1.创建图形上下文
        UIGraphicsBeginImageContext(bigImageSize)
        
        // 2.绘制大图片
        bigImage.draw(in: CGRect(x: 0, y: 0, width: bigImageSize.width, height: bigImageSize.height))
        
        // 3.绘制小图片
        customImage.draw(in: CGRect(x: (bigImageSize.width - customImageWH) * 0.5, y: (bigImageSize.height - customImageWH) * 0.5, width: customImageWH, height: customImageWH))
        
        // 4.从图形上下文中取出图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5.关闭图形上下文
        UIGraphicsEndImageContext()
        
        // 6.返回图片
        return image
        
    }
}


// MARK: - 识别二维码
extension BWQRCodeTool {
    
    /// 绘制探测到的二维码边框
    ///
    ///   - features: 探测到的二维码图片
    ///   - sourceImage: 源图片
    /// - Return: 绘制的边框图片
    fileprivate class func drawQRCodeBorder(features : [CIQRCodeFeature], sourceImage : UIImage) -> UIImage? {
        // 0.源图片大小
        let sourceImageSize = sourceImage.size
        
        // 1.创建图形上下文
        UIGraphicsBeginImageContext(sourceImageSize)
        
        // 2.绘制边框
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: sourceImageSize.width, height: sourceImageSize.height))
        
        // 3.绘制边框(bonds的坐标原点在左下角)
        for feature in features {
            let bounds = feature.bounds
            let newBounds = CGRect(x: bounds.origin.x, y: sourceImageSize.height - bounds.origin.y - bounds.height, width: bounds.width, height: bounds.height)
            let path = UIBezierPath(rect: newBounds)
            
            UIColor.red.set()
            path.lineWidth = 3
            path.stroke()
        }
        // 4.取出边框
        let borderImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5.关闭图形上下文
        UIGraphicsEndImageContext()
        
        // 6.返回边框
        return borderImage
    }
}


// MARK: - 扫描二维码
extension BWQRCodeTool : AVCaptureMetadataOutputObjectsDelegate{
    
    /// 当扫描到结果的时候就会来到该方法(任何码制都会来到该方法)
    ///
    /// - Parameters:
    ///   - captureOutput: 输出
    ///   - metadataObjects: 扫描到码制数组
    ///   - connection: 链接
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        removeQRCodeBorder()
        
        // 扫描的类型AVMetadataMachineReadableCodeObject(二维码类型)
        // 这里只处理二维码
        // 当移除屏幕的时候,系统会额外调用一次该方法,内容是空
        guard let result = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {return}
        scanResultBlock!(result.stringValue)
        drawQRCodeBorder(result: result)
    }
    
    /// 给二维码绘制边框
    ///
    /// - Parameter result: 扫描到的二维码结果
    private func drawQRCodeBorder(result : AVMetadataMachineReadableCodeObject) {
        
        // result.corners:是数据坐标,必须使用预览图层将坐标转为位(上下文)的坐标
        guard let resultObj = preViewLayer?.transformedMetadataObject(for: result) as? AVMetadataMachineReadableCodeObject else {return}

        // 绘制边框
        let path = UIBezierPath()
        var index = 0
        for corner in resultObj.corners {
            
            let dictCF = corner as! CFDictionary
            let point = CGPoint(dictionaryRepresentation: dictCF)!
            
            // 开始绘制
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
            
            index = index + 1
        }
        
        // 关闭路径
        path.close()
        
        // 创建形状图层
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        preViewLayer?.addSublayer(shapeLayer)
    }
    
    /// 移除边框
    private func removeQRCodeBorder() {
        
        if let layers = preViewLayer?.sublayers {
            for layer in layers {
                let shapeLayer = layer as? CAShapeLayer
                if shapeLayer != nil {
                    shapeLayer?.removeFromSuperlayer()
                }
            }
        }
        
    }
}
