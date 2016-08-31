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
    var symbolsDict = [Character: [Symbol]]()
    var symbols = [Symbol]()
    var searchActive : Bool = false
    let alphabet:[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    struct SymbolGroup {
        var firstLetter: String!
        var symbols: [Symbol]!
    }
    
    var symbolGroupArray:[SymbolGroup]! = [SymbolGroup]()
    
    var filtered:[SymbolGroup] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    //@IBOutlet weak var searchBar: UISearchBar!
    //@IBOutlet var tableView: UITableView!
    
    //@IBOutlet var searchDisplayController: UISearchDisplayController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        if let savedSymbols = loadSymbols() {
            symbols = savedSymbols
        }
        symbolGroupArray = sectionSymbols(symbols)!

        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        sortList()
    }
    
    func sortList(){
        symbolGroupArray.sortInPlace({ $0.firstLetter < $1.firstLetter })  // Sort by keyword
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return symbolGroupArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objectArray[section].sectionObjects.count

        if searchActive {
            if filtered.count == 0 {
                return 0
            } else {
                return filtered[section].symbols.count
            }
        }
        return symbolGroupArray[section].symbols.count
        //return symbolsDict.count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.alphabet[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SymbolTableViewCell"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SymbolTableViewCell
        
        print("\(searchActive) \(filtered.count) \(indexPath.section) \(indexPath.row)")
        var symbol:Symbol?
        
        if searchActive {
            if filtered.count == 0 || filtered[indexPath.section].symbols.count == 0 {
                return cell // exit early
            }
            //symbol = filtered[indexPath.row]
            symbol = filtered[indexPath.section].symbols[indexPath.row]
        } else {
            symbol = symbolGroupArray[indexPath.section].symbols[indexPath.row]
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

    // MARK: Searchbar related functions
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        tableView.reloadData() // This is probably wrong
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredSymbols = symbols.filter({ (symbol) -> Bool in
            let tmp: NSString = symbol.mainKeyword
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        filtered = sectionSymbols(filteredSymbols)!
        
        if filtered.count == 0 || searchText.isEmpty {
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        // Background color
        view.tintColor = UIColor(red: 214.0/255.0, green: 209.0/255.0, blue: 66.0/255.0, alpha: 0.5)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetail" {
            let symbolDetailViewController = segue.destinationViewController as! SymbolViewController
            
            // Get the cell that generated this segue.
            if let selectedSymbolCell = sender as? SymbolTableViewCell {
                print(self.tableView.indexPathForCell(selectedSymbolCell))
                print(self.tableView.indexPathForSelectedRow!)
                self.tableView.index
                print(searchDisplayController?.searchResultsTableView.indexPathForSelectedRow)
                let indexPath = tableView.indexPathForCell(selectedSymbolCell)!
                //let selectedSymbol = symbols[indexPath.row]
                //let selectedSymbol = symbolGroupArray[indexPath.section].symbols[indexPath.row]
                //symbolDetailViewController.symbol = selectedSymbol
                var selectedSymbol: Symbol
                if searchActive {
                    //if filtered.count == 0 || filtered[indexPath.section].symbols.count == 0 {
                    //    return cell // exit early
                    //}
                    //symbol = filtered[indexPath.row]
                    selectedSymbol = filtered[indexPath.section].symbols[indexPath.row]
                } else {
                    selectedSymbol = symbolGroupArray[indexPath.section].symbols[indexPath.row]
                }
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
                symbolGroupArray[selectedIndexPath.section].symbols[selectedIndexPath.row] = symbol
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new meal.
                //let newIndexPath = NSIndexPath(forRow: symbols.count, inSection: 0)
                //symbols.append(symbol)
                //tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                
                let firstLetter = String(symbol.mainKeyword[symbol.mainKeyword.startIndex]).uppercaseString
                let sectionIndex = alphabet.indexOf(firstLetter)
                let newIndexPath = NSIndexPath(forRow: symbolGroupArray[sectionIndex!].symbols.count, inSection: sectionIndex!)
                
                symbolGroupArray[sectionIndex!].symbols.append(symbol)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            saveSymbols()
        }
    }
    
    // MARK NSCoding
    
    func saveSymbols() {
        if NSKeyedArchiver.archiveRootObject(symbols, toFile: Symbol.ArchiveURL.path!) {
            sortList() // sort and refresh view
        } else {
            print("Failed to save meals...")
        }
    }
    
    func sectionSymbols(aSymbols: [Symbol]) -> [SymbolGroup]?{
        var symbolsSectioned = [String: [Symbol]]()
        for c in alphabet {
            symbolsSectioned[c.lowercaseString] = [Symbol]()
        }
        for aS in aSymbols {
            let firstLetter = String(aS.mainKeyword[aS.mainKeyword.startIndex]).lowercaseString
            let editedSymbols = symbolsSectioned[firstLetter]! + [aS]
            symbolsSectioned[firstLetter] = editedSymbols
        }
        
        var sga = [SymbolGroup]()
        for (key, value) in symbolsSectioned { //
            sga.append(SymbolGroup(firstLetter: key, symbols: value))
        }
        sga.sortInPlace({ $0.firstLetter < $1.firstLetter })
        return sga
    }
    
    func loadSymbols() -> [Symbol]? {
        return  NSKeyedUnarchiver.unarchiveObjectWithFile(Symbol.ArchiveURL.path!) as? [Symbol]
    }
}
