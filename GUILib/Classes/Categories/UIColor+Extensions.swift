//
//    Copyright 2015 - Jorge Ouahbi
//
//   Licensed under the Apache License, Version 2.0 (the "License")
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
//

//
//  UIColor+Extensions.swift
//
//  Created by Jorge Ouahbi on 27/4/16.
//  Copyright © 2016 Jorge Ouahbi. All rights reserved.
//
// v 1.0 Merged files
// v 1.1 Some clean and better component access
import UIKit
///  Attributes
let kLuminanceDarkCutoff: CGFloat = 0.6
public extension UIColor {
    ///  chroma RGB
    var croma: CGFloat {
        let comp  = components
        let min1  = min(comp[1], comp[2])
        let max1  = max(comp[1], comp[2])
        return max(comp[0], max1) - min(comp[0], min1)
    }
    // luma RGB
    // WebKit
    // luma = (r * 0.2125 + g * 0.7154 + b * 0.0721) * ((double)a / 255.0)
    var luma: CGFloat {
        let comp      = components
        let lumaRed   = 0.2126 * Float(comp[0])
        let lumaGreen = 0.7152 * Float(comp[1])
        let lumaBlue  = 0.0722 * Float(comp[2])
        let luma      = Float(lumaRed + lumaGreen + lumaBlue)
        return CGFloat(luma * Float(components[3]))
    }
    var luminance: CGFloat {
        let comp      = components
        let fmin = min(min(comp[0], comp[1]), comp[2])
        let fmax = max(max(comp[0], comp[1]), comp[2])
        return (fmax + fmin) / 2.0
    }
    var isLightLuma: Bool {
        return self.luma >= kLuminanceDarkCutoff
    }
    var isDarkLuma: Bool {
        return self.luma < kLuminanceDarkCutoff
    }
    var isLight: Bool {
        return !(brightness < 0.5)
    }
    var isDark: Bool {
        return (brightness < 0.5)
    }
    var brightness: CGFloat {
        guard let components = cgColor.components,
            components.count >= 3 else { return 0 }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return brightness
    }
    var complementaryColor: UIColor {
        if #available(iOS 13, tvOS 13, *) {
            return UIColor { traitCollection in
                return self.isLight ? self.darker : self.lighter
            }
        } else {
            return isLight ? darker : lighter
        }
    }
    var lighter: UIColor {
        return adjust(by: 1.35)
    }
    var darker: UIColor {
        return adjust(by: 0.94)
    }
    func adjust(by percent: CGFloat) -> UIColor {
        var hcomponent: CGFloat = 0, scomponent: CGFloat = 0, bcomponent: CGFloat = 0, acomponent: CGFloat = 0
        getHue(&hcomponent, saturation: &scomponent, brightness: &bcomponent, alpha: &acomponent)
        return UIColor(hue: hcomponent, saturation: scomponent, brightness: bcomponent * percent, alpha: acomponent)
    }
    func makeGradient() -> [UIColor] {
        return [self, self.complementaryColor, self]
    }
}
public extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    // MARK: RGBA components
    /// Returns an array of `CGFloat`s containing four elements with `self`'s:
    /// - red (index `0`)
    /// - green (index `1`)
    /// - blue (index `2`)
    /// - alpha (index `3`)
    /// or
    /// - white (index `0`)
    /// - alpha (index `1`)
    var components: [CGFloat] {
        // Constructs the array in which to store the RGBA-components.
        if let components = self.cgColor.components {
            if numberOfComponents == 4 {
                return [components[0], components[1], components[2], components[3]]
            } else {
                return [components[0], components[1]]
            }
        }
        return []
    }
    /// red component
    var red: CGFloat {
        return components[0]
    }
    /// green component
    var green: CGFloat {
        return  components[1]
    }
    /// blue component
    var blue: CGFloat {
        return  components[2]
    }
    /// number of color components
    var numberOfComponents: size_t {
        return self.cgColor.numberOfComponents
    }
    /// color space
    var colorSpace: CGColorSpace? {
        return self.cgColor.colorSpace
    }
    // MARK: HSBA components
    /// Returns an array of `CGFloat`s containing four elements with `self`'s:
    /// - hue (index `0`)
    /// - saturation (index `1`)
    /// - brightness (index `2`)
    /// - alpha (index `3`)
    var hsbaComponents: [CGFloat] {
        // Constructs the array in which to store the HSBA-components.
        var components0: CGFloat = 0
        var components1: CGFloat = 0
        var components2: CGFloat = 0
        var components3: CGFloat = 0
        getHue(&components0,
               saturation: &components1,
               brightness: &components2,
               alpha:      &components3)
        return [components0,components1,components2,components3]
    }
    /// alpha component
    var alpha : CGFloat {
        return self.cgColor.alpha
    }
    /// hue component
    var hue: CGFloat {
        return  hsbaComponents[0]
    }
    /// saturation component
    var saturation: CGFloat {
        return  hsbaComponents[1]
    }
    /// Returns a lighter color by the provided percentage
    ///
    /// - param: lighting percent percentage
    /// - returns: lighter UIColor
    func lighterColor(percent: Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 + percent))
    }
    /// Returns a darker color by the provided percentage
    ///
    /// - param: darking percent percentage
    /// - returns: darker UIColor
    func darkerColor(percent: Double) -> UIColor {
        return colorWithBrightnessFactor(factor: CGFloat(1 - percent))
    }
    /// Return a modified color using the brightness factor provided
    ///
    /// - param: factor brightness factor
    /// - returns: modified color
    func colorWithBrightnessFactor(factor: CGFloat) -> UIColor {
        return UIColor(hue: hsbaComponents[0],
                       saturation: hsbaComponents[1],
                       brightness: hsbaComponents[2] * factor,
                       alpha: hsbaComponents[3])
        
    }
    /// Color difference
    ///
    /// - Parameter fromColor: color
    /// - Returns: Color difference
    func difference(fromColor: UIColor) -> Int {
        // get the current color's red, green, blue and alpha values
        let red: CGFloat = self.components[0]
        let green: CGFloat = self.components[1]
        let blue: CGFloat = self.components[2]
        // var alpha: CGFloat = self.components[3]
        // get the fromColor's red, green, blue and alpha values
        let fromRed: CGFloat = fromColor.components[0]
        let fromGreen: CGFloat = fromColor.components[1]
        let fromBlue: CGFloat = fromColor.components[2]
        // var fromAlpha: CGFloat = fromColor.components[3]
        let redValue = (max(red, fromRed) - min(red, fromRed)) * 255
        let greenValue = (max(green, fromGreen) - min(green, fromGreen)) * 255
        let blueValue = (max(blue, fromBlue) - min(blue, fromBlue)) * 255
        return Int(redValue + greenValue + blueValue)
    }
    
    /// Brightness difference
    ///
    /// - Parameter fromColor: color
    /// - Returns: Brightness difference
    func brightnessDifference(fromColor: UIColor) -> Int {
        // get the current color's red, green, blue and alpha values
        let red: CGFloat = self.components[0]
        let green: CGFloat = self.components[1]
        let blue: CGFloat = self.components[2]
        // var alpha: CGFloat = self.components[3]
        let brightness = Int((((red * 299) + (green * 587) + (blue * 114)) * 255) / 1000)
        // get the fromColor's red, green, blue and alpha values
        let fromRed: CGFloat = fromColor.components[0]
        let fromGreen: CGFloat = fromColor.components[1]
        let fromBlue: CGFloat = fromColor.components[2]
        // var fromAlpha: CGFloat = fromColor.components[3]
        let fromBrightness = Int((((fromRed * 299) + (fromGreen * 587) + (fromBlue * 114)) * 255) / 1000)
        return max(brightness, fromBrightness) - min(brightness, fromBrightness)
    }
    /// Color delta
    ///
    /// - Parameter color: color
    /// - Returns: Color delta
    func colorDelta(color: UIColor) -> Double {
        var total = CGFloat(0)
        total += pow(self.components[0] - color.components[0], 2)
        total += pow(self.components[1] - color.components[1], 2)
        total += pow(self.components[2] - color.components[2], 2)
        total += pow(self.components[3] - color.components[3], 2)
        return sqrt(Double(total) * 255.0)
    }
    /// Short UIColor description
    var shortDescription: String {
        let components  = self.components
        if numberOfComponents == 2 {
            let components = String(format: "%.1f %.1f", components[0], components[1])
            if let colorSpace = self.colorSpace {
                return "\(colorSpace.model.name):\(components)"
            }
            return "\(components)"
        } else {
            assert(numberOfComponents == 4)
            let components = String(format: "%.1f %.1f %.1f %.1f", components[0], components[1], components[2], components[3])
            if let colorSpace = self.colorSpace {
                return "\(colorSpace.model.name):\(components)"
            }
            return "\(components)"
        }
    }
}
/// Random RGBA
public extension UIColor {
    class func random() -> UIColor? {
        return UIColor(red: CGFloat.random(in: 0..<1),
                       green: CGFloat.random(in: 0..<1),
                       blue: CGFloat.random(in: 0..<1),
                       alpha: 1.0)
    }
}
/// Rainbow
public extension UIColor {
    /// Returns a array of the complete hue color spectre (0 - 360)
    ///
    /// - param: number of hue UIColor steps
    /// - param: start UIColor hue
    /// - returns: UIColor array
    class func rainbow(_ numberOfSteps: Int, hue:Double = 0.0) -> [UIColor]! {
        var colors:[UIColor] = []
        let iNumberOfSteps =  1.0 / Double(numberOfSteps)
        var hue:Double = hue
        while hue < 1.0 {
            if colors.count == numberOfSteps {
                break
            }
            let color = UIColor(hue: CGFloat(hue),
                                saturation: CGFloat(1.0),
                                brightness: CGFloat(1.0),
                                alpha: CGFloat(1.0))
            colors.append(color)
            hue += iNumberOfSteps
        }
        // assert(colors.count == numberOfSteps, "Unexpected number of rainbow colors \(colors.count). Expecting \(numberOfSteps)")
        return colors
    }
}
