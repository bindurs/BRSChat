//
//  BackGroundView.swift
//  MusicPlayer
//
//  Created by Bindu on 16/08/17.
//  Copyright © 2017 Xminds. All rights reserved.
//

import UIKit

@IBDesignable class BackGroundView: UIView {
    
    @IBInspectable var startColor: UIColor = UIColor(colorLiteralRed: 11/255, green: 51/255, blue: 127/255, alpha: 1.0)
    @IBInspectable var endColor: UIColor = UIColor(colorLiteralRed: 5/255, green: 22/255, blue: 55/255, alpha: 1.0)
    
    override func draw(_ rect: CGRect) {
       
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: 0 , height: 0))
        path.addClip()
        
        // get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]
        
        //set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //set up the color stops
        let colorLocations : [CGFloat] = [0.0,1.0]
        
        // create the gradient
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)
        
        //  draw the gradient
        
        let startPoint = CGPoint.zero
        let enPoint = CGPoint(x: 0, y: self.bounds.height)
        context!.drawLinearGradient(gradient!,start: startPoint,end: enPoint,options: CGGradientDrawingOptions(rawValue: 0))
        
        
        // draw line in graph
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        context!.saveGState()
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
    }
}
