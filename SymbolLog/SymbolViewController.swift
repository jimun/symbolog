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
    
    var delegate: SymbolViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input thorugh delegate
        mainKeywordTextField.delegate = self
        
        if let symbol = symbol {
            navigationItem.title = symbol.mainKeyword
            mainKeywordTextField.text = symbol.mainKeyword
            imageView.image = symbol.image
        }
        
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
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        imageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
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
            drawController.image = imageView.image!
        }
    }
    


    // MARK: Actions
    /*
    @IBAction func goToDrawSymbol(sender: UITapGestureRecognizer) {
        print("Tap gesture recognized")
        mainKeywordTextField.resignFirstResponder()
        let symbolDrawViewController = SymbolDrawViewController()
        symbolDrawViewController.image = symbol?.image
        // symbolDrawViewController.delegate = self
        presentViewController(symbolDrawViewController, animated: true, completion: nil)

    }*/
    
    
    
    // Later should change this to able to edit image (using an image editor)
    /*
    @IBAction func selectImageFromLibrary(sender: UITapGestureRecognizer) {
        
        print("Tap gesture recognized")
        // Hide the keboard.
        mainKeywordTextField.resignFirstResponder()

        // UIImagePickerCotroller is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // TODO: This will change later
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveSymbol(sender: UIButton) {
        
    }
 */
}


