//
//  FlightDetails.swift
//  FlightRadar
//
//  Created by Jakub Nykiel on 18.05.2017.
//  Copyright © 2017 Jakub Nykiel. All rights reserved.
//

import UIKit

class FlightDetails: UIViewController {

    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var airlinesLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var groundSpeedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
