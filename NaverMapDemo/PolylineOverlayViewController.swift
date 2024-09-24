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

class PolylineOverlayViewController: MapViewController {

//    let coords1 = [NMGLatLng(lat: 37.57152, lng: 126.97714),
//                   NMGLatLng(lat: 37.56607, lng: 126.98268),
//                   NMGLatLng(lat: 37.56445, lng: 126.97707),
//                   NMGLatLng(lat: 37.55855, lng: 126.97822)]
//    let coords2 = [NMGLatLng(lat: 37.57152, lng: 126.97714),
//                   NMGLatLng(lat: 37.5744287, lng: 126.982625)]
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        let lineString = NMGLineString(points: coords1)
////        let polylineOverlay = NMFPolylineOverlay(lineString as! NMGLineString<AnyObject>)
////        polylineOverlay?.width = 3
////        polylineOverlay?.color = primaryColor
////        polylineOverlay?.mapView = mapView
////        
////        let lineString2 = NMGLineString(points: coords2)
////        let polylineOverlay2 = NMFPolylineOverlay(lineString2 as! NMGLineString<AnyObject>)
////        polylineOverlay2?.width = 3
////        polylineOverlay2?.pattern = [10, 10]
////        polylineOverlay2?.color = UIColor.gray
////        polylineOverlay2?.mapView = mapView
//        
////        setupMaskedPolygon(mapView: mapView)
//        
//    }

//    func setupMaskedPolygon(mapView: NMFMapView) {
//        // 1. 큰 폴리곤 (지도의 외부 영역을 덮는 역할)
//        let outerCoordinates = [
//            NMGLatLng(lat: 90, lng: -180), // 북극 왼쪽 끝
//            NMGLatLng(lat: 90, lng: 180),  // 북극 오른쪽 끝
//            NMGLatLng(lat: -90, lng: 180), // 남극 오른쪽 끝
//            NMGLatLng(lat: -90, lng: -180) // 남극 왼쪽 끝
//        ]
//
//        // 2. 내부 폴리곤 (홀로 비워둘 실제 폴리곤 영역)
//        let innerPolygonCoordinates = [
//            NMGLatLng(lat: 35.19551418225615, lng: 128.0858098454484),
//            NMGLatLng(lat: 35.19540837805357, lng: 128.08542382093685),
//            NMGLatLng(lat: 35.19539748573792, lng: 128.08538404742217),
//            NMGLatLng(lat: 35.194739756613515, lng: 128.0899123739382),
//            NMGLatLng(lat: 35.192851905814194, lng: 128.09009363845146)
//            // 더 많은 좌표 추가 가능
//        ]
//        
//        // 3. 큰 폴리곤 생성
//        let outerPolygon = NMGPolygon()
//        outerPolygon.path = NMGLineString(points: outerCoordinates)
//        outerPolygon.holes = [NMGLineString(points: innerPolygonCoordinates)] // 내부 홀(비워둘 영역)
//        outerPolygon.fillColor = UIColor.lightGray.withAlphaComponent(0.7)  // 마스킹 색상 설정
//        outerPolygon.mapView = mapView
//        
//        // 4. 폴리곤 외부 영역만 마스킹 처리하고 내부는 비워둠
//        outerPolygon.mapView = mapView
//    }


    let coords1 = [NMGLatLng(lat: 37.5734571, lng: 126.975335),
                   NMGLatLng(lat: 37.5694007, lng: 126.9739434),
                   NMGLatLng(lat: 37.5678124, lng: 126.9812127),
                   NMGLatLng(lat: 37.5738912, lng: 126.9825649),
                   NMGLatLng(lat: 37.5734571, lng: 126.975335)]
    let coords2 = [NMGLatLng(lat: 37.5640984, lng: 126.9712268),
                   NMGLatLng(lat: 37.5651279, lng: 126.9767904),
                   NMGLatLng(lat: 37.5625365, lng: 126.9832241),
                   NMGLatLng(lat: 37.5585305, lng: 126.9809297),
                   NMGLatLng(lat: 37.5590777, lng: 126.974617),
                   NMGLatLng(lat: 37.5640984, lng: 126.9712268)]
    let holes = [NMGLatLng(lat: 37.5612243, lng: 126.9768938),
                 NMGLatLng(lat: 37.5627692, lng: 126.9795502),
                 NMGLatLng(lat: 37.5628377, lng: 126.976066),
                 NMGLatLng(lat: 37.5612243, lng: 126.9768938)]
    
    // 대한민국의 대략적인 경계 좌표
    let outerCoordinates = [
        NMGLatLng(lat: 38.634705, lng: 124.216453), // 북한 서쪽 끝
        NMGLatLng(lat: 38.634705, lng: 131.872222), // 동해 동쪽 끝
        NMGLatLng(lat: 33.190945, lng: 131.872222), // 남해 동쪽 끝
        NMGLatLng(lat: 33.190945, lng: 124.216453),  // 서해 서쪽 끝
        NMGLatLng(lat: 38.634705, lng: 124.216453) // 북한 서쪽 끝
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
//        let polygon2 = NMGPolygon(ring: NMGLineString(points: outerCoordinates), interiorRings: [NMGLineString(points: JinJuMapData().munsaneup), NMGLineString(points: JinJuMapData().naedongmyeon), NMGLineString(points: JinJuMapData().manggyeongdong), NMGLineString(points: JinJuMapData().kangnamdong)])
//        let polygonWithHole = NMFPolygonOverlay(polygon2 as! NMGPolygon<AnyObject>)
//        polygonWithHole?.fillColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 127.0/255.0)
//        polygonWithHole?.mapView = mapView
    }


}
