//
//  HomeViewController.swift
//  Uber
//
//  Created by Ryan Nazari on 2/4/19.
//  Copyright © 2019 Ryan Nazari. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit



class HomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    let mapView1 = MKMapView()
    var resultSearchController : UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable")
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as? UISearchResultsUpdating
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Where do you wanna go?"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
    }
    

    
//    MARK- Location Manager Delegate Method
//    ****************************************************
    
    // didUpdateLoations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let firstLocation = locations.first as! CLLocation
        
        let lat = firstLocation.coordinate.latitude
        let lon = firstLocation.coordinate.longitude
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let regin = MKCoordinateRegion(center: center /*location.cordinate*/, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        self.mapView.setRegion(regin, animated: true)
        
        locationManager.stopUpdatingLocation()


    }
    
    
    // didFaillWithError
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
     print(error)
    }
    

//    MARK- Search
//    ********************************************************
    

    
}
