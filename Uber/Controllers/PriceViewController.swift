//
//  PriceViewController.swift
//  Uber
//
//  Created by Ryan Nazari on 2/18/19.
//  Copyright © 2019 Ryan Nazari. All rights reserved.
//

import UIKit
import Lottie

class PriceViewController: UIViewController {
    
    let random = Int.random(in: 0...3)
    
    @IBOutlet private var animationView: LOTAnimationView!
    @IBOutlet weak var priceTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startAnimation()
        priceTextField.text = "Driver is comming, You should pay $\(random)"
    }
    
    func startAnimation() {
        animationView.setAnimation(named: "3870-taxi")
        animationView.loopAnimation = true
        animationView.play()
    }

}
