//
//  SymbolDrawViewController.swift
//  SymbolLog
//
//  Created by Ji Mun on 8/26/16.
//  Copyright © 2016 Ji Mun. All rights reserved.
//

import UIKit

class SymbolDrawViewController: UIViewController {

    // MARK: Properties
    var lastPoint = CGPoint.zero
    var selectedColor: CGColor = UIColor.blackColor().CGColor
    var brushWidth: CGFloat = 15.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    var width = 300.0
    var height = 150.0
    
    var image: UIImage? // At this point, either there's a symbol with image saved already, or no symbol nor image, and we are in the process of making one
    
    // MARK: IBOutlet
    
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var colorControl: ColorControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBlankCanvase()
        if let image = image {
            mainImageView.image = image
        }
        selectedColor = colorControl.currentColor.CGColor
        colorControl.symbolDrawViewController = self
    }
    
    func createBlankCanvase() {
        let rect = CGRectMake(0.0, 0.0, 300.0, 150.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        mainImageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func findCanvasPosition(input:CGPoint)->(CGPoint?){
        let minX = tempImageView.frame.origin.x
        let minY = tempImageView.frame.origin.y
        let maxX = minX + CGFloat(300)
        let maxY = minY + CGFloat(150)
        
        if input.x < minX || input.x > maxX || input.y < minY || input.y > maxY {
            return nil
        }
        return CGPoint(x:input.x - minX, y:input.y - minY)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.locationInView(self.view)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        if let adjustedFromPoint = findCanvasPosition(fromPoint), let adjustedToPoint = findCanvasPosition(toPoint) {
            // 1 - draw into temp image
            UIGraphicsBeginImageContext(tempImageView.frame.size)
            let context = UIGraphicsGetCurrentContext()
            tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: tempImageView.frame.size.width, height: tempImageView.frame.size.height))
            
            
            
            // 2 - draw a line
            CGContextMoveToPoint(context, adjustedFromPoint.x, adjustedFromPoint.y)
            CGContextAddLineToPoint(context, adjustedToPoint.x, adjustedToPoint.y)
            
            // 3 - parameters for brush size and opacity and brush stroke
            CGContextSetLineCap(context, CGLineCap.Round)
            CGContextSetLineWidth(context, brushWidth)
            CGContextSetStrokeColorWithColor(context, selectedColor)
            //CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
            CGContextSetBlendMode(context, CGBlendMode.Normal)
            
            // 4 - Where actually draw the path
            CGContextStrokePath(context)
            
            // 5 - Wrap drawing context to render the new line
            tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            tempImageView.alpha = opacity
            UIGraphicsEndImageContext()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 6 -
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: width, height: height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: width, height: height), blendMode: CGBlendMode.Normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    
    
    // MARK: - Actions
    @IBAction func reset(sender: UIButton) {
        createBlankCanvase()
    }
    
    // MARK: - Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            image = mainImageView.image
        }
    }
    

}

protocol ColorControlDelegate {
    func colorTapped(color: CGColor)
}

/*class colorPickerDelegate: ColorControlDelegate {
    func colorTapped(color:CGColor) {
        
    }
}*/
