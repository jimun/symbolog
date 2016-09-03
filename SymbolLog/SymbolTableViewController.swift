//
//  SymbolTableViewController.swift
//  SymbolLog
//
//  Created by Ji Mun on 8/25/16.
//  Copyright © 2016 Ji Mun. All rights reserved.
//

import UIKit

extension SymbolTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class SymbolTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    struct SymbolGroup {
        var firstLetter: String!
        var symbols: [Symbol]!
    }
    
    // MARK: Properties
    //var symbols = [Symbol]()
    var searchActive : Bool = false
    let alphabet:[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

    var symbolGroupArray:[SymbolGroup]! = [SymbolGroup]()
    //var filtered:[Symbol] = [Symbol]()
    var filtered:[SymbolGroup] = [SymbolGroup]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    //@IBOutlet weak var searchBar: UISearchBar!
    //@IBOutlet var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)

    
    //@IBOutlet var searchDisplayController: UISearchDisplayController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        var symbols = [Symbol]()
        if let savedSymbols = loadSymbols() {
            symbols = savedSymbols
        }
        symbolGroupArray = sectionSymbols(symbols)!
        
        tableView.backgroundView = nil
        
        // Set up controller for search bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        //searchBar.delegate = self
        
        //self.searchController!.searchResultsTableView.registerClass(SymbolTableViewCell.self, forCellReuseIdentifier: "SymbolTableViewCell")
        
        sortList()
    }
    
    func sortList(){
        //symbolGroupArray.sortInPlace({ $0.firstLetter < $1.firstLetter })  // Sort by keyword
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
        //return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if searchActive && searchBarTextNotEmpty() {
            rowCount = filtered[section].symbols.count
            if filtered.map({$0.symbols.count}).reduce(0, combine: +) == 0 {
                tableView.separatorStyle = .None
            } else {
                tableView.separatorStyle = .SingleLine
            }
        } else {
            rowCount =  symbolGroupArray[section].symbols.count
            tableView.separatorStyle = .SingleLine
        }
        
        return rowCount
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchActive {
            return nil
        }
        return self.alphabet[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SymbolTableViewCell"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SymbolTableViewCell
        
        var symbol:Symbol?
        
        if searchActive && searchBarTextNotEmpty() {
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
        return !searchActive
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            symbolGroupArray[indexPath.section].symbols.removeAtIndex(indexPath.row)
            //symbols.removeAtIndex(indexPath.row)
            saveSymbols()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    // MARK: Searchbar related functions
    
    func searchBarTextNotEmpty() -> Bool{
        return !(searchController.searchBar.text?.isEmpty)!
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        let symbolsOnly = symbolGroupArray.flatMap{$0.symbols}.flatMap{$0}
        
        let filteredSymbols = symbolsOnly.filter({ (symbol) -> Bool in
            let mainKeyword: NSString = symbol.mainKeyword
            let found = (mainKeyword.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            return found
        })
        filtered = sectionSymbols(filteredSymbols)!
        
        if filtered.count == 0 || searchText.isEmpty {
            searchActive = false
        } else {
            searchActive = true
        }
        
        tableView.reloadData()
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
    // TODO: Doesn't work for searched symbol. PRobably will have to make my own custom search to get this to work?
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetail" {
            let symbolDetailViewController = segue.destinationViewController as! SymbolViewController
            
            // Get the cell that generated this segue.
            if let selectedSymbolCell = sender as? SymbolTableViewCell {
                let indexPath = self.tableView.indexPathForCell(selectedSymbolCell)!
                var selectedSymbol: Symbol
                if searchActive && searchBarTextNotEmpty() {
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
                //symbols[selectedIndexPath.row] = symbol
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new meal.
                //let newIndexPath = NSIndexPath(forRow: symbols.count, inSection: 0)
                //symbols.append(symbol)
                //tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                
                
                let firstLetter = String(symbol.mainKeyword[symbol.mainKeyword.startIndex]).uppercaseString
                let sectionIndex = alphabet.indexOf(firstLetter)!
                let newIndexPath = NSIndexPath(forRow: symbolGroupArray[sectionIndex].symbols.count, inSection: sectionIndex)
                
                symbolGroupArray[sectionIndex].symbols.append(symbol)
                
                /*
                symbols.append(symbol)
                let newIndexPath = NSIndexPath(forRow: symbols.count, inSection: 0)
                */
 
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            saveSymbols()
        }
    }
    
    // MARK NSCoding
    
    func saveSymbols() {
        //let symbolsOnly = symbols
        let symbolsOnly = symbolGroupArray.flatMap{$0.symbols}.flatMap{$0}
        if NSKeyedArchiver.archiveRootObject(symbolsOnly, toFile: Symbol.ArchiveURL.path!) {
            //sortList() // sort and refresh view
            print("Successfully saved")
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
