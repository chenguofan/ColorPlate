//
//  ColorPlate.swift
//  wristBand
//
//  Created by suhengxian on 2021/11/18.
//

import UIKit

protocol ColorPlateDelegate{
    func colorPlate(colorPlate:ColorPlate,choiceColor:UIColor,colorPoint:CGPoint)
}

class ColorPlate: UIView {
    //代理属性
    var colorDelegate:ColorPlateDelegate?
    
    //滑块的中心点
    var sliderCenter: CGPoint?
    
    var mainImageView:UIImageView!
    var sliderImageView:UIImageView!
    var currentHSVWithNew:HSVType?
    
    public func calculateCenterPointInView(point:CGPoint) ->UIColor {
     
        return UIColor.white
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.addSomeUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSomeUI()
    }
    
    func addSomeUI(){
        self.mainImageView = UIImageView.init(frame:CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.mainImageView.image = UIImage.init(named: "paletteColor")
        self.addSubview(self.mainImageView)
        
        self.sliderImageView = UIImageView.init(image: UIImage.init(named: "followCircle"))
        self.addSubview(self.sliderImageView)
        
        self.sliderImageView.center = CGPoint.init(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
        
    }
    
    //开始触摸或者点击
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
            
        self.calculateShowColor(touches: touches) //得到颜色
    }
    
    //滑动触摸
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        self.calculateShowColor(touches: touches)  //得到颜色
    }
    
    // 结束触摸
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.calculateShowColor(touches: touches) //得到颜色
    }
    
    private func calculateShowColor(touches:Set<UITouch>){
        for touch:UITouch in touches {
            let t:UITouch = touch
            //当在屏幕上连续拍动两下时，背景回复为白色
            let movePoint = t.location(in: self)
        
            let color = self.calculateCenterInView(point: movePoint)
            
            self.colorDelegate?.colorPlate(colorPlate:self, choiceColor:color, colorPoint: self.sliderImageView.center)
            
        }
    }
    
    private func calculateCenterInView(point:CGPoint) ->UIColor{
        
        let center = CGPoint.init(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
        let radius = self.frame.size.width/2.0
        let dx = abs(point.x - center.x)
        let dy = abs(point.y - center.y)
        
        var angle = atan(dy/dx)
        if angle.isNaN {
            angle = 0.0
        }
        
        let dist = sqrt(pow(dx, 2.0) + pow(dy, 2.0))
        var saturation = min(dist/radius, 1.0)
        
        if dist < 10{
            saturation = 0.0
        }
        if point.x < center.x {
            angle = Double.pi - angle
        }
        
        if point.y > center.y {
            angle = 2.0 * Double.pi - angle
        }
        
        let hsvType = HSVType.init(h: Float(angle)/Float((2.0 * Double.pi)), s: Float(saturation), v: 1.0)
        self.centerPointValue(hsvType: hsvType)
        
        let color = UIColor.init(hue: CGFloat(hsvType.h), saturation: CGFloat(hsvType.v), brightness: CGFloat(hsvType.s), alpha: 1.0)
        
        return color
    }
    
    private func centerPointValue(hsvType:HSVType){
        self.currentHSVWithNew = hsvType
        self.currentHSVWithNew?.v = 1.0
        
        print("hsvType:\(hsvType)")
        
        let angle = (Double)(self.currentHSVWithNew!.h) * 2.0 * Double.pi
        let center = CGPoint.init(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
        
        var radius:Float = Float(self.frame.size.width/2.0 - self.sliderImageView.frame.size.width/2.0)
        radius *= self.currentHSVWithNew!.s
        var x = (Float)(center.x) + cosf(Float(angle)) * radius
        var y = (Float)(center.y) - sinf(Float(angle)) * radius
        
        x = roundf(x-Float(self.sliderImageView.frame.size.width)/2.0) + Float(self.sliderImageView.frame.size.width)/2.0
        y = roundf(y-Float(self.sliderImageView.frame.size.height)/2.0) + Float(self.sliderImageView.frame.size.height)/2.0
        
        //滑动图片的中心点位置
        self.sliderImageView.center = CGPoint.init(x: (CGFloat(x)), y:(CGFloat(y)))
    }
    
    private func setSliderCenter(sliderCenter:CGPoint){
        self.sliderCenter = sliderCenter
        self.sliderImageView.center = sliderCenter
    }
    
}

struct HSVType{
    var h:Float
    var s:Float
    var v:Float
}

struct RGBType{
    var r:Float
    var g:Float
    var b:Float
}
