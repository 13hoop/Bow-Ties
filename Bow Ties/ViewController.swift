//
//  ViewController.swift
//  Bow Ties
//
//  Created by Pietro Rea on 6/25/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var timesWornLabel: UILabel!
  @IBOutlet weak var lastWornLabel: UILabel!
  @IBOutlet weak var favoriteLabel: UILabel!

	// 上下文
	var managedContest: NSManagedObjectContext!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// 1 插入数据到CoreData
		self.insertSampleData()
		
		// 2 从coreData获取数据
		let request = NSFetchRequest(entityName: "Bowtie")
		let firstTitle = segmentedControl.titleForSegmentAtIndex(0)
		print("要查找seg的title［0］： \(firstTitle)")
		
		// 3 根据segment的tilte配置请求，然后执行查找相应数据
		request.predicate = NSPredicate(format: "searchKey == %@", firstTitle!)
		var error: NSError? = nil
		var results = managedContest.executeFetchRequest(request, error: &error) as! [Bowtie]?
		
		// 4 显示到UI
		if let bowties = results {
			populate(bowties[0])
		}else {
			print("未能获取\(error),\(error!.userInfo)")
		}
  }

	// 根据数据显示UI
	func populate(bowtie: Bowtie) {
		
		imageView.image = UIImage(data: bowtie.photoData) // 图片 － 由二进制提供
		nameLabel.text = bowtie.name
		ratingLabel.text = "Rating: \(bowtie.rating.doubleValue)/5"
		timesWornLabel.text = "# times worn: \(bowtie.timesWorn.integerValue)"
		favoriteLabel.hidden = !bowtie.isFavorite.boolValue
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
		dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
		lastWornLabel.text = "Last worn:" + dateFormatter.stringFromDate(bowtie.lastWorn)

		view.tintColor = bowtie.tintColor as! UIColor // 颜色依旧是颜色
	}
	
	/**
	从plist获取数据，然后插入到data
	*/
	func insertSampleData() {

		// 获取data中已存在数据的数量
		let fetchRequset = NSFetchRequest(entityName: "Bowtie")
		fetchRequset.predicate = NSPredicate(format: "searchKey != nil")
		let count = managedContest.countForFetchRequest(fetchRequset, error: nil)
		
		// 如果没有数据，则从plist取数据
		if count > 0 { return }
		let path = NSBundle.mainBundle().pathForResource("SampleData", ofType: "plist")
		let dataArray = NSArray(contentsOfFile: path!)!
		
		for dict : AnyObject in dataArray {
			
			// 通过上下文获取指定实体中的
			let entity = NSEntityDescription.entityForName("Bowtie", inManagedObjectContext: managedContest)
			let bowtie = Bowtie(entity: entity!, insertIntoManagedObjectContext: managedContest)
			
			let btDict = dict as! NSDictionary
			bowtie.name = btDict["name"] as! String
			bowtie.searchKey = btDict["searchKey"] as! String
			bowtie.rating = btDict["rating"] as! NSNumber
			let tintColotDict = btDict["tintColor"] as! NSDictionary
			bowtie.tintColor = colorFromDict(tintColotDict) // 颜色直接用UIColor保存
			// 保存图片
			let imageName = btDict["imageName"] as! String
			let image = UIImage(named: imageName)!
			let photoData = UIImagePNGRepresentation(image) // image转变为NSData保存
			bowtie.photoData = photoData!
			bowtie.lastWorn = btDict["lastWorn"] as! NSDate
			bowtie.timesWorn = btDict["timesWorn"] as! NSNumber
			bowtie.isFavorite = btDict["isFavorite"] as! NSNumber
		}
		
		// 提交［commite］上下文中的数据 && 错误处理
		var error: NSError?											// swift 2.0 要try catch
		if !managedContest.save(&error) {
			print("未能保存\(error),\(error!.userInfo)")
		}
	}
	
	func colorFromDict(dict: NSDictionary) -> UIColor {
		let red = dict["red"] as! NSNumber
		let green = dict["green"] as! NSNumber
		let blue = dict["blue"] as! NSNumber
		
		let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
	
		return color
	}
	
  @IBAction func segmentedControl(control: UISegmentedControl) {
    
  }

  @IBAction func wear(sender: AnyObject) {
    
  }
  
  @IBAction func rate(sender: AnyObject) {
    
  }
}

