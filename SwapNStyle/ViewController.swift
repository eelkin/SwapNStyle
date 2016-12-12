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
    // array of colors for color pallette
    let colors: [UIColor] = [UIColor.init(red: 165, green: 206, blue: 228, alpha: 1),
                             UIColor.init(red: 205, green: 185, blue: 246, alpha: 1),
                             UIColor.init(red: 115, green: 203, blue: 253, alpha: 1),
                             UIColor.init(red: 132, green: 231, blue: 252, alpha: 1),
                             UIColor.init(red: 166, green: 249, blue: 207, alpha: 1)]
    
    // counter for arrays
    var shirtsI: Int = 0
    var pantsI: Int = 0
    var shoesI: Int = 0
    var colorsI: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Sets up image background
        self.view.backgroundColor! = colors[colorsI]
        
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
        // defaults to last item in each array if it's there
        if shirts.count > 0 {
            shirtImageView.image = loadImage(shirts[shirts.count - 1])
            print("shirts: \(shirts[0])")
        }
        if pants.count > 0 {
            pantsImageView.image = loadImage(pants[pants.count - 1])
            print("pants: \(pants[0])")
        }
        if shoes.count > 0 {
            shoesImageView.image = loadImage(shoes[pants.count - 1])
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
        
    }
    
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSecondViewController" {
            let secondViewController = segue.destination as! SecondViewController
            secondViewController.view.backgroundColor! = self.view.backgroundColor!
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
        
        // sets to item just added
        if shirts.count > 0 {
            shirtImageView.image = loadImage(shirts[shirts.count - 1])
        }
        if pants.count > 0 {
            pantsImageView.image = loadImage(pants[pants.count - 1])
        }
        if shoes.count > 0 {
            shoesImageView.image = loadImage(shoes[shoes.count - 1])
        }
        
        // sets background to new color (change to array instead of if statements
        if colorsI < colors.count - 1{
            colorsI += 1
        } else {
            colorsI = 0
        }
        self.view.backgroundColor! = colors[colorsI]
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

