//
//  Symbol.swift
//  SymbolLog
//
//  Created by Ji Mun on 8/24/16.
//  Copyright © 2016 Ji Mun. All rights reserved.
//

import UIKit

class Symbol: NSObject, NSCoding {
    
    // MARK: Types
    
    struct PropertyKey {
        static let mainKeywordKey = "mainKeyword"
        static let imageKey = "image"
        static let secondaryKeywordsKey = "secondaryKeywords"
    }
    
    // MARK: Properties
    
    var mainKeyword: String
    var image: UIImage
    
    // TOOD: Add additional keywords
    //var secondaryKeywords: [String]
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("symbols")
    
    // MARK: Initialization
    
    init?(mainKeyword: String, image: UIImage){
        self.mainKeyword = mainKeyword
        self.image = image
        //self.secondaryKeywords = secondaryKeywords
        
        super.init()
        
        if mainKeyword.isEmpty {
            return nil
        }
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(mainKeyword, forKey: PropertyKey.mainKeywordKey)
        aCoder.encodeObject(image, forKey: PropertyKey.imageKey)
        //aCoder.encodeObject(secondaryKeywords, forKey: PropertyKey.secondaryKeywordsKey)
    }
    
    //convenience init?(mainKeyword: String, image: UIImage) {
    //    self.init(mainKeyword: mainKeyword, image: image)
    //}
    
    required convenience init?(coder aDecoder: NSCoder) {
        let mainKeyword = aDecoder.decodeObjectForKey(PropertyKey.mainKeywordKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let image = aDecoder.decodeObjectForKey(PropertyKey.imageKey) as! UIImage
        
        //let secondaryKeywords = aDecoder.decodeObjectForKey(PropertyKey.secondaryKeywordsKey) as? [String] ?? [String]()
        
        // Must call designated initializer.
        self.init(mainKeyword: mainKeyword, image: image)
    }
}
