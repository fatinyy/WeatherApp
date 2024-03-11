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
    
    var draggableAnnotation: MKPointAnnotation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        mapView.showsUserLocation = true
    }
 
    @IBAction func closeButtonPressed(_ sender: UIButton) {
       dismiss(animated: true)
    }
    
    private func centerViewOnUserLocation() {
        
        if let coordinate = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: coordinate,
                                            latitudinalMeters: scale,
                                            longitudinalMeters: scale)
            mapView.setRegion(region, animated: true)

            if let existingAnnotation = draggableAnnotation {
                mapView.removeAnnotation(existingAnnotation)
            }

            // Add new draggable annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Current Location"
            mapView.addAnnotation(annotation)

            draggableAnnotation = annotation
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

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "draggableAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.isDraggable = true
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            // Update the annotation's coordinate after dragging ends
            if let annotation = view.annotation as? MKPointAnnotation {
                annotation.coordinate = view.annotation!.coordinate
            }
        }
    }
}



