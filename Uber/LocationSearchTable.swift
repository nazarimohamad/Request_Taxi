//
//  LocationSearchTable.swift
//  Uber
//
//  Created by Ryan Nazari on 2/7/19.
//  Copyright © 2019 Ryan Nazari. All rights reserved.
//
import UIKit
import MapKit




class LocationSearchTable: UITableViewController {

    var matchingItem: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return matchingItem.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItem[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }

//    MARK- Adding placemark address (street, state)
     func parseAddress(selectedItem: MKPlacemark) -> String {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " ": ""
        //comma between street and state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
       //put space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " ": ""
        let addressLine = String(format: "%@%@%@%@%@%@%@", selectedItem.subThoroughfare ?? "", firstSpace, selectedItem.thoroughfare ?? "", comma, selectedItem.locality ?? "", secondSpace, selectedItem.administrativeArea ?? "")
        
        return addressLine
    }

//    MARK- Did select row function
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItem[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }

}


//MARK- Search function
extension LocationSearchTable: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return}
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                return
            }
            self.matchingItem = response.mapItems
            self.tableView.reloadData()
        }
    }
}

