//
//  MapViewController.swift
//  Memorable Places App
//
//  Created by Michael Mirochnik on 3/26/18.
//  Copyright © 2018 MishkaMac. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var placesArray = [[Any]]()
    
    @IBOutlet weak var map: MKMapView!
    
    var latitude: CLLocationDegrees = 40.709212
    var longitude: CLLocationDegrees = -74.017348 // The latitude and longitude values will change based on the segue from PlacesVC to MapsVC to center map on the coordinates of the addresses that is clicked in the places table.
    
//    var annotationArrayIndex: Int? = nil
    
    var activePlacesTableRow: Int? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesArray = UserDefaults.standard.object(forKey: "array") as! [[Any]] // placesArray is an array or arrays
        print("this is the array stored last time")
        print(placesArray)
        
        
        //THIS FOR LOOP IS USED TO SET ANNOTATIONS FOR ALL OF THE MEMORABLE PLACES IN THE PLACESARRAY
        if placesArray.isEmpty == false {
            if activePlacesTableRow != nil { // I CREATED THIS IF STATEMENT BECAUSE I WANTED THE ANNOTATION TO AUTO-SELECT AND DISPLAY THE NAME OF THE PLACE ON THE MAP WHEN I SELECTED IT IN THE TABLE.  AS PART OF THIS PROCESS, I INCLUDED IN THE PLACESVC THE SEGUE THAT UPDATES THE VARIABLE "activePlacesTableRow" IN THE MAPVC.
                placesArray.remove (at: activePlacesTableRow!)
                for singleLocation in placesArray {
                    let singleLocationAnnotation = MKPointAnnotation()
                    let singleLocationCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: singleLocation[1] as! CLLocationDegrees, longitude: singleLocation[2] as! CLLocationDegrees) // this sets the annotation coordinates to the latitude and longitude included in an array (in position 1 and 2, respectively) of the placesArray
                    singleLocationAnnotation.coordinate = singleLocationCoordinates
                    singleLocationAnnotation.title = singleLocation[0] as? String // this sets the title of the annotation to the addressLineOne included in an array (in position 0) of the placesArray
                    map.addAnnotation(singleLocationAnnotation)
            }
                
                placesArray = UserDefaults.standard.object(forKey: "array") as! [[Any]]
                let reinsertedSingleLocationArray = placesArray[activePlacesTableRow!]
                let reinsertedSingleLocationAnnotation = MKPointAnnotation()
                let reinsertedSingleLocationCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D (latitude: reinsertedSingleLocationArray[1] as! CLLocationDegrees, longitude: reinsertedSingleLocationArray[2] as! CLLocationDegrees)
                reinsertedSingleLocationAnnotation.coordinate = reinsertedSingleLocationCoordinates
                reinsertedSingleLocationAnnotation.title = reinsertedSingleLocationArray[0] as? String
                map.addAnnotation(reinsertedSingleLocationAnnotation)
                map.selectAnnotation(reinsertedSingleLocationAnnotation, animated: true) // THIS IS USED TO AUTO-SELECT THE ANNOTATION COORESPONDING TO THE PLACE THAT WAS CLICKED ON THE TABLE.
                
                
            } else {
                
        for singleLocation in placesArray {
            let singleLocationAnnotation = MKPointAnnotation()
            let singleLocationCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: singleLocation[1] as! CLLocationDegrees, longitude: singleLocation[2] as! CLLocationDegrees) // this sets the annotation coordinates to the latitude and longitude included in an array (in position 1 and 2, respectively) of the placesArray
            singleLocationAnnotation.coordinate = singleLocationCoordinates
            singleLocationAnnotation.title = singleLocation[0] as? String // this sets the title of the annotation to the addressLineOne included in an array (in position 0) of the placesArray
            map.addAnnotation(singleLocationAnnotation)
            }
            }
        }
        
//        print()
//        print()
//        print()
//        print()
//        print(map.annotations)
//        print()
//        print()
//        print()
//        print()
        
//        if annotationArrayIndex != nil {
//        map.selectAnnotation(map.annotations[annotationArrayIndex!], animated: true) // Got this from online.  This is supposed to automatically show the annotation title.  "map.annotations" is an array.
//            print(map.annotations)
//        } // This doesn't seem to be working because the annotations array spits out random MKPointAnnotation codes everytime.
        
        
        
        //Initial maps set up for when the screen loads
        map.showsUserLocation = true
        //latitude and longitude are included above and the segue from PlacesVC to MapsVC updates them so that the maps centers on the coordinates of the address that is clicked in the places table.
        let mapLatitude = latitude
        let mapLongitude = longitude
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: mapLatitude, longitude: mapLongitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinates, span: span)
        map.setRegion(region, animated: true)
        
        
//        //Adding Annotations to the Map (by the coder):
//        let annotation = MKPointAnnotation()
//        annotation.title = "Battery Pointe"
//        annotation.subtitle = "This is 300 Rector Place"
//        annotation.coordinate = coordinates // This "coordinates" is our coordinates variable above.
//        map.addAnnotation(annotation)
        
        
        //Allowing User to add annotations to the map:
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longpress(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 2 // 2 second press is defined as a long press
        map.addGestureRecognizer(uilpgr) // This allows the map to be updated by the UILongPressGestureRecognizer
        
        
    
    }
    
    
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began { //This is important because the gesture recognizer runs when the gesture begins and when it ends (so it runs twice and this is what was giving me so much trouble here).  By using this conditional, it forces the program to only run once at the time that the gesture registers (here that happens at the holding the screen down for 2 seconds).  An alternative would be to run it only when the gesture ends, which would be "if gestureRecognizer.state == UIGestureRecognizerState.ended".
        
        
        let touchPoint = gestureRecognizer.location(in: self.map)
        let mapCoordinates = map.convert(touchPoint, toCoordinateFrom: self.map)
//        print (mapCoordinates)
        let mapCoordinatesLatitude = mapCoordinates.latitude
//        print(mapCoordinatesLatitude)
        let mapCoordinatesLongitude = mapCoordinates.longitude
//        print(mapCoordinatesLongitude)
        
        
        let location = CLLocation(latitude: mapCoordinatesLatitude, longitude: mapCoordinatesLongitude)
//        print(location)
        
        var address = ""
        var landmark = ""
        
        
       CLGeocoder().reverseGeocodeLocation(location) {  (placemarks, error) in
            if error != nil {
                print(error!)
                
            } else {
                
                if let placemark = placemarks?[0] {
                    if placemark.subThoroughfare != nil {
                        address += placemark.subThoroughfare! + " "
                    }
                    if placemark.thoroughfare != nil {
                        address += placemark.thoroughfare! + "\n"
                    }
                    if placemark.subLocality != nil {
                        address += placemark.subLocality! + "\n"
                    }
                    if placemark.subAdministrativeArea != nil {
                        address += placemark.subAdministrativeArea! + "\n"
                    }
                    if placemark.postalCode != nil {
                        address += placemark.postalCode! + "\n"
                    }
                    if placemark.country != nil {
                        address += placemark.country!
                    }
                    if placemark.areasOfInterest != nil {
                        if placemark.areasOfInterest!.count > 1 {
                            landmark = placemark.areasOfInterest![0]
                            address = landmark + "\n" + address
                        }
                    }
                    
                    print(address)
                    
                    let addressNSString = address as NSString
                    let addressNSStringArray = addressNSString.components(separatedBy: "\n")
                    print(addressNSStringArray)
                    let addressFirstLine = addressNSStringArray[0]
                    print(addressFirstLine)
                    
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = mapCoordinates
                    annotation.title = addressFirstLine
                    self.map.addAnnotation(annotation)
                    print("here is the annotation:")
                    print(annotation)
                    
                    
                    UserDefaults.standard.set(addressFirstLine, forKey: "address")
                    UserDefaults.standard.set(mapCoordinatesLatitude, forKey: "latitude")
                    UserDefaults.standard.set(mapCoordinatesLongitude, forKey: "longitude")
                    
                    let addressObject = UserDefaults.standard.object(forKey: "address")
                    if let addressString = addressObject as? String {
                        print(addressString)
                    }
                    
                    let latitudeObject = UserDefaults.standard.object(forKey: "latitude")
                    if let latitudeDegrees = latitudeObject as? CLLocationDegrees {
                        print("\(latitudeDegrees)")
                    }
                    
                    let longitudeObject = UserDefaults.standard.object(forKey: "longitude")
                    if let longitudeDegrees = longitudeObject as? CLLocationDegrees {
                        print("\(longitudeDegrees)")
                    }

                    
                    
                    self.placesArray.append([addressFirstLine, mapCoordinatesLatitude, mapCoordinatesLongitude])
                    print(self.placesArray)
                    UserDefaults.standard.set(self.placesArray, forKey: "array")
                    
        
                    
                    }
                }
            }
        }
        
        

        
        

        
        
        
    }
    



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

//testingbranch123








