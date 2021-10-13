//
//  LocationViewController.swift
//  LocationViewController
//
//  Created by zhgchgli on 2021/8/27.
//

import MapKit
import UIKit
import CoreLocation
import CoreLocationUI

class LocationViewController: UIViewController {
    
    @IBOutlet weak var askingPermissionButton: UIButton!
    @IBOutlet weak var permissionStatusLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var getCurrentLocationButton: UIButton!
    
    private lazy var locationButton: CLLocationButton = {
        let locationButton = CLLocationButton()
        locationButton.icon = .arrowFilled
        locationButton.label = .currentLocation
        locationButton.cornerRadius = 5.0
        locationButton.addTarget(self, action: #selector(userPressedLocationButton), for: .touchUpInside)
        return locationButton
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.askingPermissionButton.addTarget(self, action: #selector(userPressedAskingPermissionButton), for: .touchUpInside)
        self.getCurrentLocationButton.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
        self.view.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        let bottom = NSLayoutConstraint(item: locationButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -150)
        let right = NSLayoutConstraint(item: locationButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -50)
        NSLayoutConstraint.activate([bottom, right])
        updatePermission()
    }
    
    private func updatePermission() {
        switch locationManager.authorizationStatus {
        case .authorized:
            self.permissionStatusLabel.text = "authorized"
        case .notDetermined:
            self.permissionStatusLabel.text = "notDetermined"
        case .restricted:
            self.permissionStatusLabel.text = "restricted"
        case .denied:
            self.permissionStatusLabel.text = "denied"
        case .authorizedAlways:
            self.permissionStatusLabel.text = "authorizedAlways"
        case .authorizedWhenInUse:
            self.permissionStatusLabel.text = "authorizedWhenInUse"
        @unknown default:
            self.permissionStatusLabel.text = "@unknown"
        }
    }
    
    @objc private func userPressedLocationButton(_ sender: Any) {
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    @objc private func getCurrentLocation(_ sender: Any) {
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    @objc private func userPressedAskingPermissionButton(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
    }
    
}

extension LocationViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updatePermission()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        DispatchQueue.main.async {
            self.mapView.setRegion(MKCoordinateRegion(center: locValue, span: MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)), animated: true)
        }
    }
}
