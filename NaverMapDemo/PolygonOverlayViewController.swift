 /*
  Copyright 2018-2024 NAVER Corp.
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
  http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  */


import UIKit
import NMapsMap

class PolygonOverlayViewController: MapViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global(qos: .default).async {
            // 백그라운드 스레드
            let polygon = NMGPolygon(ring: NMGLineString(points: JinJuMapData().munsaneup))
            let polygonOverlay = NMFPolygonOverlay(polygon as! NMGPolygon<AnyObject>)
            polygonOverlay?.fillColor = .red
            polygonOverlay?.outlineColor = primaryColor
            polygonOverlay?.outlineWidth = 4
            
            DispatchQueue.main.async { [weak self] in
                polygonOverlay?.mapView = self?.mapView
            }
        }
        
        DispatchQueue.global(qos: .default).async {
            // 백그라운드 스레드
            let polygon = NMGPolygon(ring: NMGLineString(points: JinJuMapData().naedongmyeon))
            let polygonOverlay = NMFPolygonOverlay(polygon as! NMGPolygon<AnyObject>)
            polygonOverlay?.fillColor = .green
            polygonOverlay?.outlineColor = primaryColor
            polygonOverlay?.outlineWidth = 4
            
            DispatchQueue.main.async { [weak self] in
                polygonOverlay?.mapView = self?.mapView
            }
        }
        
        DispatchQueue.global(qos: .default).async {
            // 백그라운드 스레드
            let polygon = NMGPolygon(ring: NMGLineString(points: JinJuMapData().manggyeongdong))
            let polygonOverlay = NMFPolygonOverlay(polygon as! NMGPolygon<AnyObject>)
            polygonOverlay?.fillColor = .blue
            polygonOverlay?.outlineColor = primaryColor
            polygonOverlay?.outlineWidth = 4
            
            DispatchQueue.main.async { [weak self] in
                polygonOverlay?.mapView = self?.mapView
            }
        }
        
        DispatchQueue.global(qos: .default).async {
            // 백그라운드 스레드
            let polygon = NMGPolygon(ring: NMGLineString(points: JinJuMapData().gangnamdong))
            let polygonOverlay = NMFPolygonOverlay(polygon as! NMGPolygon<AnyObject>)
            polygonOverlay?.fillColor = .yellow
            polygonOverlay?.outlineColor = primaryColor
            polygonOverlay?.outlineWidth = 4
            
            DispatchQueue.main.async { [weak self] in
                polygonOverlay?.mapView = self?.mapView
            }
        }
        
        DispatchQueue.global(qos: .default).async {
            // 백그라운드 스레드
            let polygon = NMGPolygon(ring: NMGLineString(points: JinJuMapData().kangnamdong))
            let polygonOverlay = NMFPolygonOverlay(polygon as! NMGPolygon<AnyObject>)
            polygonOverlay?.fillColor = .purple
            polygonOverlay?.outlineColor = primaryColor
            polygonOverlay?.outlineWidth = 4
            
            DispatchQueue.main.async { [weak self] in
                polygonOverlay?.mapView = self?.mapView
            }
        }
        
        DispatchQueue.global(qos: .default).async {
            // 백그라운드 스레드
            var markers = [NMFMarker]()

            for (latitude, longitude) in JinJuMapData().chilamdongMarkers {
                let position = NMGLatLng(lat: latitude, lng: longitude)
                let marker = NMFMarker(position: position)
                marker.iconImage = NMFOverlayImage(name: "marker_star")  // 마커 아이콘 설정
                markers.append(marker)
            }

            DispatchQueue.main.async { [weak self] in
                // 메인 스레드
                for marker in markers {
                    marker.mapView = self?.mapView
                }
            }
        }
        
        DispatchQueue.global(qos: .default).async {
            // 백그라운드 스레드
            var markers = [NMFMarker]()

            for (latitude, longitude) in JinJuMapData().seongjidongMarkers {
                let position = NMGLatLng(lat: latitude, lng: longitude)
                let marker = NMFMarker(position: position)
                marker.iconImage = NMFOverlayImage(name: "baseline_room_black_24pt")  // 마커 아이콘 설정
                markers.append(marker)
            }

            DispatchQueue.main.async { [weak self] in
                // 메인 스레드
                for marker in markers {
                    marker.mapView = self?.mapView
                }
            }
        }

        DispatchQueue.global(qos: .default).async {
            // 백그라운드 스레드
            var markers = [NMFMarker]()

            for (latitude, longitude) in JinJuMapData().jungangdongMarkers {
                let position = NMGLatLng(lat: latitude, lng: longitude)
                let marker = NMFMarker(position: position)
                marker.iconImage = NMFOverlayImage(name: "mSNormalBlue")  // 마커 아이콘 설정
                markers.append(marker)
            }

            DispatchQueue.main.async { [weak self] in
                // 메인 스레드
                for marker in markers {
                    marker.mapView = self?.mapView
                }
            }
        }
    }

}
