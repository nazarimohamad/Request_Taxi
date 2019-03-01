//
//  PriceViewController.swift
//  Uber
//
//  Created by Ryan Nazari on 2/18/19.
//  Copyright © 2019 Ryan Nazari. All rights reserved.
//

import UIKit

class PriceViewController: UIViewController {


    var imgArray = ["car1", "car2", "car3", "car4"]
    let random1 = Int.random(in: 0...3)
    let random2 = Int.random(in: 1...5)
    
    @IBOutlet weak var carImg: UIImageView!
    @IBOutlet weak var priceTextField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        carImg.image = UIImage(named: imgArray[random1])
        priceTextField.text = "Driver is comming, You should pay $\(random2*2)"
    }

}
