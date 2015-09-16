//
//  Bowtie.swift
//  Bow Ties
//
//  Created by YongRen on 15/9/15.
//  Copyright (c) 2015年 Razeware. All rights reserved.
//

import Foundation
import CoreData
/*
    Similar to @dynamic in Objective-C, the @NSManaged attribute informs
the Swift compiler that the backing store and implementation of a property
will be provided at runtime instead of at compile time.

    The normal pattern is for a property to be backed by an instance variable
in memory. A property on a managed object is different: It’s backed by the
managed object context, so the source of the data is not known at compile time.
*/
class Bowtie: NSManagedObject {
    // bool,double,int -> NSNumber
    @NSManaged var isFavorite: NSNumber
    @NSManaged var lastWorn: NSDate
    @NSManaged var name: String
    @NSManaged var rating: NSNumber
    @NSManaged var searchKey: String
    @NSManaged var timesWorn: NSNumber
    @NSManaged var photoData: NSData // 二进制－> NSData
    @NSManaged var tintColor: AnyObject // 可变类型－> AnyObject

}
