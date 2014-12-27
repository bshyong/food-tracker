//
//  DetailViewController.swift
//  FoodTracker
//
//  Created by Benjamin Shyong on 12/22/14.
//  Copyright (c) 2014 Common Sense Labs. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet weak var textView: UITextView!
  
  var usdaItem:USDAItem?

    required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "usdaItemDidComplete:", name: kUSDAItemCompleted, object: nil)
    }
  
    override func viewDidLoad() {
      super.viewDidLoad()
        // Do any additional setup after loading the view.
      if usdaItem != nil {
        textView.attributedText = createAttributedString(usdaItem!)
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func usdaItemDidComplete(notification: NSNotification) {
      println("usdaItemDidComplete in DetailViewController")
      usdaItem = notification.object as? USDAItem
      if self.isViewLoaded() && self.view.window != nil {
        textView.attributedText = createAttributedString(usdaItem!)
      }
    }

    deinit {
      NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

  @IBAction func eatItBarButtonItemPressed(sender: UIBarButtonItem) {
  }

  func createAttributedString (usdaItem: USDAItem!) -> NSAttributedString {
    var itemAttributedString = NSMutableAttributedString()
    var centeredParagraphStyle = NSMutableParagraphStyle()
    centeredParagraphStyle.alignment = NSTextAlignment.Center
    centeredParagraphStyle.lineSpacing = 10.0
    var titleAttributesDictionary = [
      NSForegroundColorAttributeName : UIColor.blackColor(),
      NSFontAttributeName : UIFont.boldSystemFontOfSize(22.0),
      NSParagraphStyleAttributeName : centeredParagraphStyle]
    
    var leftAllignedParagraphStyle = NSMutableParagraphStyle()
    leftAllignedParagraphStyle.alignment = NSTextAlignment.Left
    leftAllignedParagraphStyle.lineSpacing = 20.0
    var styleFirstWordAttributesDictionary = [
      NSForegroundColorAttributeName : UIColor.blackColor(),
      NSFontAttributeName : UIFont.boldSystemFontOfSize(18.0),
      NSParagraphStyleAttributeName : leftAllignedParagraphStyle]
    var style1AttributesDictionary = [
      NSForegroundColorAttributeName : UIColor.darkGrayColor(),
      NSFontAttributeName : UIFont.systemFontOfSize(18.0),
      NSParagraphStyleAttributeName : leftAllignedParagraphStyle]
    var style2AttributesDictionary = [
      NSForegroundColorAttributeName : UIColor.lightGrayColor(),
      NSFontAttributeName : UIFont.systemFontOfSize(18.0),
      NSParagraphStyleAttributeName : leftAllignedParagraphStyle]
    
    let titleString = NSAttributedString(string: "\(usdaItem.name)\n", attributes: titleAttributesDictionary)
    itemAttributedString.appendAttributedString(titleString)
    
    let calciumTitleString = NSAttributedString(string: "Calcium ", attributes: styleFirstWordAttributesDictionary)
    let calciumBodyString = NSAttributedString(string: "\(usdaItem.calcium)% \n", attributes: style1AttributesDictionary)
    itemAttributedString.appendAttributedString(calciumTitleString)
    itemAttributedString.appendAttributedString(calciumBodyString)
    let carbohydrateTitleString = NSAttributedString(string: "Carbohydrate ", attributes: styleFirstWordAttributesDictionary)
    let carbohydrateBodyString = NSAttributedString(string: "\(usdaItem.carbohydrate)% \n", attributes: style2AttributesDictionary)
    itemAttributedString.appendAttributedString(carbohydrateTitleString)
    itemAttributedString.appendAttributedString(carbohydrateBodyString)
    let cholesterolTitleString = NSAttributedString(string: "Cholesterol ", attributes: styleFirstWordAttributesDictionary)
    let cholesterolBodyString = NSAttributedString(string: "\(usdaItem.cholesterol)% \n", attributes: style1AttributesDictionary)
    itemAttributedString.appendAttributedString(cholesterolTitleString)
    itemAttributedString.appendAttributedString(cholesterolBodyString)
    
    // Energy
    let energyTitleString = NSAttributedString(string: "Energy ", attributes: styleFirstWordAttributesDictionary)
    let energyBodyString = NSAttributedString(string: "\(usdaItem.energy)% \n", attributes: style2AttributesDictionary)
    itemAttributedString.appendAttributedString(energyTitleString)
    itemAttributedString.appendAttributedString(energyBodyString)
    
    // Fat Total
    let fatTotalTitleString = NSAttributedString(string: "FatTotal ", attributes: styleFirstWordAttributesDictionary)
    let fatTotalBodyString = NSAttributedString(string: "\(usdaItem.fatTotal)% \n", attributes: style1AttributesDictionary)
    itemAttributedString.appendAttributedString(fatTotalTitleString)
    itemAttributedString.appendAttributedString(fatTotalBodyString)
    
    // Protein
    let proteinTitleString = NSAttributedString(string: "Protein ", attributes: styleFirstWordAttributesDictionary)
    let proteinBodyString = NSAttributedString(string: "\(usdaItem.protein)% \n", attributes: style2AttributesDictionary)
    itemAttributedString.appendAttributedString(proteinTitleString)
    itemAttributedString.appendAttributedString(proteinBodyString)
    
    // Sugar
    let sugarTitleString = NSAttributedString(string: "Sugar ", attributes: styleFirstWordAttributesDictionary)
    let sugarBodyString = NSAttributedString(string: "\(usdaItem.sugar)% \n", attributes: style1AttributesDictionary)
    itemAttributedString.appendAttributedString(sugarTitleString)
    itemAttributedString.appendAttributedString(sugarBodyString)
    
    // Vitamin C
    let vitaminCTitleString = NSAttributedString(string: "Vitamin C ", attributes: styleFirstWordAttributesDictionary)
    let vitaminCBodyString = NSAttributedString(string: "\(usdaItem.vitaminC)% \n", attributes: style2AttributesDictionary)
    itemAttributedString.appendAttributedString(vitaminCTitleString)
    itemAttributedString.appendAttributedString(vitaminCBodyString)
    
    return itemAttributedString
  }
}
