//
//  DetailViewController.swift
//  AroundCity
//
//  Created by liuzhihui on 16/8/14.
//  Copyright © 2016年 liuzhihui. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            self.mapView.delegate = self
        }
    }
    @IBOutlet weak var textView: UITextView!
    
    var detailItem: Dictionary<String, String>?
    var locationItems: [CLLocation]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }
    
    func setDetailItem(newDetailItem: Dictionary<String, String>, locationItems:[CLLocation]) {
        if detailItem == nil || detailItem! != newDetailItem {
            detailItem = newDetailItem
        }
        
        if self.locationItems == nil || self.locationItems! != locationItems {
            self.locationItems = locationItems
        }
        
        //update the view
        self.configureView()
    }
    
    func configureView() {
        if let detailItem = detailItem {
            let name = detailItem["name"]
            let address = detailItem["address"]
            let tel = detailItem["tel"]
            let weburl = detailItem["url"]
            let description = "\(name)\n\(address)\nTEL:\(tel)\n\(weburl)"
            self.textView.text = description
            
            let latitude = (detailItem as NSDictionary).valueForKeyPath("coordinates.latitude")
            let longitude = (detailItem as NSDictionary).valueForKeyPath("coordinates.longitude")
            
            let annotation = MKPointAnnotation()
            let loc = CLLocationCoordinate2DMake((latitude as! NSString).doubleValue,(longitude as! NSString).doubleValue)
            annotation.coordinate = loc
            annotation.title = name
            annotation.subtitle = address
            
            self.mapView.addAnnotation(annotation)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        
        }
        
        if let locationItems = locationItems {
            //update the overlay
            self.mapView.removeOverlays(mapView.overlays)
            
            let numberOfSteps = locationItems.count
            
            var coordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
            for location in locationItems {
                let coordinate = location.coordinate
                coordinates.append(coordinate)
            }
            
            let polyLine = MKPolyline.init(coordinates: &coordinates, count: numberOfSteps)
            mapView.addOverlay(polyLine, level: MKOverlayLevel.AboveRoads)
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer.init(overlay: overlay)
        renderer.lineWidth = 5.0
        renderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.7)
        
        return renderer
    }
    
}

