//
//  PlacesViewController.swift
//  Memorable Places App
//
//  Created by Michael Mirochnik on 3/26/18.
//  Copyright © 2018 MishkaMac. All rights reserved.
//

import UIKit
import MapKit

class PlacesViewController: UITableViewController {

    var placesArray = UserDefaults.standard.object(forKey: "array") as? [[Any]]
    
    @IBOutlet var table: UITableView!
    
    var latitudeOfSelectedPlace = CLLocationDegrees()
    var longitudeOfSelectedPlace = CLLocationDegrees()

    var activeRow: Int? = nil
    
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let placesArrayCount = placesArray?.count {
        return placesArrayCount
        }
        else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = placesArray?[indexPath.row][0] as? String
        return cell
        
    }

    
    override func viewDidAppear(_ animated: Bool) { //THIS FUNCTION RELOADS THE TABLE WHEN YOU GO BACK TO IT FROM THE MAP, INCLUDING AFTER DROPPING A NEW PIN/ANNOTATION ON THE MAP.
        
        placesArray = UserDefaults.standard.object(forKey: "array") as? [[Any]]
        table.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            placesArray?.remove(at: indexPath.row)
        }
        
        
        UserDefaults.standard.set(placesArray, forKey: "array")
        table.reloadData()
        
    }
    
    
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if placesArray?.isEmpty == false {
            
        latitudeOfSelectedPlace = placesArray?[indexPath.row][1] as! CLLocationDegrees
        longitudeOfSelectedPlace = placesArray?[indexPath.row][2] as! CLLocationDegrees
        
        activeRow = indexPath.row
        
        performSegue(withIdentifier: "cellSegueToMap", sender: nil)
        
        
    }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cellSegueToMap" {
            
            let mapViewController = segue.destination as! MapViewController
            
            mapViewController.latitude = latitudeOfSelectedPlace
            mapViewController.longitude = longitudeOfSelectedPlace
            
            mapViewController.activePlacesTableRow = activeRow
            
            
        }
        
    }
    


    
   

}
