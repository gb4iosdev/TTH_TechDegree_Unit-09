//
//  MKMapView.swift
//  DiaryApp
//
//  Created by Gavin Butler on 20-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import MapKit

extension MKMapView {
    
    //Sets the map’s region given a co-ordinate and span
    private func setRegion(around coordinate: CLLocationCoordinate2D, withSpan span: Double) {
        let span = MKCoordinateRegion(center: coordinate, latitudinalMeters: span, longitudinalMeters: span).span
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.setRegion(region, animated: true)
    }
    
    //Centre the map around a coordinate, set it's span and draw the monitoring region circle
    func adjust(centreTo centre: CLLocationCoordinate2D, span: Double, regionRadius: Double) {
        
        self.setRegion(around: centre, withSpan: span)
        
        //Remove any existing overlays
        let overlays = self.overlays
        self.removeOverlays(overlays)
        
        let circle = MKCircle(center: centre, radius: regionRadius)
        self.addOverlay(circle)
    }
    
    //Circle visual characteristics
    func renderer(for overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
            circleRenderer.fillColor = .cyan
            circleRenderer.strokeColor = .black
            circleRenderer.lineWidth = 2.0
            circleRenderer.alpha = 0.3
            return circleRenderer
        } else {
            return MKOverlayRenderer()
        }
    }

}



