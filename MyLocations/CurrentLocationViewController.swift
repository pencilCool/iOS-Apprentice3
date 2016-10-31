//
//  FirstViewController.swift
//  MyLocations
//
//  Created by tangyuhua on 2016/10/29.
//  Copyright © 2016年 tangyuhua. All rights reserved.
//

/*

 
 */


import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController,CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager()
    
    // You will store the user’s current location in this variable.
    var location :CLLocation?
    var updatingLocation = false
    var lastLocationError: NSError?
    
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
    
    var timer: Timer?
    
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    
    

    @IBAction func getLocation() { // do nothing yet
    
        let authStatus = CLLocationManager.authorizationStatus()
        // 以前没有获取过权限，则获取权限
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            // 当用的时候获取权限，always：app没有活动起来也有权限
            // app 没有删除的时候，这个逻辑总共只跑一次，删除simulator中的app ，重新编译app启动的时候才会又触发这里。
            return
        }
        
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
        
        if authStatus == .denied || authStatus == .restricted { showLocationServicesDeniedAlert()
            return
        }
        
        
//        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        locationManager.startUpdatingLocation()
        
        startLocationManager()
        updateLabels()
        configureGetButton()
        
        
    }
    
    
//    The CLLocationManager is the object that will give you the GPS coordinates. You’re putting the reference to this object in a constant (using let), not a variable (var). Once you have created the location manager object, the value of locationManager will never have to change.
//   
    
 

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        updateLabels();
        configureGetButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
        updateLabels()
        configureGetButton()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
        // 1 
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return //  为什么是 -5
        }
        //2
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        
        
        var distance = CLLocationDistance(DBL_MAX)
        
        if let location = location {
            distance = newLocation.distance(from: location)
        }
        
        
        //3
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            
            // 4
            lastLocationError = nil
            location = newLocation
            updateLabels()
            
            // 5
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We're done!")
                stopLocationManager()
                configureGetButton()
                
                
                if distance > 0 {
                    performingReverseGeocoding = false
                }
            }
            
            // The new code begins here:
            if !performingReverseGeocoding {
                print("*** Going to geocode")
                performingReverseGeocoding = true
                geocoder.reverseGeocodeLocation(newLocation, completionHandler: {
                    placemarks, error in
                    print("*** Found placemarks: \(placemarks), error: \(error)")
                    
                    self.lastGeocodingError = error
                    if error == nil, let p = placemarks , !p.isEmpty {
                        // 源代码是 if error == nil, let p = placemarks where !p.isEmpty 
                        // 这个编译器报错了。自动把where 变成了逗号
                        
                        // 一个坐标可能有很多地名，虽然通常只有一个，我们去名字数组placemarks 的最后一个地名。
                        self.placemark = p.last!
                    } else {
                        self.placemark = nil
                    }
                    self.performingReverseGeocoding = false
                    self.updateLabels() // 在closure中需要带上self
                })
            }
            
            
          
            
        } else if distance < 1.0 {
            let timeInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
            
                if timeInterval > 10 {
                print("*** Force done!")
                stopLocationManager()
                updateLabels()
                configureGetButton()
                
            }
        }

    }
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message:
            "Please enable location services for this app in Settings.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default,
                                     handler: nil)
        present(alert, animated: true, completion: nil)
        alert.addAction(okAction)
    }
    
    
    func updateLabels() {
        if let location = location {
            latitudeLabel.text =
                String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text =
                String(format: "%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
            
            if let placemark = placemark {
                addressLabel.text = stringFromPlacemark(placemark: placemark)
            } else if performingReverseGeocoding {
                addressLabel.text = "Searching for Address..."
            } else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
            } else {
                addressLabel.text = "No Address Found"
            }
            
            
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            
            // 错误处理功能
            let statusMessage: String
            if let error = lastLocationError {
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() { statusMessage = "Location Services Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to Start"
            }
            
            
            messageLabel.text = statusMessage
           
        }
    }

    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError \(error)")
// • CLError.locationUnknown - The location is currently unknown, but Core Location will keep trying.
// • CLError.denied - The user declined the app to use location services.
// • CLError.network - There was a network-related error.

        if error.code == CLError.locationUnknown.rawValue {
            return//只是暂时收不到定位信号，说不定等下就好了，不是什么了不得的错误，不作处理
        }
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(CurrentLocationViewController.didTimeOut), userInfo: nil, repeats: false)
            
        }
    }
    // 不在当地而，而是出了服务区,要能关闭location Manager，为了节省电池还要能关闭无线功能
    func stopLocationManager() {
        if updatingLocation {
            
            if let timer = timer {
                
                timer.invalidate()
            }
            
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    
      func configureGetButton() {
        if updatingLocation {
        getButton.setTitle("Stop", for: .normal)
        } else {
        getButton.setTitle("Get My Location", for: .normal) }
    }
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        // 1
        var line1 = ""
        // 2
        if let s = placemark.subThoroughfare {
            line1 += s + " "
        }
        // 3
        if let s = placemark.thoroughfare {
            line1 += s
        }
        // 4
        var line2 = ""
        if let s = placemark.locality {
            line2 += s + " "
        }
        if let s = placemark.administrativeArea {
            line2 += s + " "
       
        }
        if let s = placemark.postalCode {
            line2 += s
        }
        // 5
        return line1 + "\n" + line2
    }
    
    
    func didTimeOut() {
        print("*** Time out")
        if location == nil {
            stopLocationManager()
            lastLocationError = NSError(domain: "MyLocationsErrorDomain", code: 1, userInfo: nil)
            updateLabels()
            configureGetButton()
        }
    }
}

