//
//  FirstViewController.swift
//  MyLocations
//
//  Created by tangyuhua on 2016/10/29.
//  Copyright © 2016年 tangyuhua. All rights reserved.
//

import UIKit

class CurrentLocationViewController: UIViewController {
    
    @IBOutlet weak var messageLable: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!

    @IBAction func getLocation() { // do nothing yet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

