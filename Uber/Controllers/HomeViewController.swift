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


protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark: MKPlacemark)
}


class HomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
   
    let locationManager = CLLocationManager()
    
    var selectedPin: MKPlacemark?
    var resultSearchController : UISearchController!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Where do you wanna go?"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
    }
//    MARK- Location Manager Delegate Method
//    ****************************************************
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//    locationMAnager.requestLocation()
//    }
    
    // didUpdateLoations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let firstLocation = locations.first else { return }
        let lat = firstLocation.coordinate.latitude
        let lon = firstLocation.coordinate.longitude
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let regin = MKCoordinateRegion(center: center /*location.cordinate*/, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        mapView.setRegion(regin, animated: true)
    }
    // didFaillWithError
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
     print(error)
    }
    
    
//    MARK- Get direction function
    @objc func getDirection(){
        performSegue(withIdentifier: "price", sender: self)
        
    }
}
//      MARK- Map pin and button
//      **********************************************

//MARK- Handele map search
extension HomeViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        annotation.subtitle = placemark.locality
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let regin = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(regin, animated: true)
    }
}

//MARK- Handeling the button
extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        let reusedId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusedId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusedId)
        }
        pinView?.pinTintColor = UIColor.black
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(getDirection), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}
