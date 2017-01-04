//
//  ViewController.swift
//  GoogleMapsIntegration
//
//  Created by Arpit Pittie on 29/12/16.
//  Copyright © 2016 Metacube. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import PubNub

class ViewController: UIViewController, CLLocationManagerDelegate, PNObjectEventListener, GMSAutocompleteResultsViewControllerDelegate {
    
    @IBOutlet weak var mapDisplayView: GMSMapView!
    @IBOutlet weak var arrivalProgressLabel: UILabel!
    @IBOutlet weak var customButton: UIButton!
    
    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    let directionsBasicURL = "https://maps.googleapis.com/maps/api/directions/json?"
    let googleMapsAPIKey = "AIzaSyDNkeUKOzjTcXzAubHnDdK__C38PLKbrYg"
    var timerTask = Timer()
    
    var client: PubNub!
    let pubNubPublishKey = "pub-c-308bbb9a-0885-4ca5-9777-8be042e62b5f"
    let pubNubSubscribeKey = "sub-c-f9b77b14-d196-11e6-979a-02ee2ddab7fe"
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        placesClient = GMSPlacesClient.shared()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: zoomLevel)
        
        mapDisplayView.isMyLocationEnabled = true
        mapDisplayView.settings.myLocationButton = true
        mapDisplayView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.map = mapDisplayView
        
        mapDisplayView.camera = camera
        
        setupPubNubNotifications()
        
        setupResultsViewController()
    }
    
    func setupPubNubNotifications() {
        let configuration = PNConfiguration(publishKey: pubNubPublishKey, subscribeKey: pubNubSubscribeKey)
        self.client = PubNub.clientWithConfiguration(configuration)
        self.client.addListener(self)
        self.client.subscribeToChannels(["locationUpdate"], withPresence: false)
    }
    
    func setupArrivalLabel() {
        arrivalProgressLabel.alpha = 0.85
        arrivalProgressLabel.font.withSize(24)
    }
    
    func setupResultsViewController() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 20, width: view.bounds.width, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true
    }
    
    func getDirections(_ origin: CLLocationCoordinate2D, _ destination: CLLocationCoordinate2D) {
        if origin.latitude >= 26.912 {
            timerTask.invalidate()
            view.removeFromSuperview()
        }
        
        let originLocation = "origin=\(origin.latitude),\(origin.longitude)"
        let destinationLocation = "&destination=\(destination.latitude),\(destination.longitude)"
        let url = URL(string: directionsBasicURL + originLocation + destinationLocation + "&key=" + googleMapsAPIKey)
        
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) {
            data, response, error in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .init(rawValue: 0)) as? Dictionary<String, AnyObject> {
                    let routes = jsonResult["routes"]![0] as! [String: AnyObject]
                    let polyLinePoints = routes["overview_polyline"]?["points"] as! String
                    
                    let legs = routes["legs"]![0] as! [String: AnyObject]
                    let duration = legs["duration"]!["text"] as! String
                    
                    DispatchQueue.main.sync {
                        self.arrivalProgressLabel.text = duration
                    }
                    
                    if polyLinePoints != "" {
                        DispatchQueue.main.async {
                            self.addPolyLineWithEncodedStringInMap(polyLinePoints, origin: origin, destination: destination)
                        }
                    }
                }
            }
            catch {
                print("Something Wrong")
            }
        }
        
        task.resume()
    }
    
    func addPolyLineWithEncodedStringInMap(_ encodedString: String, origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        mapDisplayView.clear()
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .blue
        polyline.strokeWidth = 4.0
        polyline.map = mapDisplayView
        
        let smarker = GMSMarker()
        smarker.position = origin
        smarker.map = mapDisplayView
        
        let dmarker = GMSMarker()
        dmarker.position = destination
        dmarker.map = mapDisplayView
        
        mapDisplayView.animate(toLocation: smarker.position)
    }
    
    func updateMarkers() {
        mapDisplayView.clear()
        placesClient.currentPlace(callback: { (placeLikelihoods, error) in
            if let error = error {
                print("Current Place error \(error.localizedDescription)")
                return
            }
            
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    
                    let marker = GMSMarker(position: place.coordinate)
                    marker.title = place.name
                    marker.snippet = place.formattedAddress
                    marker.map = self.mapDisplayView
                }
            }
        })
    }
    
    // MARK: PubNub Subscription
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        let receivedMessage = message.data.message as! [String : Double]
        
        self.getDirections(CLLocationCoordinate2D(latitude: receivedMessage["lat"]!, longitude: receivedMessage["lng"]!), CLLocationCoordinate2D(latitude: 26.912, longitude: 75.787))
    }

    // MARK: Actions
    @IBAction func showDirectionsButtonAction(_ sender: Any) {
        var latitude = 19.075
        var longitude = 72.877
        getDirections(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), CLLocationCoordinate2D(latitude: 26.912, longitude: 75.787))
        setupArrivalLabel()
        
        mapDisplayView.animate(toZoom: 7.0)
        view.addSubview(arrivalProgressLabel)
        
        timerTask = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            latitude += 0.39851
            longitude += 0.1455
            
            let message = "{\"lat\":\(latitude),\"lng\":\(longitude)}"
            self.client.publish(message, toChannel: self.client.channels().last!, compressed: true, withCompletion: nil)
        })
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: zoomLevel)
        
        if mapDisplayView.isHidden {
            mapDisplayView.isHidden = false
            mapDisplayView.camera = camera
        } else {
          mapDisplayView.animate(to: camera)
        }
        
        updateMarkers()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted")
        case .denied:
            print("User deneid the access to location")
            mapDisplayView.isHidden = false
        case .notDetermined:
            print("Location status was not determined")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
            mapDisplayView.isMyLocationEnabled = true
            mapDisplayView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error.localizedDescription)")
    }
    
    // MARK: GMSAutocompleteResultsViewControllerDelegate
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error){
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}

