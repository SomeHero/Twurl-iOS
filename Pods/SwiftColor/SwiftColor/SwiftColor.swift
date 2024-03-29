//
//  UIColorExtensions.swift
//  SwiftColors
//
//  Created by LEI on 3/26/15.
//  Copyright (c) 2015 TouchingApp. All rights reserved.
//

#if os(iOS)
    import UIKit
    public typealias Color = UIColor
#elseif os(OSX)
    import Cocoa
    public typealias Color = NSColor
#endif

public func ==(lhs: Color, rhs: Color) -> Bool{
    var (lRed, lGreen, lBlue, lAlpha) = lhs.colorComponents()
    var (rRed, rGreen, rBlue, rAlpha) = rhs.colorComponents()
    return fabsf(Float(lRed - rRed)) < FLT_EPSILON
        && fabsf(Float(lGreen - rGreen)) < FLT_EPSILON
        && fabsf(Float(lBlue - rBlue)) < FLT_EPSILON
        && fabsf(Float(lAlpha - rAlpha)) < FLT_EPSILON
}

public extension Color {
    
    public convenience init(_ hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }
    
    public convenience init(hexInt: Int, alpha: Float = 1.0) {
        var hexString = NSString(format: "%0X", hexInt)
        if hexInt <= 0xfff {
            hexString = NSString(format: "%03X", hexInt)
        }else if hexInt <= 0xffff {
            hexString = NSString(format: "%04X", hexInt)
        }else if hexInt <= 0xffffff {
            hexString = NSString(format: "%06X", hexInt)
        }
        self.init(hexString: hexString as String, alpha: alpha)
    }
    
    public convenience init(hexString: String, alpha: Float = 1.0) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var mAlpha: CGFloat = CGFloat(alpha)
        var minusLength = 0
        
        let scanner = NSScanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
            minusLength = 1
        }
        if hexString.hasPrefix("0x") {
            scanner.scanLocation = 2
            minusLength = 2
        }
        var hexValue: UInt64 = 0
        scanner.scanHexLongLong(&hexValue)
        switch count(hexString) - minusLength {
        case 3:
            red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
            green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
            blue = CGFloat(hexValue & 0x00F) / 15.0
        case 4:
            red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
            green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
            blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
            mAlpha = CGFloat(hexValue & 0x00F) / 15.0
        case 6:
            red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(hexValue & 0x0000FF) / 255.0
        case 8:
            red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
            green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
            mAlpha = CGFloat(hexValue & 0x000000FF) / 255.0
        default:
            break
        }
        self.init(red: red, green: green, blue: blue, alpha: mAlpha)
    }
    
    public func alpha(value: Float) -> Color {
        var (red, green, blue, alpha) = colorComponents()
        return Color(red: red, green: green, blue: blue, alpha: CGFloat(value))
    }
    
    public func red(value: Int) -> Color {
        var (red, green, blue, alpha) = colorComponents()
        return Color(red: CGFloat(value)/255.0, green: green, blue: blue, alpha: alpha)
    }
    
    public func green(value: Int) -> Color {
        var (red, green, blue, alpha) = colorComponents()
        return Color(red: red, green: CGFloat(value)/255.0, blue: blue, alpha: alpha)
    }
    
    public func blue(value: Int) -> Color {
        var (red, green, blue, alpha) = colorComponents()
        return Color(red: red, green: green, blue: CGFloat(value)/255.0, alpha: alpha)
    }
    
    public func colorComponents() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        #if os(iOS)
            self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        #elseif os(OSX)
            self.colorUsingColorSpaceName(NSCalibratedRGBColorSpace)!.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        #endif
        return (red, green, blue, alpha)
    }
    
}

public extension Color {
    
    public class var black: Color {
        return self.blackColor()
    }
    
    public class var darkGray: Color {
        return self.darkGrayColor()
    }
    
    public class var lightGray: Color {
        return self.lightGrayColor()
    }
    
    public class var white: Color {
        return self.whiteColor()
    }
    
    public class var gray: Color {
        return self.grayColor()
    }
    
    public class var red: Color {
        return self.redColor()
    }
    
    public class var green: Color {
        return self.greenColor()
    }
    
    public class var blue: Color {
        return self.blueColor()
    }
    
    public class var cyan: Color {
        return self.cyanColor()
    }
    
    public class var yellow: Color {
        return self.yellowColor()
    }
    
    public class var magenta: Color {
        return self.magentaColor()
    }
    
    public class var orange: Color {
        return self.orangeColor()
    }
    
    public class var purple: Color {
        return self.purpleColor()
    }
    
    public class var brown: Color {
        return self.brownColor()
    }
    
    public class var clear: Color {
        return self.clearColor()
    }
    
}

public extension String {
    
    public var color: Color {
        return Color(hexString: self)
    }
    
}

public extension Int {
    
    public var color: Color {
        return Color(hexInt: self)
    }
    
}

