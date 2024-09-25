//
//  JinJuMapDataOuter.swift
//  NaverMapDemo
//
//  Created by jsseo on 9/25/24.
//  Copyright © 2024 NaverCorp. All rights reserved.
//

import Foundation

import Foundation
import NMapsMap

struct JinJuMapData {
    
    // 북한을 포함한 한반도의 대략적인 경계 좌표 (서쪽부터 시계방향으로)
    static let outerCoordinates = [
        (43.002989, 123.002556), // 북한 북서쪽 끝 (중국과의 국경)
        (43.002989, 131.872222), // 북한 북동쪽 끝 (러시아와의 국경)
        (33.190945, 131.872222), // 남한 남동쪽 끝 (동해)
        (33.190945, 123.002556), // 남한 남서쪽 끝 (서해)
        (43.002989, 123.002556)  // 북한 북서쪽 끝
    ]
    
}
