//
//  ColorControl.swift
//  SymbolLog
//
//  Created by Ji Mun on 8/29/16.
//  Copyright © 2016 Ji Mun. All rights reserved.
//

import UIKit

class ColorControl: UIView {
    
    var delegate: ColorControlDelegate?
    
    var colorButtons = [UIButton]()
    var colors = [
        UIColor.blackColor(),
        UIColor.redColor(),
        UIColor.orangeColor(),
        UIColor.yellowColor(),
        UIColor.greenColor(),
        UIColor.init(red: 0 / 255.0, green: 88.0/255.0, blue: 38.0 / 255.0, alpha: 1.0), // Dark Green
        UIColor.init(red: 84.0 / 255.0, green: 112.0/225, blue: 68.0 / 255.0, alpha: 1.0), // grey green
        UIColor.cyanColor(),
        UIColor.init(red: 57.0 / 255.0, green: 150.0 / 255.0, blue: 210.0 / 255.0, alpha: 1.0), // Medium Blue
        UIColor.blueColor(),
        //UIColor.init(red: 0.0, green: 25.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0), // Dark Blue
        UIColor.magentaColor(),
        UIColor.init(red: 180.0 / 255.0, green: 0.0, blue: 123.0 / 255.0, alpha: 1.0), // Fuschia-ish

        UIColor.purpleColor(),
        UIColor.init(red: 102.0 / 255.0, green: 45.0 / 255.0, blue: 145.0 / 255.0, alpha: 1.0), // My purple
        UIColor.init(red: 163.0 / 255.0, green: 98.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0), // light Brown
    ]
    var selectedButtonIndex = 0
    var currentColor: UIColor = UIColor.blackColor()
    var symbolDrawViewController: SymbolDrawViewController?
    
    var spaceWidth = 0
    var size = 60
    var areaWidth = 300
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        for (index, color) in colors.enumerate() {
            var xPos = index * (size + spaceWidth)
            var yPos = 0
            if xPos >= areaWidth {
                yPos = xPos / areaWidth * size
                xPos = xPos % areaWidth
            }
            let button = UIButton(frame: CGRect(x: xPos, y: yPos, width: size, height: size))
            button.backgroundColor = color
            
            button.addTarget(self, action: #selector(ColorControl.colorButtonTapped(_:)), forControlEvents: .TouchDown)

            colorButtons += [button]
            addSubview(button)
            
        }
        updateselectedValue(0)
    }
    
    func updateselectedValue(i: Int) {
        for b in colorButtons {
            removeBorderOnButton(b)
        }
        addBorderOnButton(colorButtons[i])
        currentColor = colors[i]
        
        symbolDrawViewController?.selectedColor = currentColor.CGColor
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: areaWidth, height: size * 4)
    }
    
    
    // MARK: Button Action
    func colorButtonTapped(button: UIButton) {
        
        // find out which button it was
        let index = colorButtons.indexOf(button)!
        updateselectedValue(index)

        // Probably not the best way, but I want to keep this simple and 
        // be able to add in colors dynamically
    }
    
    func addBorderOnButton(button: UIButton){
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }
    func removeBorderOnButton(button: UIButton){
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.clearColor().CGColor
    }

}
