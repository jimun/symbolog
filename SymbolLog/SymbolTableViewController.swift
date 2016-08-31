//
//  SymbolTableViewController.swift
//  SymbolLog
//
//  Created by Ji Mun on 8/25/16.
//  Copyright © 2016 Ji Mun. All rights reserved.
//

import UIKit

class SymbolTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    // MARK: Properties
    
    var symbols = [Symbol]()
    var searchActive : Bool = false
    var filtered:[Symbol] = []

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        if let savedSymbols = loadSymbols() {
            symbols += savedSymbols
        } else {
            // Load the sample data.
            loadSampleSymbols()
        }
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    func loadSampleSymbols() {
        let image1 = UIImage(named: "god")!
        let symbol1 = Symbol(mainKeyword: "God", image: image1)!
        
        let image2 = UIImage(named: "righteous")!
        let symbol2 = Symbol(mainKeyword: "Righteous", image: image2)!
        
        let image3 = UIImage(named: "joy")!
        let symbol3 = Symbol(mainKeyword: "Joy", image: image3)!
        
        symbols += [symbol1, symbol2, symbol3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        return symbols.count
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SymbolTableViewCell"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SymbolTableViewCell
        
        var symbol:Symbol? = nil
        if searchActive {
            symbol = filtered[indexPath.row]
        } else {
            symbol = symbols[indexPath.row]
        }
        cell.mainKeywordLabel.text = symbol?.mainKeyword
        cell.symbolImageView.image = symbol?.image

        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            symbols.removeAtIndex(indexPath.row)
            saveSymbols()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = symbols.filter({ (symbol) -> Bool in
            let tmp: NSString = symbol.mainKeyword
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetail" {
            let symbolDetailViewController = segue.destinationViewController as! SymbolViewController
            
            // Get the cell that generated this segue.
            if let selectedSymbolCell = sender as? SymbolTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedSymbolCell)!
                let selectedSymbol = symbols[indexPath.row]
                symbolDetailViewController.symbol = selectedSymbol
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new symbol.")
        }
    }
    
    
    @IBAction func unwindToSymbolList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? SymbolViewController, symbol = sourceViewController.symbol {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                symbols[selectedIndexPath.row] = symbol
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: symbols.count, inSection: 0)
                symbols.append(symbol)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            saveSymbols()
        }
    }

    // MARK NSCoding
    
    func saveSymbols() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(symbols, toFile: Symbol.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
    }
    
    func loadSymbols() -> [Symbol]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Symbol.ArchiveURL.path!) as? [Symbol]
    }
}
