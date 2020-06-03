//
//  Arrow.swift
//  Arrow
//
//  Created by Tom Jacob on 6/3/20.
//  Copyright © 2020 Tom Jacob. All rights reserved.
//

import Cocoa

class Arrow:NSView {
    var start:NSPoint
    var end:NSPoint
    let lineWidth: CGFloat = 2.0
    let headLength = CGFloat(20)
    let tailWidth = CGFloat(10)
    let headWidth = CGFloat(30)
    
    init(frame:NSRect, starting:NSPoint, ending:NSPoint) {
        self.start = starting
        self.end = ending
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        self.start = NSMakePoint(0, 0)
        self.end = NSMakePoint(0, 0)
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
       
        
        let path = NSBezierPath()
        let color = NSColor.red

        color.set()
        path.lineWidth = lineWidth
        
        self.start = self.convert(start, from: self.superview!)
        self.end = self.convert(end, from: self.superview!)

        let length = CGFloat(hypotf(Float(end.x - start.x), Float(end.y - start.y)))
        
        let points = arrowPoints(length: length, tailWidth: tailWidth, headWidth: headWidth, headLength: headLength)
        path.move(to: points.first!)
        for point in points.dropFirst() {
            path.line(to: point)
        }
        
        let transform = self.transform(length)
        path.transform(using: transform)
        path.fill()
        path.stroke()
        path.close()
    }
    private func transform(_ length:CGFloat) -> AffineTransform {
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        return AffineTransform(m11: cosine, m12: sine, m21: -sine, m22: cosine, tX: start.x, tY: start.y)
    }
    private func arrowPoints(length:CGFloat,
                             tailWidth:CGFloat,
                             headWidth:CGFloat,
                             headLength:CGFloat) -> [NSPoint] {
        
        let tailLength = length - headLength
        var points:[NSPoint] = []
        
        points.append(NSMakePoint(0, tailWidth / 2))
        points.append(NSMakePoint(tailLength, tailWidth / 2))
        points.append(NSMakePoint(tailLength, headWidth / 2))
        points.append(NSMakePoint(length, 0))
        points.append(NSMakePoint(tailLength, -headWidth / 2))
        points.append(NSMakePoint(tailLength, -tailWidth / 2))
        points.append(NSMakePoint(0, -tailWidth / 2))
        return points
        
    }
}
