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
import Firebase


protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark: MKPlacemark)
}


class HomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func logoutButton(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("error to log out")
        }
    }
    
    let locationManager = CLLocationManager()
    
    var selectedPin: MKPlacemark?
    var resultSearchController : UISearchController!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestAlwaysAuthorization()
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

    // didUpdateLoations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let firstLocation = locations.first else { return }
        let lat = firstLocation.coordinate.latitude
        let lon = firstLocation.coordinate.longitude
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let regin = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        mapView.setRegion(regin, animated: true)
    }
    // didFaillWithError
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
     print(error)
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
        let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        let regin = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(regin, animated: true)
    }
}

//MARK- Handeling the Request Taxi and get direction button
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
        button.addTarget(self, action: #selector(setupRequestButton), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    
    
    @objc private func setupRequestButton() {
        let requestTaxiButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Request Taxi", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8
            button.backgroundColor = .black
            button.addTarget(self, action: #selector(requestTaxi), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        let getDirectionButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Get Direction", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8
            button.backgroundColor = UIColor(red: 19/255, green: 144/255, blue: 255/255, alpha: 1)
            button.addTarget(self, action: #selector(getDirection), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        view.addSubview(requestTaxiButton)
        let guaid = view.safeAreaLayoutGuide
        requestTaxiButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        requestTaxiButton.bottomAnchor.constraint(equalTo: guaid.bottomAnchor, constant: 8).isActive = true
        requestTaxiButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10).isActive = true
        requestTaxiButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(getDirectionButton)
        getDirectionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        getDirectionButton.bottomAnchor.constraint(equalTo: guaid.bottomAnchor, constant: 8).isActive = true
        getDirectionButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        getDirectionButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    @objc func getDirection() {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
        
    }
    
    @objc func requestTaxi(){
        performSegue(withIdentifier: "price", sender: self)
    }
    
}
