//
//  SymbolViewController.swift
//  SymbolLog
//
//  Created by Ji Mun on 8/24/16.
//  Copyright © 2016 Ji Mun. All rights reserved.
//

import UIKit

class SymbolViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var mainKeywordTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MealTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new meal.
     */
    var symbol: Symbol?
    var imageEdited = false
    
    //var delegate: SymbolViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input thorugh delegate
        mainKeywordTextField.delegate = self
        
        if let symbol = symbol {
            navigationItem.title = symbol.mainKeyword
            mainKeywordTextField.text = symbol.mainKeyword
            imageView.image = symbol.image
        }
        imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        imageView.layer.borderWidth = 2
        
        checkValidSymbolMainKeyword()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save btuton while editing.
        saveButton.enabled = false
    }
    
    func checkValidSymbolMainKeyword() {
        // Disable the Save buton if the text field is empty.
        let text = mainKeywordTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard. // Does this really work?
        mainKeywordTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidSymbolMainKeyword()
        navigationItem.title = mainKeywordTextField.text
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddSymbolMode = presentingViewController is UINavigationController
        if isPresentingInAddSymbolMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let mainKeyword = mainKeywordTextField.text ?? ""
            let image = imageView.image!
            let secondaryKeywords = [String]()
            
            // Set the meal to be passed to MealTableViewController after the unwind segue.
            symbol = Symbol(mainKeyword: mainKeyword, image: image, secondaryKeywords: secondaryKeywords)
        }
        else if segue.identifier == "editImageSegue"{
            
            let navController = segue.destinationViewController as! UINavigationController
            let drawController = navController.topViewController as! SymbolDrawViewController
            if let image = symbol?.image {
                drawController.image = image
            } else if imageEdited {
                drawController.image = imageView.image
            }
        }
    }
    
    @IBAction func unwindToSymbolView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? SymbolDrawViewController, image = sourceViewController.image {
            imageView.image = image
            imageEdited = true
        }
    }

}


