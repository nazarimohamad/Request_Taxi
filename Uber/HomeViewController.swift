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


protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}


class HomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedPin: MKPlacemark? = nil
    let locationManager = CLLocationManager()
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
        
        if let locationSearchTable = locationSearchTable as? LocationSearchTable {
            locationSearchTable.mapView = mapView
            locationSearchTable.handleMapSearchDelegate = self
        }
        
        
    }
//    MARK- Location Manager Delegate Method
//    ****************************************************
    
    // didUpdateLoations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let firstLocation = locations.first as! CLLocation
        
        let lat = firstLocation.coordinate.latitude
        let lon = firstLocation.coordinate.longitude
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let regin = MKCoordinateRegion(center: center /*location.cordinate*/, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
        self.mapView.setRegion(regin, animated: true)
        
        locationManager.stopUpdatingLocation()


    }
    // didFaillWithError
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
     print(error)
    }
    
    
//    MARK- Get direction function
    func getDirection(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
}
//      MARK- Map pin and button
//      **********************************************

//MARK- Handeling the map search pin
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
        if annotation is MKUserLocation {
            return nil
        }
        let reusedId = "pin"
        let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusedId) as? MKPinAnnotationView
        pinView?.pinTintColor = UIColor.black
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint(x: 10, y: 10), size: smallSquare))
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: Selector(("getDirection")), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}
