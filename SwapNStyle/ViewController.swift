//
//  ViewController.swift
//  SwapNStyle
//
//  Created by Evan Elkin on 11/26/16.
//  Copyright © 2016 Evan Elkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var shirtImageView: UIImageView!
    @IBOutlet weak var pantsImageView: UIImageView!
    @IBOutlet weak var shoesImageView: UIImageView!
    
    var clothingItems = ItemDB.instance.getClothes()
    // arrays of picture names
    var shirts: [String] = []
    var pants: [String] = []
    var shoes: [String] = []
    
    // counter for arrays
    var shirtsI: Int = 0
    var pantsI: Int = 0
    var shoesI: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // fills up clothing items array if database isn't empty
        if !clothingItems.isEmpty {
            for item in clothingItems {
                if item.itemType == "Shirt" {
                    shirts.append(item.itemPicture)
                } else if item.itemType == "Pants"{
                    pants.append(item.itemPicture)
                } else {
                    shoes.append(item.itemPicture)
                }
            }
        }
        // defaults to first item in each array if it's there
        if shirts.count > 0 {
            shirtImageView.image = loadImage(shirts[0])
            print("shirts: \(shirts[0])")
        }
        if pants.count > 0 {
            pantsImageView.image = loadImage(pants[0])
            print("pants: \(pants[0])")
        }
        if shoes.count > 0 {
            shoesImageView.image = loadImage(shoes[0])
            print("shoes: \(shoes[0])")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: swiping pictures 
    @IBAction func swipeImageRight(_ sender: UISwipeGestureRecognizer) {
        
        let imageView = sender.view! as! UIImageView
        print("swiped right on: \(imageView)")
        
        // assigns images to specific image view based on item type
        if imageView == shirtImageView {
            if !shirts.isEmpty {
                if shirtsI > 0 {
                    shirtsI -= 1
                } else {
                    shirtsI = shirts.count - 1
                }
                imageView.image = loadImage(shirts[shirtsI])
            }
        }
        if imageView == pantsImageView {
            if !pants.isEmpty {
                if pantsI > 0 {
                    pantsI -= 1
                } else {
                    pantsI = pants.count - 1
                }
                imageView.image = loadImage(pants[pantsI])
            }
        }
        if imageView == shoesImageView {
            if !shoes.isEmpty {
                if shoesI > 0 {
                    shoesI -= 1
                } else {
                    shoesI = shoes.count - 1
                }
                imageView.image = loadImage(shoes[shoesI])
            }
        }
        
        /*
        //test
        if imageView.image == #imageLiteral(resourceName: "defaultPhoto") {
            imageView.image = #imageLiteral(resourceName: "sprite")
        } else {
            imageView.image = #imageLiteral(resourceName: "defaultPhoto")
        }
        */
    }
    
    @IBAction func swipeImageLeft(_ sender: UISwipeGestureRecognizer) {
        
        let imageView = sender.view! as! UIImageView
        print("swiped left on: \(imageView)")
        
        // assigns images to specific image view based on item type
        if imageView == shirtImageView {
            if !shirts.isEmpty {
                if shirtsI < shirts.count - 1 {
                    shirtsI += 1
                } else {
                    shirtsI = 0
                }
                imageView.image = loadImage(shirts[shirtsI])
            }
        }
        if imageView == pantsImageView {
            if !pants.isEmpty {
                if pantsI < pants.count - 1{
                    pantsI += 1
                } else {
                    pantsI = 0
                }
                imageView.image = loadImage(pants[pantsI])
            }
        }
        if imageView == shoesImageView {
            if !shoes.isEmpty {
                if shoesI < shoes.count - 1{
                    shoesI += 1
                } else {
                    shoesI = 0
                }
                imageView.image = loadImage(shoes[shoesI])
            }
        }
        
        /*
        //test
        if imageView.image == #imageLiteral(resourceName: "defaultPhoto") {
            imageView.image = #imageLiteral(resourceName: "sprite")
        } else {
            imageView.image = #imageLiteral(resourceName: "defaultPhoto")
        }
        */
    }
    
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSecondViewController" {
            let secondViewController = segue.destination as! SecondViewController

        }
    }
    
    // unwind segue that updates clothingItems
    @IBAction func unwindfromSecondView(_ send: UIStoryboardSegue) {
        // empty and readd all items so there's no redundency
        clothingItems.removeAll()
        clothingItems = ItemDB.instance.getClothes()
        
        if !clothingItems.isEmpty {
            for item in clothingItems {
                if item.itemType == "Shirt" {
                    shirts.append(item.itemPicture)
                } else if item.itemType == "Pants"{
                    pants.append(item.itemPicture)
                } else {
                    shoes.append(item.itemPicture)
                }
            }
        }
        
        // sets back to indexes
        if shirts.count > 0 {
            shirtImageView.image = loadImage(shirts[shirtsI])
        }
        if pants.count > 0 {
            pantsImageView.image = loadImage(pants[pantsI])
        }
        if shoes.count > 0 {
            shoesImageView.image = loadImage(shoes[shoesI])
        }
        
        //only the best
        /*
        if self.view.backgroundColor! == UIColor.red {
            self.view.backgroundColor! = UIColor.white
        } else if self.view.backgroundColor! == UIColor.white {
            self.view.backgroundColor! = UIColor.blue
        } else {
            self.view.backgroundColor! = UIColor.red
        }
        */
    }

    //loads image from database when swiped
    func loadImage(_ clothingImagePath:String) -> UIImage{
        // get path to the Documents directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths.first
        let fileName = documentsDirectory?.appendingPathComponent(clothingImagePath)
        
        // read in the image from the file called sample.png --> set the lower image view
        let image = UIImage(contentsOfFile:(fileName?.path)!)
        return image!
    }
    
}

