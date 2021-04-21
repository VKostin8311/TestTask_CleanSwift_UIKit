//
//  ViewController.swift
//  TestTask_CleanSwift_UIKit
//
//  Created by Владимир Костин on 14.04.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var objectID: UILabel!
    @IBOutlet weak var diameter: UILabel!
    @IBOutlet weak var rVelocity: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var magnitude: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var hazardous: UILabel!
    @IBOutlet weak var sentry: UILabel!
    
    var nameText: String?
    var idText: String?
    var diamText: String?
    var velocityText: String?
    var distText: String?
    var magnText: String?
    var dateText: String?
    var hazarText: String?
    var sentryText: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.name.text = self.nameText
        self.objectID.text = self.idText
        self.diameter.text = self.diamText
        self.rVelocity.text = self.velocityText
        self.distance.text = self.distText
        self.magnitude.text = self.magnText
        self.date.text = self.dateText
        self.hazardous.text = self.hazarText
        self.sentry.text = self.sentryText
    }
}
