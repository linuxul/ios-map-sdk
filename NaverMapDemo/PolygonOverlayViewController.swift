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
    
    var seongidongCoordinate = [MapCoordinateModel]()
    var seongidongMarkers = [NMFMarker]()
    
    var jungangdongCoordinate = [MapCoordinateModel]()
    var jungangdongMarkers = [NMFMarker]()

    let markersDefaultIcon = NMFOverlayImage(name: "marker_star")  // 마커 아이콘 설정
    
    deinit {
        // 메모리 삭제
        for marker in jungangdongMarkers {
            marker.mapView = nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        readJsonFile()
        setupMapConfig()
        setupGolygonArea()
        setupPolygon()
        setupMarker()
        setupNearestMarker()
    }
    
    func readJsonFile() {

        // 실제 사용 예시
        let jungangdongJson = load(from: "jungangdong")  // 파일 이름에 맞게 변경 필요
        if let coordinates = parseJSON(from: jungangdongJson) {
            jungangdongCoordinate = coordinates
            print("#1 디코딩 성공")
        } else {
            print("#1 Failed to parse JSON")
        }
        
        // 실제 사용 예시
        let seongidongJson = load(from: "seongjidong")  // 파일 이름에 맞게 변경 필요
        if let coordinates = parseJSON(from: seongidongJson) {
            seongidongCoordinate = coordinates
            print("#1 디코딩 성공")
        } else {
            print("#1 Failed to parse JSON")
        }
    }
    
    func setupMapConfig() {
        
        naverMapView.showLocationButton = true
        
    }
    
    func setupNearestMarker() {
        
        centralMarker = NMFMarker()
        centralMarker?.position = mapView.cameraPosition.target      // 초기 중앙 좌표 설정
        centralMarker?.mapView = mapView

        // 2. 카메라 이동 이벤트 리스너 설정
        mapView.addCameraDelegate(delegate: self)
    }
    
    func setupGolygonArea() {
        
        // 대한민국을 바탕으로 회색으로 처리를 하고 구역내에 사항은 안에 사항으로 처리
        DispatchQueue.global(qos: .default).async {
            
            var latlngOuterCoordinates = [NMGLatLng]()
            for (latitude, longitude) in JinJuMapData.outerCoordinates {
                let nLatLng = NMGLatLng(lat: latitude, lng: longitude)
                latlngOuterCoordinates.append(nLatLng)
            }
            
            var latlngMunsaneup = [NMGLatLng]()
            for (latitude, longitude) in JinJuMapData.munsaneup {
                let nLatLng = NMGLatLng(lat: latitude, lng: longitude)
                latlngMunsaneup.append(nLatLng)
            }
            
//            var latlngNaedongmyeon = [NMGLatLng]()
//            for (latitude, longitude) in JinJuMapData.naedongmyeon {
//                let nLatLng = NMGLatLng(lat: latitude, lng: longitude)
//                latlngNaedongmyeon.append(nLatLng)
//            }
            
            var latlngManggyeongdong = [NMGLatLng]()
            for (latitude, longitude) in JinJuMapData.manggyeongdong {
                let nLatLng = NMGLatLng(lat: latitude, lng: longitude)
                latlngManggyeongdong.append(nLatLng)
            }
            
            var latlngKangnamdong = [NMGLatLng]()
            for (latitude, longitude) in JinJuMapData.kangnamdong {
                let nLatLng = NMGLatLng(lat: latitude, lng: longitude)
                latlngKangnamdong.append(nLatLng)
            }
            
            let polygon2 = NMGPolygon(ring: NMGLineString(points: latlngOuterCoordinates),
                                      interiorRings: [NMGLineString(points: latlngMunsaneup),
//                                                      NMGLineString(points: latlngNaedongmyeon),
                                                      NMGLineString(points: latlngManggyeongdong),
                                                      NMGLineString(points: latlngKangnamdong)])
            let polygonWithHole = NMFPolygonOverlay(polygon2 as! NMGPolygon<AnyObject>)
            polygonWithHole?.fillColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 127.0/255.0)
            
            DispatchQueue.main.async { [weak self] in
                polygonWithHole?.mapView = self?.mapView
            }
        }
    }
    
    func setupPolygon() {
        
        DispatchQueue.global(qos: .default).async {

            var polyongLatLng = [NMGLatLng]()
            for (latitude, longitude) in JinJuMapData.munsaneup {
                let nLatLng = NMGLatLng(lat: latitude, lng: longitude)
                polyongLatLng.append(nLatLng)
            }
            
            let polygon = NMGPolygon(ring: NMGLineString(points: polyongLatLng))
            let polygonOverlay = NMFPolygonOverlay(polygon as! NMGPolygon<AnyObject>)
            polygonOverlay?.fillColor = .clear
            polygonOverlay?.outlineColor = .red
            polygonOverlay?.outlineWidth = 4
            
            DispatchQueue.main.async { [weak self] in
                polygonOverlay?.mapView = self?.mapView
            }
        }
        
//        DispatchQueue.global(qos: .default).async {
//            
//            var polyongLatLng = [NMGLatLng]()
//            for (latitude, longitude) in JinJuMapData.naedongmyeon {
//                let nLatLng = NMGLatLng(lat: latitude, lng: longitude)
//                polyongLatLng.append(nLatLng)
//            }
//
//            let polygon = NMGPolygon(ring: NMGLineString(points: polyongLatLng))
//            let polygonOverlay = NMFPolygonOverlay(polygon as! NMGPolygon<AnyObject>)
//            polygonOverlay?.fillColor = .clear
//            polygonOverlay?.outlineColor = .blue
//            polygonOverlay?.outlineWidth = 4
//            
//            DispatchQueue.main.async { [weak self] in
//                polygonOverlay?.mapView = self?.mapView
//            }
//        }
        
        DispatchQueue.global(qos: .default).async {
            // 백그라운드 스레드
            var polyongLatLng = [NMGLatLng]()
            for (latitude, longitude) in JinJuMapData.manggyeongdong {
                let nLatLng = NMGLatLng(lat: latitude, lng: longitude)
                polyongLatLng.append(nLatLng)
            }
            
            let polygon = NMGPolygon(ring: NMGLineString(points: polyongLatLng))
            let polygonOverlay = NMFPolygonOverlay(polygon as! NMGPolygon<AnyObject>)
            polygonOverlay?.fillColor = .clear
            polygonOverlay?.outlineColor = .yellow
            polygonOverlay?.outlineWidth = 4
            
            DispatchQueue.main.async { [weak self] in
                polygonOverlay?.mapView = self?.mapView
            }
        }
        
        DispatchQueue.global(qos: .default).async {

            // 백그라운드 스레드
            var polyongLatLng = [NMGLatLng]()
            for (latitude, longitude) in JinJuMapData.kangnamdong {
                let nLatLng = NMGLatLng(lat: latitude, lng: longitude)
                polyongLatLng.append(nLatLng)
            }
            
            let polygon = NMGPolygon(ring: NMGLineString(points: polyongLatLng))
            let polygonOverlay = NMFPolygonOverlay(polygon as! NMGPolygon<AnyObject>)
            polygonOverlay?.fillColor = .clear
            polygonOverlay?.outlineColor = .brown
            polygonOverlay?.outlineWidth = 4
            
            DispatchQueue.main.async { [weak self] in
                polygonOverlay?.mapView = self?.mapView
            }
        }
        
        
        DispatchQueue.global(qos: .default).async {
            // 백그라운드 스레드
            var polyongLatLng = [NMGLatLng]()
            for (latitude, longitude) in JinJuMapData.chilamdongMarkers {
                let nLatLng = NMGLatLng(lat: latitude, lng: longitude)
                polyongLatLng.append(nLatLng)
            }
            
            let polygon = NMGPolygon(ring: NMGLineString(points: polyongLatLng))
            let polygonOverlay = NMFPolygonOverlay(polygon as! NMGPolygon<AnyObject>)
            polygonOverlay?.fillColor = .clear
            polygonOverlay?.outlineColor = .magenta
            polygonOverlay?.outlineWidth = 4
            
            DispatchQueue.main.async { [weak self] in
                polygonOverlay?.mapView = self?.mapView
            }
        }
    }
    
    func setupMarker() {
        
        DispatchQueue.global(qos: .default).async {
            // 백그라운드 스레드
            var markers = [NMFMarker]()
            let markersIcon = NMFOverlayImage(name: "marker_star")  // 마커 아이콘 설정

            for (latitude, longitude) in JinJuMapData.chilamdongMarkers {
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

        seongidongMarkers = []  // MARK: 메모리 해제 필요
        createMarkers(for: seongidongCoordinate, mapView: mapView) { [weak self] newMarkers in
            guard let wSelf = self else { return }
            wSelf.seongidongMarkers = newMarkers
        }


        // 마커 생성 및 업데이트
        jungangdongMarkers = [] // MARK: 메모리 해제 필요
        createMarkers(for: jungangdongCoordinate, mapView: mapView) { [weak self] newMarkers in
            guard let wSelf = self else { return }
            wSelf.jungangdongMarkers = newMarkers
        }
    }
    
    func createMarkers(for coordinates: [MapCoordinateModel], mapView: NMFMapView?, markers: @escaping ([NMFMarker]) -> Void) {

        DispatchQueue.global(qos: .default).async { [weak self, weak mapView] in
            guard let wSelf = self else { return }
            
            var tempMarkers = [NMFMarker]()  // 임시 마커 배열

            for coordinate in coordinates {
                let position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
                let marker = NMFMarker(position: position)
                marker.iconImage = wSelf.markersDefaultIcon     // 메모리 관리를 위해서 하나의 이미지로 사용
                tempMarkers.append(marker)
            }

            DispatchQueue.main.async {
                guard let mapView = mapView else { return }

                // 마커들을 메인 스레드에서 설정
                for marker in tempMarkers {
                    marker.mapView = mapView
                }

                // markers 배열 업데이트
                markers(tempMarkers)
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
    
    @IBAction func goCityHole(_ sender: Any) {
        
        // 진주시청 위치 (위도, 경도)
        let jinjuCityHallPosition = NMGLatLng(lat: 35.180223, lng: 128.107669)
        mapView.moveCamera(NMFCameraUpdate(scrollTo: jinjuCityHallPosition))
    }
    
    
    // JSON 파일을 로드하는 함수
    func load(from fileName: String, extensionType: String = "json") -> String {
        guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return "" }
        
        do {
            let jsonData = try Data(contentsOf: fileLocation)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            return jsonString
        } catch {
            print("Error loading JSON file: \(error.localizedDescription)")
            return ""
        }
    }

    // JSON 문자열을 [MapCoordinateModel]로 변환하는 함수
    func parseJSON(from jsonString: String) -> [MapCoordinateModel]? {
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        
        do {
            let decodedData = try JSONDecoder().decode([MapCoordinateModel].self, from: jsonData)
            return decodedData
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
            return nil
        }
    }

}

extension PolygonOverlayViewController: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        // 카메라가 움직일 때마다 지도 중앙 좌표로 마커의 위치를 업데이트
        let centerLatLng = mapView.cameraPosition.target
        centralMarker?.position = centerLatLng
        
        // 가장 가까운 마커 찾기
        let nearestMarkerPosition = findNearestMarker(from: centerLatLng, markers: JinJuMapData.chilamdongMarkers)
        
        // 경로 그리기
        drawLine(from: centerLatLng, to: nearestMarkerPosition)
    }
}
