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

    // 1. 마커를 변수로 설정
    var centralMarker: NMFMarker?
    var polyline: NMFPolylineOverlay?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralMarker = NMFMarker()
//        centralMarker?.iconImage = NMFOverlayImage(name: "pointer") // 대여 아이콘 이미지 설정
        centralMarker?.position = mapView.cameraPosition.target      // 초기 중앙 좌표 설정
        centralMarker?.mapView = mapView
        
        // 2. 카메라 이동 이벤트 리스너 설정
        mapView.addCameraDelegate(delegate: self)

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
            let markersIcon = NMFOverlayImage(name: "marker_star")  // 마커 아이콘 설정

            for (latitude, longitude) in JinJuMapData().chilamdongMarkers {
                let position = NMGLatLng(lat: latitude, lng: longitude)
                let marker = NMFMarker(position: position)
                marker.iconImage = markersIcon
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
            let markersIcon = NMFOverlayImage(name: "baseline_room_black_24pt")  // 마커 아이콘 설정

            for (latitude, longitude) in JinJuMapData().seongjidongMarkers {
                let position = NMGLatLng(lat: latitude, lng: longitude)
                let marker = NMFMarker(position: position)
                marker.iconImage = markersIcon
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
            let markersIcon = NMFOverlayImage(name: "mSNormalBlue")  // 마커 아이콘 설정

            for (latitude, longitude) in JinJuMapData().jungangdongMarkers {
                let position = NMGLatLng(lat: latitude, lng: longitude)
                let marker = NMFMarker(position: position)
                marker.iconImage = markersIcon
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
    
    
    // 두 좌표 사이의 유클리드 거리 계산 함수
    func calculateDistance(from: NMGLatLng, to: NMGLatLng) -> Double {
        let latDiff = from.lat - to.lat
        let lngDiff = from.lng - to.lng
        return sqrt(latDiff * latDiff + lngDiff * lngDiff)
    }

    // 중앙 좌표에서 가장 가까운 마커 찾기
    func findNearestMarker(from center: NMGLatLng, markers: [(Double, Double)]) -> NMGLatLng {
        var nearestMarker: NMGLatLng = NMGLatLng(lat: markers[0].0, lng: markers[0].1)
        var minDistance = calculateDistance(from: center, to: nearestMarker)

        for (latitude, longitude) in markers {
            let markerLatLng = NMGLatLng(lat: latitude, lng: longitude)
            let distance = calculateDistance(from: center, to: markerLatLng)
            
            if distance < minDistance {
                nearestMarker = markerLatLng
                minDistance = distance
            }
        }

        return nearestMarker
    }

    // 두 좌표 사이에 라인을 그리는 함수
    func drawLine(from start: NMGLatLng, to end: NMGLatLng) {
        polyline?.mapView = nil // 기존 라인을 제거

        // 새로운 라인 생성
        let path = NMGLineString(points: [start, end])
        polyline = NMFPolylineOverlay(path as! NMGLineString<AnyObject>)
        polyline?.color = UIColor.red // 라인의 색상 설정
        polyline?.width = 4.0 // 라인의 두께 설정
        polyline?.mapView = mapView // 지도에 라인 추가
    }

}

extension PolygonOverlayViewController: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        // 카메라가 움직일 때마다 지도 중앙 좌표로 마커의 위치를 업데이트
        let centerLatLng = mapView.cameraPosition.target
        centralMarker?.position = centerLatLng
        
        // 가장 가까운 마커 찾기
        let nearestMarkerPosition = findNearestMarker(from: centerLatLng, markers: JinJuMapData().chilamdongMarkers)
        
        // 경로 그리기
        drawLine(from: centerLatLng, to: nearestMarkerPosition)
    }
}
