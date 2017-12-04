////
////  LocationSearchTable.swift
////  Wanto
////
////  Created by Turner Thornberry on 12/4/17.
////  Copyright © 2017 Turner Thornberry. All rights reserved.
////
//
//import Foundation
//import UIKit
//import MapKit
//
//
//class LocationSearchTable: UITableViewController, UISearchBarDelegate{
//    
//    var resultsSearchController: UISearchController?
//    
//    var matchingItems:[MKMapItem] = []
//    var mapView: MKMapView?
//
//
//    
//    override func viewDidLoad() {
//        resultsSearchController = UISearchController(searchResultsController: s)
//        resultsSearchController?.searchResultsUpdater = self
//        let searchBar = resultsSearchController!.searchBar
//        searchBar.sizeToFit()
//        searchBar.placeholder = "Search for places"
//        navigationItem.titleView = resultsSearchController?.searchBar
//        resultsSearchController?.hidesNavigationBarDuringPresentation = false
//        resultsSearchController?.dimsBackgroundDuringPresentation = true
//        definesPresentationContext = true
//        
//        print("The Map view is: \(mapView)")
//        
//        
////        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
////        resultsSearchController = UISearchController(searchResultsController: locationSearchTable)
////        resultsSearchController?.searchResultsUpdater = locationSearchTable
////        let searchBar = resultsSearchController!.searchBar
////        searchBar.sizeToFit()
////        searchBar.placeholder = "Search for places"
////        navigationItem.titleView = resultsSearchController?.searchBar
////        resultsSearchController?.hidesNavigationBarDuringPresentation = false
////        resultsSearchController?.dimsBackgroundDuringPresentation = true
////        definesPresentationContext = true
////        print("the map view is: \(mapView)")
//    }
//    
//    
//    
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        guard let mapView = mapView,
//            let searchBarText = searchController.searchBar.text else { return }
//        let request = MKLocalSearchRequest()
//        request.naturalLanguageQuery = searchBarText
//        request.region = mapView.region
//        let search = MKLocalSearch(request: request)
//        search.start { response, _ in
//            guard let response = response else {
//                return
//            }
//            self.matchingItems = response.mapItems
//            self.tableView.reloadData()
//        }
//    }
//    
//    
//    
//    
//}
//
//
//extension LocationSearchTable : UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        
//    }
//}
//
//extension LocationSearchTable {
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return matchingItems.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
//        let selectedItem = matchingItems[indexPath.row].placemark
//        cell.textLabel?.text = selectedItem.name
//        cell.detailTextLabel?.text = ""
//        return cell
//    }
//}
//
