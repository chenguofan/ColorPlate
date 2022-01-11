//
//  UIColor-Extension.swift
//  wristband
//
//  Created by suhengxian on 2021/10/29.
//

import Foundation
import UIKit

extension UIColor{
        struct RGBA {
            var r: UInt8
            var g: UInt8
            var b: UInt8
            var a: UInt8
        }

        /// 将十六进制的字符串转化为 `UInt32` 类型的数值, 能够解析的最大值为 `0xFFFFFFFFFF` 超过此值返回 `UInt32.max`
        /// - Parameter hex: 十六进制字符串，如果字符串中包含非十六进制，那么只会将第一个非十六进制之前的十六进制转化为 `UInt32`。如果第一个字符就是非十六进制的则会返回 `nil`
        /// - Returns: 转换之后的 `UInt32` 类型的数值
        static func hexStringToUInt32(hex: String) -> UInt32? {
            let hexString = hex.replacingOccurrences(of: "#", with: "")
            let scanner = Scanner(string: hexString)
            var result: UInt64 = 0
            if scanner.scanHexInt64(&result) {
                return result > UInt32.max ? UInt32.max : UInt32(result)
            } else {
                return nil
            }
        }

        /// 将 UInt32 的颜色值转换成 RGBA
        /// - Parameter from: UInt32 类型的颜色值
        /// - Returns: RGBA
        static func getRGBA(from: UInt32) -> RGBA {
            func getbyte(_ value: UInt32) -> UInt8 {
                return UInt8(value & 0xFF)
            }
            let r = getbyte(from >> 24)
            let g = getbyte(from >> 16)
            let b = getbyte(from >> 8)
            let a = getbyte(from)
            return RGBA(r: r, g: g, b: b, a: a)
        }

        /// 获取 UIColor 的 RGBA 值
        var rgba: RGBA? {
            let numberOfComponents = self.cgColor.numberOfComponents
            // 使用图片创建的 Color（`UIColor(patternImage:)`） 的 numberOfComponents 数量为 1
            if numberOfComponents == 1 {
                return nil
            } else if numberOfComponents == 2 {
                guard let rgb = self.cgColor.components?[0],
                    let a = self.cgColor.components?[1] else { return nil }
                return RGBA(r: UInt8(rgb * 255),
                            g: UInt8(rgb * 255),
                            b: UInt8(rgb * 255),
                            a: UInt8(a * 255))
            } else if numberOfComponents == 4 {
                guard let r = self.cgColor.components?[0],
                    let g = self.cgColor.components?[1],
                    let b = self.cgColor.components?[2],
                    let a = self.cgColor.components?[3] else { return nil }
                return RGBA(r: UInt8(r * 255),
                            g: UInt8(g * 255),
                            b: UInt8(b * 255),
                            a: UInt8(a * 255))
            } else {
                return nil
            }
        }

        /// 使用十六进制颜色值初始化 UIColor
        /// - Parameter hex: 十六进制颜色值
        convenience init?(hexColor: String) {
            var hex = hexColor.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
            // 验证色值的有效性
            let legalCharacter = hex.uppercased().map { String($0) }.filter { c -> Bool in
                let c1 = c > "9" && c < "A"
                let c2 = c < "0"
                let c3 = c > "F"
                return  c1 || c2 || c3
            }.count == 0

            guard legalCharacter else { return nil }
            if hex.count == 3 {
                hex = hex.map { String($0) }.map { $0 + $0 }.joined().appending("FF")
            } else if hex.count == 4 {
                hex = hex.map { String($0) }.map { $0 + $0 }.joined()
            } else if hex.count == 6 {
                hex = hex.appending("FF")
            } else if hex.count == 8 {
            } else {
                return nil
            }

            guard let colorValue = Self.hexStringToUInt32(hex: hex) else { return nil }
            let rgba = Self.getRGBA(from: colorValue)
            self.init(red: CGFloat(rgba.r) / 255,
                      green: CGFloat(rgba.g) / 255,
                      blue: CGFloat(rgba.b) / 255,
                      alpha: CGFloat(rgba.a) / 255)
        }
        
//    16进制生成自定义颜色
        static func hexColorWithAlpha(color: String, alpha:CGFloat) -> UIColor{

          var colorString = color.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

          if colorString.count < 6 {
              return UIColor.clear
          }

          if colorString.hasPrefix("0x") {
              colorString = (colorString as NSString).substring(from: 2)
          }
          if colorString.hasPrefix("#") {
              colorString = (colorString as NSString).substring(from: 1)
          }

          if colorString.count < 6 {
              return UIColor.clear
          }

          var rang = NSRange()
          rang.location = 0
          rang.length = 2

          let rString = (colorString as NSString).substring(with: rang)
          rang.location = 2
          let gString = (colorString as NSString).substring(with: rang)
          rang.location = 4
          let bString = (colorString as NSString).substring(with: rang)

          var r:UInt64 = 0, g:UInt64 = 0,b: UInt64 = 0

          Scanner(string: rString).scanHexInt64(&r)
          Scanner(string: gString).scanHexInt64(&g)
          Scanner(string: bString).scanHexInt64(&b)
            
          return UIColor.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
      }

        /// 使用 RGBA 的 UInt8 数值初始化 UIColor
        /// - Parameters:
        ///   - red: 红色值
        ///   - green: 绿色值
        ///   - blue: 蓝色值
        ///   - alpha: 透明度
        convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
            self.init(red: CGFloat(red) / 255.0,
                      green: CGFloat(green) / 255.0,
                      blue: CGFloat(blue) / 255.0,
                      alpha: CGFloat(alpha) / 255.0)
        }

        /// 使用 RGB 的 UInt8 数值,以及 alpha 0~1 初始化 UIColor
        /// - Parameters:
        ///   - red: 红色值
        ///   - green: 绿色值
        ///   - blue: 蓝色值
        ///   - alpha: 透明度 0~1
        convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: CGFloat) {
            self.init(red: CGFloat(red) / 255.0,
                      green: CGFloat(green) / 255.0,
                      blue: CGFloat(blue) / 255.0,
                      alpha: alpha)
        }

        /// 十六进制色值
        var hexValue: String? {
            guard let rgba = rgba else { return nil }
            return String(format: "%02X%02X%02X%02X", rgba.r,rgba.g,rgba.b,rgba.a)
        }

        /// 生成随机色
        static var random: UIColor {
            let r = CGFloat.random(in: 0...1)
            let g = CGFloat.random(in: 0...1)
            let b = CGFloat.random(in: 0...1)
            let a = CGFloat.random(in: 0...1)
            return UIColor(red: r, green: g, blue: b, alpha: a)
        }
        
    func changeToHSV()->(h:CGFloat,s:CGFloat,v:CGFloat){
        
        let r:CGFloat = CGFloat((self.rgba?.r ?? 0)/255)
        let g:CGFloat = CGFloat((self.rgba!.g ?? 0)/255)
        let b:CGFloat = CGFloat((self.rgba?.b ?? 0)/255)
        
        print("r = \(r), g = \(g), b = \(b)")
        
        let Max:CGFloat = max(r, g, b)
        let Min:CGFloat = min(r, g, b)
 
        //h 0-360
        var h:CGFloat = 0
        if Max == Min {
            h = 0.0
        }else if Max == r && g >= b {
            h = 60 * (g-b)/(Max-Min)
        } else if Max == r && g < b {
            h = 60 * (g-b)/(Max-Min) + 360
        } else if Max == g {
            h = 60 * (b-r)/(Max-Min) + 120
        } else if Max == b {
            h = 60 * (r-g)/(Max-Min) + 240
        }
        print("h = \(h)")
        
        //s 0-1
        var s:CGFloat = 0
        if Max == 0 {
            s = 0
        } else {
            s = (Max - Min)/Max
        }
        print("s = \(s)")
        
        //v
        let v:CGFloat = Max
        print("v = \(v)")
        
        return (h, s, v)
    }
    
        //RGB 颜色转成 HSV颜色
        func rgbToHsv(red:CGFloat, green:CGFloat, blue:CGFloat) -> (h:CGFloat, s:CGFloat, v:CGFloat){
            let r:CGFloat = red/255
            let g:CGFloat = green/255
            let b:CGFloat = blue/255
            print("r = \(r), g = \(g), b = \(b)")
            
            let Max:CGFloat = max(r, g, b)
            let Min:CGFloat = min(r, g, b)
     
            //h 0-360
            var h:CGFloat = 0
            if Max == Min {
                h = 0.0
            }else if Max == r && g >= b {
                h = 60 * (g-b)/(Max-Min)
            } else if Max == r && g < b {
                h = 60 * (g-b)/(Max-Min) + 360
            } else if Max == g {
                h = 60 * (b-r)/(Max-Min) + 120
            } else if Max == b {
                h = 60 * (r-g)/(Max-Min) + 240
            }
            print("h = \(h)")
            
            //s 0-1
            var s:CGFloat = 0
            if Max == 0 {
                s = 0
            } else {
                s = (Max - Min)/Max
            }
            print("s = \(s)")
            
            //v
            let v:CGFloat = Max
            print("v = \(v)")
            
            return (h, s, v)
        }
}
