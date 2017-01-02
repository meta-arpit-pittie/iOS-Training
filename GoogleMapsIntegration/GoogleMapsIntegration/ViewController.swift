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

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapDisplayView: GMSMapView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        
        mapDisplayView.isMyLocationEnabled = true
        mapDisplayView.settings.myLocationButton = true
        mapDisplayView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.map = mapView
        
        mapDisplayView = mapView
    }
    
    func updateMarkers() {
        mapView.clear()
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
                    marker.map = self.mapView
                }
            }
        })
    }

    // MARK: Actions
    @IBAction func showDirectionsButtonAction(_ sender: Any) {
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(19.075),\(72.877)&destination=\(26.912),\(75.787)&key=AIzaSyDNkeUKOzjTcXzAubHnDdK__C38PLKbrYg")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) {
            data, response, error in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .init(rawValue: 0)) as? Dictionary<String, AnyObject> {
                    let routes = jsonResult["routes"]![0] as! [String: AnyObject]
                    let overViewPolyLine = routes["overview_polyline"] as! [String: AnyObject]
                    let polyLinePoints = overViewPolyLine["points"] as! String
                    
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
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .blue
        polyline.strokeWidth = 5.0
        polyline.map = mapView
        
        let smarker = GMSMarker()
        smarker.position = CLLocationCoordinate2D(latitude: 19.075, longitude: 72.877)
        smarker.title = "Lavale"
        smarker.snippet = "Maharshtra"
        smarker.map = mapView
        
        let dmarker = GMSMarker()
        dmarker.position = CLLocationCoordinate2D(latitude: 26.912, longitude: 75.787)
        dmarker.title = "Chakan"
        dmarker.snippet = "Maharshtra"
        dmarker.map = mapView
        
        view = mapView
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
          mapView.animate(to: camera)
        }
        
        updateMarkers()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted")
        case .denied:
            print("User deneid the access to location")
            mapView.isHidden = false
        case .notDetermined:
            print("Location status was not determined")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error.localizedDescription)")
    }

}

