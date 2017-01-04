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
    @IBOutlet weak var directionDescriptionLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 13.0
    let directionsBasicURL = "https://maps.googleapis.com/maps/api/directions/json?"
    let googleMapsAPIKey = "AIzaSyDNkeUKOzjTcXzAubHnDdK__C38PLKbrYg"
    var timerTask = Timer()
    var source: CLLocationCoordinate2D!
    var destination: CLLocationCoordinate2D!
    var polyline = GMSPolyline()
    var latitude = 19.075
    var longitude = 72.877
    var stepNumber = 0
    
    var client: PubNub!
    let pubNubPublishKey = "pub-c-308bbb9a-0885-4ca5-9777-8be042e62b5f"
    let pubNubSubscribeKey = "sub-c-f9b77b14-d196-11e6-979a-02ee2ddab7fe"
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var subView: UIView!
    
    var marker: GMSMarker!
    var markers = [String: GMSMarker]()
    var routes: [String: AnyObject]!
    var numberOfSteps: Int!
    var seconds: Int!
    var meters: Int!

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
        
        mapDisplayView.camera = camera
        
        setupPubNubNotifications()
        
        setupResultsViewController()
        customButton.isEnabled = false
        
        arrivalProgressLabel.isHidden = true
        directionDescriptionLabel.isHidden = true
    }
    
    func setupPubNubNotifications() {
        let configuration = PNConfiguration(publishKey: pubNubPublishKey, subscribeKey: pubNubSubscribeKey)
        self.client = PubNub.clientWithConfiguration(configuration)
        self.client.addListener(self)
        self.client.subscribeToChannels(["locationUpdate"], withPresence: false)
    }
    
    func setupResultsViewController() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        subView = UIView(frame: CGRect(x: 0, y: 20, width: view.bounds.width, height: 45.0))
        subView.tag = 100
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true
    }
    
    func getDirections(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let originLocation = "origin=\(origin.latitude),\(origin.longitude)"
        let destinationLocation = "&destination=\(destination.latitude),\(destination.longitude)"
        let url = URL(string: directionsBasicURL + originLocation + destinationLocation + "&key=" + googleMapsAPIKey)
        
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) {
            data, response, error in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .init(rawValue: 0)) as? Dictionary<String, AnyObject> {
                    self.routes = jsonResult["routes"]![0] as! [String: AnyObject]
                    let polyLinePoints = self.routes["overview_polyline"]?["points"] as! String
                    
                    let legs = self.routes["legs"]![0] as! [String: AnyObject]
                    let duration = legs["duration"]!["text"] as! String
                    let distance = legs["distance"]!["text"] as! String
                    
                    self.seconds = legs["duration"]!["value"] as! Int
                    self.meters = legs["distance"]!["value"] as! Int
                    
                    let steps = legs["steps"] as! [AnyObject]
                    self.numberOfSteps = steps.count
                    
                    DispatchQueue.main.async {
                        self.directionDescriptionLabel.text = "\t\(duration) (\(distance))"
                    }
                    self.directionDescriptionLabel.isHidden = false
                    
                    if polyLinePoints != "" {
                        DispatchQueue.main.async {
                            self.addPolyLineWithEncodedStringInMap(polyLinePoints)
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
    
    func addPolyLineWithEncodedStringInMap(_ encodedString: String) {
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        
        polyline.path = path
        polyline.strokeColor = .blue
        polyline.strokeWidth = 4.0
        polyline.map = mapDisplayView
    }
    
//    func updateMarkers() {
//        mapDisplayView.clear()
//        placesClient.currentPlace(callback: { (placeLikelihoods, error) in
//            if let error = error {
//                print("Current Place error \(error.localizedDescription)")
//                return
//            }
//            
//            if let likelihoodList = placeLikelihoods {
//                for likelihood in likelihoodList.likelihoods {
//                    let place = likelihood.place
//                    
//                    let marker = GMSMarker(position: place.coordinate)
//                    marker.title = place.name
//                    marker.snippet = place.formattedAddress
//                    marker.icon = UIImage(named: "mapMarker")
//                    marker.map = self.mapDisplayView
//                }
//            }
//        })
//    }
    
    func changeUserLocation(_ newLocation: CLLocationCoordinate2D) {
        if let userLocationMarker = markers["userLocation"] {
            userLocationMarker.position = newLocation
        }
    }
    
    // MARK: PubNub Subscription
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        let receivedMessage = message.data.message as! [String : Double]
        
        //self.getDirections(origin: CLLocationCoordinate2D(latitude: receivedMessage["lat"]!, longitude: receivedMessage["lng"]!), destination: CLLocationCoordinate2D(latitude: 26.912, longitude: 75.787))
        changeUserLocation(CLLocationCoordinate2D(latitude: receivedMessage["lat"]!, longitude: receivedMessage["lng"]!))
    }

    // MARK: Actions
    @IBAction func showDirectionsButtonAction(_ sender: UIButton) {
        if sender.currentTitle == "Show Directions" {
            source = mapDisplayView.myLocation!.coordinate
            getDirections(origin: source, destination: destination)
            
            sender.setTitle("Start Ride", for: .normal)
            stepNumber = 0
        } else if sender.currentTitle == "Start Ride" {
            view.viewWithTag(100)?.removeFromSuperview()
            directionDescriptionLabel.isHidden = true
            
            let legs = self.routes["legs"]![0] as! [String: AnyObject]
            let duration = legs["duration"]!["text"] as! String
            
            DispatchQueue.main.async {
                self.arrivalProgressLabel.text = "\t\(duration)"
            }
            arrivalProgressLabel.isHidden = false
            
            sender.setTitle("Stop Ride", for: .normal)
            
            timerTask = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: {_ in
                let step = legs["steps"]![self.stepNumber] as! [String: AnyObject]
                let endLocation = step["end_location"] as! [String: Double]
                self.latitude = endLocation["lat"]!
                self.longitude = endLocation["lng"]!
                
                let stepDuration = step["duration"]!["value"] as! Int
                self.seconds = self.seconds - stepDuration
                
                let stepDistance = step["distance"]!["value"] as! Int
                self.meters = self.meters - stepDistance
                
                let instructions = step["html_instructions"]! as! String
                
                do {
                    let ins = try NSAttributedString(data: instructions.data(using: String.Encoding.utf8)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                    
                    DispatchQueue.main.async {
                        self.arrivalProgressLabel.text = "\t" + self.durationCalculate(self.seconds) + ", for " + self.distanceCalculate(stepDistance) + "\n\t" + ins.string
                    }
                } catch {
                    print("Error in parsing HTML Instruction")
                }
                
                self.stepNumber = self.stepNumber + 1
                
                let message = "{\"lat\":\(self.latitude),\"lng\":\(self.longitude)}"
                self.client.publish(message, toChannel: self.client.channels().last!, compressed: true, withCompletion: nil)
                
                if self.stepNumber == self.numberOfSteps {
                    self.arrivalProgressLabel.text = "You have reached your destination"
                    self.timerTask.invalidate()
                }
            })
        } else if sender.currentTitle == "Stop Ride" {
            timerTask.invalidate()
            view.addSubview(subView)
            sender.setTitle("Start Ride", for: .normal)
        }
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
        
        if let marker = markers["userLocation"] {
            marker.position = location.coordinate
        } else {
            marker = GMSMarker(position: location.coordinate)
            marker.icon = UIImage(named: "mapMarker")
            marker.map = mapDisplayView
            
            markers["userLocation"] = marker
        }
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
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        polyline.map = nil
        
        if let destinationMarker = markers["destination"] {
            destinationMarker.position = place.coordinate
            destinationMarker.snippet = place.formattedAddress
            destinationMarker.title = place.name
        } else {
            marker = GMSMarker()
            marker.position = place.coordinate
            marker.snippet = place.formattedAddress
            marker.title = place.name
            marker.icon = UIImage(named: "mapMarker")
            marker.map = self.mapDisplayView
            
            markers["destination"] = marker
        }
        
        
        mapDisplayView.animate(toLocation: place.coordinate)
        customButton.isEnabled = true
        customButton.setTitle("Show Directions", for: .normal)
        destination = place.coordinate
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
    
    // MARK: Helper Functions
    func distanceCalculate(_ meters: Int) -> String {
        let kms = Double(meters) / 1000.0
        
        if kms < 1 {
            return "\(meters) meters"
        } else {
            return "\(kms) Kms"
        }
    }
    
    func durationCalculate(_ seconds: Int) -> String {
        let hrs = seconds / 3600
        let mins = (seconds % 3600) / 60
        
        if hrs == 0 {
            return "\(mins) minutes"
        } else {
            return "\(hrs) hours and \(mins) minutes"
        }
    }

}

