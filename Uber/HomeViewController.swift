//
//  HomeViewController.swift
//  Uber
//
//  Created by Ryan Nazari on 2/4/19.
//  Copyright © 2019 Ryan Nazari. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    let mapView1 = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    
//    MARK- Location Manager Delegate Method
//    ****************************************************
    
    // didUpdateLoations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print(latitude)
    }
    
    
    // didFaillWithError
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
     print(error)
    }
    

}
