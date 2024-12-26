//
//  CALayer+Extensions.swift
//
//  Created by Jorge Ouahbi on 27/08/2020.
//  Copyright © 2020 dsp. All rights reserved.
//

import UIKit
public extension CALayer {
    func add(_ anim: CAAnimation,
             forKey key: String?,
             withCompletion completion: ((Bool) -> Void)?) {
        anim.completion = {  complete in
            completion?(complete)
        }
        add(anim, forKey: key)
    }
}
public extension CAShapeLayer {
    /// projectLineStrokeGradient
    ///
    /// - Parameters:
    ///   - internalPoints: [CGPoints]]
    ///   - ctx: CGContext
    ///   - gradient: CGGradient
    private func projectLineStrokeGradient(_ ctx: CGContext,
                                           gradient: CGGradient,
                                           internalPoints: [CGPoint],
                                           lineWidth: CGFloat) {
        ctx.saveGState()
        for index in 0..<internalPoints.count - 1 {
            var start: CGPoint = internalPoints[index]
            // The ending point of the axis, in the shading's target coordinate space.
            var end: CGPoint  = internalPoints[index+1]
            // Draw the gradient in the clipped region
            let halfLineWidth = lineWidth * 0.5
            start  = end.projectLine(start, length: halfLineWidth)
            end    = start.projectLine(end, length: -halfLineWidth)
            ctx.scaleBy(x: self.bounds.size.width,
                        y: self.bounds.size.height )
            ctx.drawLinearGradient(gradient,
                                   start: start,
                                   end: end,
                                   options: [])
        }
        ctx.restoreGState()
    }
    func strokeGradient( ctx: CGContext?,
                         points: [CGPoint]?,
                         color: UIColor,
                         lineWidth: CGFloat,
                         fadeFactor: CGFloat = 0.4) {
        if  let ctx = ctx {
            let locations =  [0, fadeFactor, 1 - fadeFactor, 1]
            let gradient = CGGradient(colorsSpace: nil,
                                      colors: [UIColor.white.withAlphaComponent(0.1).cgColor,
                                               color.cgColor,
                                               color.withAlphaComponent(fadeFactor).cgColor,
                                               UIColor.white.withAlphaComponent(0.8).cgColor] as CFArray,
                                      locations: locations )!
            // Clip to the path, stroke and enjoy.
            if let path = self.path {
                color.setStroke()
                let curPath = UIBezierPath(cgPath: path)
                curPath.lineWidth = lineWidth
                curPath.stroke()
                curPath.addClip()
                // if we are using the stroke, we offset the from and to points
                // by half the stroke width away from the center of the stroke.
                // Otherwise we tend to end up with fills that only cover half of the
                // because users set the start and end points based on the center
                // of the stroke.
                if let internalPoints = points {
                    projectLineStrokeGradient( ctx,
                                               gradient: gradient,
                                               internalPoints: internalPoints,
                                               lineWidth: lineWidth)
                }
            }
        }
    }
}
public extension CALayer {
    typealias LayerAnimation = (CALayer) -> CAAnimation
    var isModel: Bool {
        return self == self.model()
    }
    var rootLayer: CALayer? {
        var parent: CALayer? = self
        var layer: CALayer?
        repeat {
            layer = parent
            parent = parent?.superlayer
        } while (parent != nil)
        return layer
    }
    func isSublayerOfLayer(layer: CALayer) -> Bool {
        var ancestor: CALayer? = self.superlayer
        while ancestor != nil {
            if ancestor == layer {
                return true
            }
            ancestor = ancestor?.superlayer
        }
        return false
    }
    func sublayerNamed(name: String) -> CALayer? {
        return sublayersNamed(name: name)?.first
    }
    func sublayersNamed(name: String) -> [CALayer]? {
        let sublayers =  self.sublayers?.filter({$0.name?.hasPrefix(name) ?? false})
        return sublayers
    }
    // return all animations running by this layer.
    // the returned value is mutable
    var animations: [(String, CAAnimation?)] {
        if let keys = animationKeys() {
            return keys.map { return ($0, self.animation(forKey: $0)!.copy() as? CAAnimation) }
        }
        return []
    }
    func flatTransformTo(layer: CALayer) -> CATransform3D {
        var layer = layer
        var trans = layer.transform
        while let superlayer = layer.superlayer, superlayer != self, !(superlayer.delegate is UIWindow) {
            trans = CATransform3DConcat(superlayer.transform, trans)
            layer = superlayer
        }
        return trans
    }

    @objc func tint(withColors colors: [UIColor]) {
        sublayers?.recursiveSearch(leafBlock: {
            backgroundColor = colors.first?.cgColor
        }) {
            $0.tint(withColors: colors)
        }
    }
    func removeAnimations(named name: String) {
        guard let keys = animationKeys() else { return }
        for animationKey in keys where animationKey.hasPrefix(name) {
            removeAnimation(forKey: animationKey)
        }
    }
    func playAnimation(_ layerAnimation: LayerAnimation, key: String, completion: (() -> Void)? = nil) {
        sublayers?.recursiveSearch(leafBlock: {
            DispatchQueue.main.async { CATransaction.begin() }
            DispatchQueue.main.async { CATransaction.setCompletionBlock(completion) }
            add(layerAnimation(self), forKey: key)
            DispatchQueue.main.async { CATransaction.commit() }
        }) {
            $0.playAnimation(layerAnimation, key: key, completion: completion)
        }
    }
    func stopAnimation(forKey key: String) {
        sublayers?.recursiveSearch(leafBlock: {
            removeAnimation(forKey: key)
        }) {
            $0.stopAnimation(forKey: key)
        }
    }
}
extension CAGradientLayer {
    override public func tint(withColors colors: [UIColor]) {
        sublayers?.recursiveSearch(leafBlock: {
            self.colors = colors.map { $0.cgColor }
        }) {
            $0.tint(withColors: colors)
        }
    }
}
