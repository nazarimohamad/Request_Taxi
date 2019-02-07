//
//  LocationSearchTable.swift
//  Uber
//
//  Created by Ryan Nazari on 2/7/19.
//  Copyright © 2019 Ryan Nazari. All rights reserved.
//

import MapKit

class LocationSearchTable: UITableViewController {

    var matchingItem: [MKMapItem] = []
    var mapView: MKMapView? = nil
    
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
        cell.detailTextLabel?.text = ""
        return cell
    }

}



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
