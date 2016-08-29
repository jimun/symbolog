//
//  SymbolDrawViewController.swift
//  SymbolLog
//
//  Created by Ji Mun on 8/26/16.
//  Copyright © 2016 Ji Mun. All rights reserved.
//

import UIKit

class SymbolDrawViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: Properties
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    var width = 300.0
    var height = 150.0
    
    var image: UIImage? // At this point, either there's a symbol with image saved already, or no symbol nor image, and we are in the process of making one
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
        ]
    
    
    // MARK: IBOutlet
    
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBlankCanvase()
        if let image = image {
            mainImageView.image = image
            
        }
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
            
            print(adjustedFromPoint)
            
            
            // 2 - draw a line
            CGContextMoveToPoint(context, adjustedFromPoint.x, adjustedFromPoint.y)
            CGContextAddLineToPoint(context, adjustedToPoint.x, adjustedToPoint.y)
            
            // 3 - parameters for brush size and opacity and brush stroke
            CGContextSetLineCap(context, CGLineCap.Round)
            CGContextSetLineWidth(context, brushWidth)
            CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
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
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let settingsViewController = segue.destinationViewController as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.brush = brushWidth
        settingsViewController.opacity = opacity
        settingsViewController.red = red
        settingsViewController.green = green
        settingsViewController.blue = blue
    }*/
    
    
    // MARK: - Actions
    @IBAction func reset(sender: UIButton) {
        createBlankCanvase()
    }
    
    /*
    @IBAction func share(sender: AnyObject) {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0,
            width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
    }
    
    @IBAction func pencilPressed(sender: AnyObject) {
        // 1
        var index = sender.tag ?? 0
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        // 2
        (red, green, blue) = colors[index]
        
        // 3
        if index == colors.count - 1 {
            opacity = 1.0
        }
    }*/

    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol SymbolViewControllerDelegate {
    func imageSaved(controller: SymbolViewController)
}
