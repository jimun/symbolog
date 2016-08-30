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
        UIColor.magentaColor(),
        UIColor.yellowColor(),
        UIColor.greenColor(),
        UIColor.cyanColor(),
        UIColor.blueColor(),
        UIColor.purpleColor()
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
        return CGSize(width: areaWidth, height: size * 2)
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
