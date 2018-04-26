//
//  GildedRose.swift
//  GildedRose
//
//  Created by Tom Heinan on 8/31/15.
//  Copyright © 2015 Tom Heinan. All rights reserved.
//

public class GildedRose {
    
    static let legendaryItems = ["Sulfuras, Hand of Ragnaros"]
    static let deadlineItems = ["Backstage passes to a TAFKAL80ETC concert"]
    static let timelessItems = ["Aged Brie"]
    
    public static func isLegendaryItem(_ item: String) -> Bool{
        return legendaryItems.contains(item)
    }
    
    public static func isItemWithDeadline(_ item: String) -> Bool {
        return deadlineItems.contains(item)
    }
    
    public static func isItemWhichImprovesWithTime(_ item: String) -> Bool {
        return timelessItems.contains(item)
    }
    
    public static func isOrdinaryItem(_ item: String) -> Bool {
        return (!isLegendaryItem(item) && !isItemWithDeadline(item) && !isItemWhichImprovesWithTime(item))
    }
    
    public static func isConjuredItem(_ item: String) -> Bool {
        return item.hasPrefix("Conjured")
    }
    
    public static func updateQuality(items: Array<Item>) -> [Item] {
        var updatedItems: [Item] = []
        var index = 0
        
        for item in items {
            var updatedItem: Item?
            if isOrdinaryItem(item.name) {
                updatedItem = decreaseQuality(ofItem: item, withThreshold: 0)
            } else if isItemWithDeadline(item.name) {
                updatedItem = decreaseQualityForDeadlineItem(item)
            } else if isItemWhichImprovesWithTime(item.name) {
                updatedItem = increaseQuality(ofItem: item, withThreshold: 50)
            } else if isConjuredItem(item.name) {
                updatedItem = decreaseQuality(ofItem: item, withThreshold: 0, byValue: 2)
            } else if isLegendaryItem(item.name) {
                updatedItem = item
            }
            
            if var updateItem = updatedItem {
                if isLegendaryItem(updateItem.name) == false {
                    updateItem.sellIn = updateItem.sellIn - 1
                }
                updatedItems.append(updateItem)
                index = index + 1
            }
        }
        
        return updatedItems
    }
    
    private static func decreaseQuality(ofItem item: Item, withThreshold threshold: Int, byValue: Int) -> Item {
        var item = item
        for _ in 0 ..< byValue {
            item = decreaseQuality(ofItem: item, withThreshold: threshold)
        }
        
        return item
    }
    
    private static func decreaseQuality(ofItem item: Item, withThreshold threshold: Int)  -> Item {
        var item = item
        var decreaseVal = 1
        
        if item.sellIn <= 0 {
            decreaseVal = 2
        }
        
        if item.quality - decreaseVal >= threshold {
            item.quality = item.quality - decreaseVal
        } else {
            item.quality = 0
        }
        
        return item
    }
    
    private static func increaseQuality(ofItem item: Item, withThreshold threshold: Int) -> Item {
        var item = item
        var increaseVal = 1
        
        if item.sellIn <= 0 {
            increaseVal = 2
        }
        
        if item.quality + increaseVal <= threshold {
            item.quality = item.quality + increaseVal
        } else {
            item.quality = threshold
        }
        
        return item
    }
    
    private static func decreaseSellIn(ofItem item: Item) -> Item {
        var item = item
        item.sellIn = item.sellIn - 1
        return item
    }
    
    private static func decreaseQualityForDeadlineItem(_ item: Item) -> Item {
        var item = item
        
        if item.sellIn <= 0 {
            item.quality = 0
        } else if item.sellIn <= 5 {
            item = decreaseQuality(ofItem: item, withThreshold: 0, byValue: 2)
        } else if item.sellIn <= 10 {
            item = decreaseQuality(ofItem: item, withThreshold: 0, byValue: 5)
        }
        
        return item
    }
}
