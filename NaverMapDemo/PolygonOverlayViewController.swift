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

    var munsaneupPolygonOverlays: NMFPolygonOverlay?
    var munsaneupCoordinate = [CoordinateModel]()

    var naedongmyeonPolygonOverlays: NMFPolygonOverlay?
    var naedongmyeonCoordinate = [CoordinateModel]()

    var manggyeongdongPolygonOverlays: NMFPolygonOverlay?
    var manggyeongdongCoordinate = [CoordinateModel]()
    
    var kangnamdongPolygonOverlays: NMFPolygonOverlay?
    var kangnamdongCoordinate = [CoordinateModel]()

    var chilamdongPolygonOverlays: NMFPolygonOverlay?
    var chilamdongCoordinate = [CoordinateModel]()
    var chilamdongMarkers = [NMFMarker]()
    
    var seongjidongPolygonOverlays: NMFPolygonOverlay?
    var seongjidongCoordinate = [CoordinateModel]()
    var seongjidongMarkers = [NMFMarker]()
    
    var jungangdongPolygonOverlays: NMFPolygonOverlay?
    var jungangdongCoordinate = [CoordinateModel]()
    var jungangdongMarkers = [NMFMarker]()

    let markersDefaultIcon = NMFOverlayImage(name: "marker_star")  // 마커 아이콘 설정
    
    let defaultExtnt: NMGLatLngBounds = NMGLatLngBounds(southWestLat: 31.43,
                                                        southWestLng: 122.37,
                                                        northEastLat: 44.35,
                                                        northEastLng: 132)
    
    /// 최소 줌레벨
    let defaultMinZoomLevel: Double = 5
    
    /// 최대 줌레벨
    var defaultMaxZoomLevel: Double = 21
        
    /// 기본 줌레벨
    var defaultZoomLevel: Double = 17
    
    deinit {
        
        chilamdongPolygonOverlays?.mapView = nil
        
        for marker in chilamdongMarkers {
            marker.mapView = nil
        }
        
        for marker in seongjidongMarkers {
            marker.mapView = nil
        }
        
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
        loadAndParseJSON(from: "jungangdong", into: &jungangdongCoordinate)
        loadAndParseJSON(from: "seongjidong", into: &seongjidongCoordinate)
        loadAndParseJSON(from: "chilamdong", into: &chilamdongCoordinate)
        loadAndParseJSON(from: "kangnamdong", into: &kangnamdongCoordinate)
        loadAndParseJSON(from: "manggyeongdong", into: &manggyeongdongCoordinate)
        loadAndParseJSON(from: "naedongmyeon", into: &naedongmyeonCoordinate)
        loadAndParseJSON(from: "munsaneup", into: &munsaneupCoordinate)
    }

    private func loadAndParseJSON(from fileName: String, into coordinates: inout [CoordinateModel]) {
        let jsonString = load(from: fileName)
        
        if let parsedCoordinates = parseJSON(from: jsonString) {
            coordinates = parsedCoordinates
            print("\(fileName) 디코딩 성공")
        } else {
            print("\(fileName) Failed to parse JSON")
        }
    }

    
    func setupMapConfig() {
        
        mapView.minZoomLevel = defaultMinZoomLevel
        mapView.maxZoomLevel = defaultMaxZoomLevel
        mapView.extent = defaultExtnt
        
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
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let wSelf = self else { return }
            
            var outerCoordinatesLatlng = [NMGLatLng]()
            for (latitude, longitude) in JinJuMapData.outerCoordinates {
                let nLatLng = NMGLatLng(lat: latitude, lng: longitude)
                outerCoordinatesLatlng.append(nLatLng)
            }
            
            var munsaneupLatlng = [NMGLatLng]()
            for coordinate in wSelf.munsaneupCoordinate {
                let position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
                munsaneupLatlng.append(position)
            }
            
            var naedongmyeonLatlng = [NMGLatLng]()
            for coordinate in wSelf.naedongmyeonCoordinate {
                let position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
                naedongmyeonLatlng.append(position)
            }
            
            var manggyeongdongLatlng = [NMGLatLng]()
            for coordinate in wSelf.manggyeongdongCoordinate {
                let position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
                manggyeongdongLatlng.append(position)
            }
            
            var kangnamdongLatlng = [NMGLatLng]()
            for coordinate in wSelf.kangnamdongCoordinate {
                let position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
                kangnamdongLatlng.append(position)
            }
            
            var chilamdongLatlng = [NMGLatLng]()
            for coordinate in wSelf.chilamdongCoordinate {
                let position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
                chilamdongLatlng.append(position)
            }
            
            var seongjidongLatlng = [NMGLatLng]()
            for coordinate in wSelf.seongjidongCoordinate {
                let position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
                seongjidongLatlng.append(position)
            }
            
            var jungangdongLatlng = [NMGLatLng]()
            for coordinate in wSelf.jungangdongCoordinate {
                let position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
                jungangdongLatlng.append(position)
            }
            
            let polygon2 = NMGPolygon(ring: NMGLineString(points: outerCoordinatesLatlng),
                                      interiorRings: [NMGLineString(points: munsaneupLatlng),
                                                      NMGLineString(points: naedongmyeonLatlng),
                                                      NMGLineString(points: manggyeongdongLatlng),
                                                      NMGLineString(points: kangnamdongLatlng),
                                                      NMGLineString(points: chilamdongLatlng),
                                                      NMGLineString(points: seongjidongLatlng),
                                                      NMGLineString(points: jungangdongLatlng)])
            let polygonWithHole = NMFPolygonOverlay(polygon2 as! NMGPolygon<AnyObject>)
            polygonWithHole?.fillColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 127.0/255.0)
            
            DispatchQueue.main.async { [weak self] in
                polygonWithHole?.mapView = self?.mapView
            }
        }
    }
    
    func setupPolygon() {
        
        if let polygonOverlay = addPolygonOverlay(coordinates: munsaneupCoordinate, mapView: mapView, fillColor: .clear, outlineColor: .red, outlineWidth: 4) {
            munsaneupPolygonOverlays = polygonOverlay
        }
        
        if let polygonOverlay = addPolygonOverlay(coordinates: naedongmyeonCoordinate, mapView: mapView, fillColor: .clear, outlineColor: .blue, outlineWidth: 4) {
            naedongmyeonPolygonOverlays = polygonOverlay
        }
        
        if let polygonOverlay = addPolygonOverlay(coordinates: manggyeongdongCoordinate, mapView: mapView, fillColor: .clear, outlineColor: .yellow, outlineWidth: 4) {
            manggyeongdongPolygonOverlays = polygonOverlay
        }
        
        if let polygonOverlay = addPolygonOverlay(coordinates: kangnamdongCoordinate, mapView: mapView, fillColor: .clear, outlineColor: .brown, outlineWidth: 4) {
            kangnamdongPolygonOverlays = polygonOverlay
        }
        
        if let polygonOverlay = addPolygonOverlay(coordinates: chilamdongCoordinate, mapView: mapView, fillColor: .clear, outlineColor: .magenta, outlineWidth: 4) {
            chilamdongPolygonOverlays = polygonOverlay
        }
        
        if let polygonOverlay = addPolygonOverlay(coordinates: seongjidongCoordinate, mapView: mapView, fillColor: .clear, outlineColor: .cyan, outlineWidth: 4) {
            seongjidongPolygonOverlays = polygonOverlay
        }
        
        if let polygonOverlay = addPolygonOverlay(coordinates: jungangdongCoordinate, mapView: mapView, fillColor: .clear, outlineColor: .orange, outlineWidth: 4) {
            jungangdongPolygonOverlays = polygonOverlay
        }
    }
    
    func setupMarker() {
        
        _ = chilamdongMarkers.map { $0.mapView = nil }
        chilamdongMarkers.removeAll()
        createMarkers(for: chilamdongCoordinate, mapView: mapView) { [weak self] newMarkers in
            guard let wSelf = self else { return }
            wSelf.chilamdongMarkers = newMarkers
        }

        _ = seongjidongMarkers.map { $0.mapView = nil }
        seongjidongMarkers.removeAll()
        createMarkers(for: seongjidongCoordinate, mapView: mapView) { [weak self] newMarkers in
            guard let wSelf = self else { return }
            wSelf.seongjidongMarkers = newMarkers
        }

        _ = jungangdongMarkers.map { $0.mapView = nil }
        jungangdongMarkers.removeAll()
        createMarkers(for: jungangdongCoordinate, mapView: mapView) { [weak self] newMarkers in
            guard let wSelf = self else { return }
            wSelf.jungangdongMarkers = newMarkers
        }
    }
    
    func createMarkers(for coordinates: [CoordinateModel], mapView: NMFMapView?, markers: @escaping ([NMFMarker]) -> Void) {

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
    
    func addPolygonOverlay(coordinates: [CoordinateModel], mapView: NMFMapView?, fillColor: UIColor = .clear, outlineColor: UIColor = .green, outlineWidth: UInt = 4) -> NMFPolygonOverlay? {
        // 좌표 데이터를 NMGLatLng로 변환
        var polygonLatLng = [NMGLatLng]()
        for coordinate in coordinates {
            let position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
            polygonLatLng.append(position)
        }

        // 다각형 생성
        let polygon = NMGPolygon(ring: NMGLineString(points: polygonLatLng))
        let polygonOverlay = NMFPolygonOverlay(polygon as! NMGPolygon<AnyObject>)
        polygonOverlay?.fillColor = fillColor
        polygonOverlay?.outlineColor = outlineColor
        polygonOverlay?.outlineWidth = outlineWidth

        // 다각형 오버레이를 지도에 추가
        polygonOverlay?.mapView = mapView
        
        return polygonOverlay
    }

    
    // 두 좌표 사이의 유클리드 거리 계산 함수
    func calculateDistance(from: NMGLatLng, to: NMGLatLng) -> Double {
        let latDiff = from.lat - to.lat
        let lngDiff = from.lng - to.lng
        return sqrt(latDiff * latDiff + lngDiff * lngDiff)
    }

    // 중앙 좌표에서 가장 가까운 마커 찾기
    func findNearestMarker(from center: NMGLatLng, coordinates: [CoordinateModel]) -> NMGLatLng? {

        if coordinates.isEmpty {
            return nil
        }
        
        var nearestMarker: NMGLatLng = NMGLatLng(lat: coordinates[0].latitude, lng: coordinates[0].longitude)
        var minDistance = calculateDistance(from: center, to: nearestMarker)

        for coordinate in coordinates {
            let markerLatLng = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
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

    // JSON 문자열을 [CoordinateModel]로 변환하는 함수
    func parseJSON(from jsonString: String) -> [CoordinateModel]? {
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        
        do {
            let decodedData = try JSONDecoder().decode([CoordinateModel].self, from: jsonData)
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
        guard let nearestMarkerPosition = findNearestMarker(from: centerLatLng, coordinates: chilamdongCoordinate) else {
            return
        }
        
        drawLine(from: centerLatLng, to: nearestMarkerPosition)
    }
}
