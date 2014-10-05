//
//  FirstViewController.swift
//  Help
//
//  Created by demo on 9/28/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager : CLLocationManager!
    
    var latitudeData: [Float] = []
    var longitudeData: [Float] = []
    var distanceData: [Float] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //var addLocation : PFObject = PFObject(className: "PeopleLocation")
        
        //self.locationManager = CLLocationManager()
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //self.locationManager.delegate = self
        
        
        //Setting other variables in the PFObject
        //addLocation["Latitude"] = 40.50
        //addLocation["Longitude"] = 50.22014
       // addLocation.saveInBackground()
        loadNewData()
    }

    
        func loadNewData()
        {
            var query = PFQuery(className: "PeopleLocation")
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error:NSError!) -> Void in
                if error == nil {
                    if (self.latitudeData.count > 0 || self.longitudeData.count > 0)
                    {
                        self.latitudeData.removeAll(keepCapacity: false)
                        self.longitudeData.removeAll(keepCapacity: false)

                    }
                    
                    for object in objects{
                        var longitude: Float = object.objectForKey("Longitude") as Float
                        self.longitudeData.append(longitude)
                        
                        var latitude: Float = object.objectForKey("Latitude") as Float
                        self.latitudeData.append(latitude)
                        
                        let distanceCalc = DistanceCalculator(lat1: 54.3 , lat2: latitude, lon1: 65.43 , lon2: longitude)
                        
                        self.distanceData.append(distanceCalc.calculateDistance())
                    }
                    
                }

    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        // Most recent updates are appended to end of array,
        // so find the most recent update in last index.
        var loc : CLLocation = locations?[locations.count - 1] as CLLocation
        
        // The location stored as a coordinate.
        var coord : CLLocationCoordinate2D = loc.coordinate
        
        // Set the location label to the coordinates of location.
        var myLatitude: String = "\(coord.latitude)"
        var myLongitude: String = "\(coord.longitude)"
        
        // Tell location manager to stop collecting and updating location.
        self.locationManager.stopUpdatingLocation()
            }
    
    //override func didReceiveMemoryWarning() {
      //  super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    //}


}
}

