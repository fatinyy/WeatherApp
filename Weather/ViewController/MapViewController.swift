//
//  MapViewController.swift
//  Weather
//
//  Created by aifara on 11/03/2024.
//

import Foundation
import MapKit
import UIKit




class MapViewController:UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    let scale: CGFloat = 300
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        
        // Set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)

    }
 
    
    private func centerViewOnUserLocation() {
     if let coordinate = locationManager.location?.coordinate {
      let region = MKCoordinateRegion.init(center: coordinate,
                                           latitudinalMeters: scale,
                                           longitudinalMeters: scale)
            mapView.setRegion(region, animated: true)
        }
    }



}


// MARK: - CLLocationManagerDelegate
extension MapViewController :CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
        centerViewOnUserLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension MapViewController:MKMapViewDelegate{
    
    
}



