//
//  FirstViewController.swift
//  MyLocations
//
//  Created by tangyuhua on 2016/10/29.
//  Copyright © 2016年 tangyuhua. All rights reserved.
//

/*切换设置中locationserver 下mylocation app的 never 和 while using the app 出现：
didFailWithError Error Domain=kCLErrorDomain Code=1 "(null)"
*/

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController,CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager()
    
    
    
    @IBOutlet weak var messageLable: UILabel!
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
        
        if authStatus == .denied || authStatus == .restricted { showLocationServicesDeniedAlert()
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
    }
    
    
//    The CLLocationManager is the object that will give you the GPS coordinates. You’re putting the reference to this object in a constant (using let), not a variable (var). Once you have created the location manager object, the value of locationManager will never have to change.
//   
    
 

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
    }
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message:
            "Please enable location services for this app in Settings.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default,
                                     handler: nil)
        present(alert, animated: true, completion: nil)
        alert.addAction(okAction) }
}

